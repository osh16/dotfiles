#!/usr/bin/env python3

# This script serves as duct tape to make the multiple monitor experience
# on GNOME 3 just a little bit better. Currently, the only functionality of
# this script is to switch focus from one monitor to the next, while respecting
# the stacking order of windows inside each individual monitor. However, the
# script is designed to make it easy to add more functionality later. Namely,
# when the script is run, it reads the current monitor, desktop and window
# configuration into a convenient in-memory data structure.
#
# This program is made simply by relying on some external commands:
#
#   wmctrl
#   xprop
#   gohead (if not available, then xrandr is used)
#
# gohead can be installed from: https://github.com/BurntSushi/gohead
# The only advantage of gohead is that it can be used to give "nice" names
# to your monitors. For example, on my laptop, I have this:
#
#     $ cat ~/.config/gohead/config.ini
#     [Monitors]
#     laptop = DP-0
#     left = DP-2
#     right = HDMI-0
#
# You can then run `x11-gnome-do focus-monitor left`. If your monitor
# configuration ever changes, then you just need to update the gohead
# mapping.

import argparse
import os
import re
from collections import OrderedDict, namedtuple
import subprocess


class Monitor(namedtuple('Monitor', [
    'index',
    'nice_name',
    'output_name',
    'x',
    'y',
    'width',
    'height',
    'primary',
])):
    @staticmethod
    def parse_gohead(gohead_line):
        parser = re.compile('''(?xm)
            ^
            (?P<index>[0-9]+)
            \s+
            (?P<nice>\S+)
            \s+
            (?P<output>\S+)
            \s+
            (?P<x>[0-9]+)
            \s+
            (?P<y>[0-9]+)
            \s+
            (?P<width>[0-9]+)
            \s+
            (?P<height>[0-9]+)
            \s*
            (?P<primary>primary)?
            \s*
            $
        ''')
        m = parser.match(gohead_line)
        if m is None:
            raise Exception(f'invalid gohead monitor line: "{gohead_line}"')
        return Monitor(
            index=int(m.group('index')),
            nice_name=m.group('nice'),
            output_name=m.group('output'),
            x=int(m.group('x')),
            y=int(m.group('y')),
            width=int(m.group('width')),
            height=int(m.group('height')),
            primary=m.group('primary') == 'primary',
        )

    @staticmethod
    def parse_xrandr(index, xrandr_line):
        '''
        Parses a monitor configuration from a line outputted by xrandr.
        The line must start with "OUTPUT-NAME connected".
        '''
        parser = re.compile('''(?xm)
            ^
            (?P<output>\S+)
            \s+
            connected
            \s+
            (?P<primary>primary)?\s*
            (?P<width>[0-9]+)x(?P<height>[0-9]+)
            \+(?P<x>[0-9]+)\+(?P<y>[0-9]+)
            \s+
        ''')
        m = parser.match(xrandr_line)
        if m is None:
            raise Exception(f'invalid xrandr monitor line: "{xrandr_line}"')
        return Monitor(
            index=index,
            nice_name=m.group('output'),
            output_name=m.group('output'),
            x=int(m.group('x')),
            y=int(m.group('y')),
            width=int(m.group('width')),
            height=int(m.group('height')),
            primary=m.group('primary') == 'primary',
        )

    def contains(self, win):
        # For now, we just check which monitor contains the top left corner of
        # the window, even if the window has more overlap with a different
        # monitor.
        return (
            win.x >= self.x
            and win.y >= self.y
            and win.x < (self.x + self.width)
            and win.y < (self.y + self.height)
        )

    def is_name_match(self, name):
        name = name.lower()
        return name in [self.nice_name.lower(), self.output_name.lower()]


class Desktop(namedtuple('Desktop', [
    'index',
    'name',
    'current',
    'width',
    'height',
    'work_x',
    'work_y',
    'work_width',
    'work_height',
    'windows',
])):
    @staticmethod
    def parse(wmctrl_line):
        parser = re.compile('''(?xm)
            ^
            (?P<index>[0-9]+)
            \s+
            (?P<current>-|\*)
            \s+
            DG:\s+(?P<width>[0-9]+)x(?P<height>[0-9]+)
            \s+
            VP:\s+\S+
            \s+
            WA:\s+(?P<wx>[0-9]+),(?P<wy>[0-9]+)
               \s+(?P<wwidth>[0-9]+)x(?P<wheight>[0-9]+)
            \s*
            (?P<name>.*)
            \s*
            $
        ''')
        m = parser.match(wmctrl_line)
        if m is None:
            raise Exception(f'invalid wmctrl desktop line: "{wmctrl_line}"')
        return Desktop(
            index=int(m.group('index')),
            name=m.group('name') or None,
            current=m.group('current') == '*',
            width=int(m.group('width')),
            height=int(m.group('height')),
            work_x=int(m.group('wx')),
            work_y=int(m.group('wy')),
            work_width=int(m.group('wwidth')),
            work_height=int(m.group('wheight')),
            windows=[],
        )


class Window(namedtuple('Window', [
    'id',
    'name',
    'monitor',
    'desktop_index',
    'desktop',
    'x',
    'y',
    'width',
    'height',
    'client_name',
])):
    @staticmethod
    def parse(wmctrl_line):
        parser = re.compile('''(?xm)
            ^
            (?P<id>0x[0-9a-fA-F]+)
            \s+
            (?P<desk>[0-9]+)
            \s+
            (?P<x>[0-9]+)
            \s+
            (?P<y>[0-9]+)
            \s+
            (?P<width>[0-9]+)
            \s+
            (?P<height>[0-9]+)
            \s+
            (?P<client>\S+)
            \s*
            (?P<name>.*)
            \s*
            $
        ''')
        m = parser.match(wmctrl_line)
        if m is None:
            raise Exception(f'invalid wmctrl window line: "{wmctrl_line}"')
        return Window(
            id=int(m.group('id'), base=16),
            name=m.group('name'),
            monitor=None,
            desktop_index=int(m.group('desk')),
            desktop=None,
            x=int(m.group('x')),
            y=int(m.group('y')),
            width=int(m.group('width')),
            height=int(m.group('height')),
            client_name=m.group('client'),
        )

    def is_sticky(self):
        return self.desktop_index == -1


def read_monitors():
    '''
    Read the existing monitor configuration. This only includes
    monitors that are both connected and active.

    This attempts to use gohead first, which permits associating "nice"
    names with monitors. If gohead isn't installed, then xrandr is
    used.

    The dictionary returned is keyed by the monitor's "nice" name. (Or
    just output name if gohead isn't available.)
    '''
    gohead = os.path.join(os.getenv('HOME'), '.gox11', 'bin', 'gohead')
    if not os.path.exists(gohead):
        return read_monitors_xrandr()

    out = subprocess.run(
        [gohead, 'tabs'],
        encoding='utf-8',
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )

    monitors = OrderedDict()
    for line in out.stdout.splitlines():
        mon = Monitor.parse_gohead(line)
        monitors[mon.nice_name] = mon
    return monitors


def read_monitors_xrandr():
    '''
    Read monitor configuration directly from xrandr.

    This is useful for folks that don't have BurntSushi/gohead
    installed.
    '''
    out = subprocess.run(
        ['xrandr', '-q'],
        encoding='utf-8',
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )

    monitors = OrderedDict()
    index = 0
    for line in out.stdout.splitlines():
        # Make sure we only try to parse monitors that are not only
        # connected, but have an active resolution assigned to them.
        if not re.match('\S+\s+connected(\s+primary)?\s+[0-9]+', line):
            continue
        mon = Monitor.parse_xrandr(index, line)
        monitors[mon.nice_name] = mon
        index += 1
    return monitors


def read_desktops():
    '''
    Read in all available desktops.

    The map returned is keyed by desktop index.
    '''
    out = subprocess.run(
        ['wmctrl', '-d'],
        encoding='utf-8',
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )

    desktops = OrderedDict()
    for line in out.stdout.splitlines():
        desk = Desktop.parse(line)
        desktops[desk.index] = desk
    return desktops


def read_windows(mons, desks):
    '''
    Read in all visible windows.

    mons and desks must be the current set of monitors and
    desktops. Each window returned is attached to the
    corresponding monitor and desktop.
    '''
    out = subprocess.run(
        ['wmctrl', '-l', '-G'],
        encoding='utf-8',
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )

    unordered = {}
    for line in out.stdout.splitlines():
        win = Window.parse(line)
        unordered[win.id] = win

    windows = OrderedDict()
    for wid in read_stacking_window_ids():
        win = unordered[wid]
        for mon in mons.values():
            if mon.contains(win):
                win = win._replace(monitor=mon)
                break
        if not win.is_sticky():
            win = win._replace(desktop=desks[win.desktop_index])
            win.desktop.windows.append(win)
        windows[win.id] = win
    return windows


def read_stacking_window_ids():
    '''
    Read a list of window IDs corresponding to the global stacking
    order of all open windows. The list returned is in bottom-to-top
    order.
    '''
    out = subprocess.run(
        ['xprop', '-root', '_NET_CLIENT_LIST_STACKING'],
        encoding='utf-8',
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )

    for m in re.finditer('0x[0-9a-fA-F]+', out.stdout):
        yield int(m.group(0), base=16)


def current_desktop(desks):
    '''
    Find and return the currently active desktop in the given desktops.
    '''
    for d in desks.values():
        if d.current:
            return d
    return None


def find_monitor(mons, name):
    '''
    Searches for a monitor by matching any one of its names, case
    insensitively, to the name given.
    '''
    for m in mons.values():
        if m.is_name_match(name):
            return m
    return None


def cmd_focus_monitor(mons, desks, wins, monitor_name):
    '''
    Find the most recently used window on the monitor with the given
    name and focus it. Also, move the mouse to the top-left corner of
    the monitor.
    '''
    mon = find_monitor(mons, monitor_name)
    curdesk = current_desktop(desks)
    for w in reversed(curdesk.windows):
        if w.monitor is not None and w.monitor.index == mon.index:
            subprocess.run(['wmctrl', '-i', '-a', str(w.id)])
            break

    # And also move the mouse to the top-left corner of the
    # corresponding monitor.
    subprocess.run(['xdotool', 'mousemove', str(mon.x), str(mon.y)])


if __name__ == '__main__':
    p = argparse.ArgumentParser(
        description='miscellaneous X11 commands for use in window managers '
                    'with shitty multi-monitor support'
    )
    subps = p.add_subparsers(dest='cmd')

    subp = subps.add_parser(
        'focus-monitor',
        description='Focus the most recently used window on the monitor '
                    'provided.',
    )
    subp.add_argument('monitor_name')

    args = p.parse_args()

    mons = read_monitors()
    desks = read_desktops()
    wins = read_windows(mons, desks)

    if args.cmd == 'focus-monitor':
        cmd_focus_monitor(mons, desks, wins, args.monitor_name)
    else:
        raise Exception(f'unrecognized command "{args.cmd}"')
