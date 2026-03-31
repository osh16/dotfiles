# AGENTS.md - Coding Guidelines for This Repository

## Repository Overview

This is a **dotfiles repository** containing shell scripts, Lua configuration files (primarily for Neovim), and various system configurations. The codebase includes:
- Shell scripts in `local/.local/bin/` for system utilities
- Lua configuration for Neovim in `nvim/.config/nvim/`
- Configuration files for other tools (tmux, zsh, alacritty, etc.)

---

## Build, Lint, and Test Commands

This repository does **not have traditional build/test infrastructure** as it's a dotfiles repo. However, here's how to work with different components:

### Shell Scripts
```bash
# Check syntax without executing
bash -n local/.local/bin/script_name.sh

# Run shellcheck for linting (if installed)
shellcheck local/.local/bin/*.sh
```

### Lua Files
```bash
# Check Lua syntax (requires lua installed)
lua -l luacheck local/.local/bin/script_name.lua

# Format Lua with stylua (if installed)
stylua nvim/.config/nvim/
```

### Manual Testing
- Shell scripts can be tested directly by sourcing or executing them
- Lua configuration changes can be tested by reloading Neovim

---

## Code Style Guidelines

### Shell Scripts

**Shebang:**
- Always use `#!/usr/bin/env bash` for portability

**Formatting:**
- Use 2-space indentation (matching Neovim Lua style)
- Quote all variables: `"${var}"` not `$var`
- Use lower_snake_case for variable names

**Example:**
```bash
#!/usr/bin/env bash

if [[ -z "${search_term}" ]]; then
  echo "Error: search_term is required"
  exit 1
fi

result=$(some_command "${search_term}")
```

**Error Handling:**
- Always check exit codes for important operations
- Use `set -euo pipefail` in scripts that need strict error handling
- Provide helpful error messages before exiting

**Comments:**
- Use `# Comment here` for single-line comments
- Explain "why" not "what" - code should be self-documenting

---

### Lua Files

**Indentation:**
- Use 2 spaces (configured in `nvim/.config/nvim/lua/vim-options.lua`)
- No tabs

**Variable Naming:**
- Use `local_snake_case` for local variables
- Use `UPPER_CASE` for constants
- Use `camelCase` when working with Lua API conventions that require it

**Formatting:**
- Use consistent spacing around operators
- Break long lines at logical points
- Group related statements together

**Example:**
```lua
local options = {
  swapfile = false,
  clipboard = "unnamedplus",
  number = true,
}

for k, v in pairs(options) do
  vim.opt[k] = v
end
```

**Imports & Requires:**
- Place all `require()` statements at the top of the file
- Use `local module = require("module.path")` pattern
- Keep imports organized and sorted

**Types & Documentation:**
- Document function parameters in comments for complex functions
- Use meaningful variable names to indicate type
- Include brief descriptions of non-obvious logic

**Error Handling:**
- Check for nil/false conditions explicitly
- Provide fallback values where appropriate
- Use `vim.notify()` for user-facing messages in Neovim config

**Comments:**
- Single-line comments: `-- Comment here`
- Block comments for multi-line explanations
- Explain non-obvious behavior, especially for Neovim API calls

---

### Configuration Files

**TOML/YAML:**
- Use 2-space indentation consistently
- Keep similar settings grouped together
- Use descriptive keys that are self-explanatory

**JSON:**
- Use 2-space indentation (see `.luarc.json`)
- Keep keys alphabetically sorted when possible
- Avoid excessive nesting

---

## Naming Conventions

- **Shell scripts:** Use `descriptive_action.sh` format (e.g., `apt_search_packages.sh`)
- **Lua functions:** Use `verb_noun()` pattern (e.g., `get_buffer()`, `set_options()`)
- **Directories:** Use lowercase with underscores (e.g., `configs/`, `plugins/`)
- **Configuration keys:** Use snake_case in Lua/Vim, kebab-case in TOML/YAML as appropriate

---

## Git Workflow

- Commit messages should be clear and descriptive
- Reference issues/PRs when applicable
- Keep commits focused on single changes when possible

---

## Key File Locations

- Shell scripts: `local/.local/bin/`
- Neovim Lua config: `nvim/.config/nvim/`
- Neovim plugins: `nvim/.config/nvim/lua/plugins/`
- Vim options: `nvim/.config/nvim/lua/vim-options.lua`

---

## Important Notes for Agents

1. **This is a configuration repo** - focus on readability and maintainability
2. **Language-specific constraints:**
   - Shell: Must be POSIX-compatible or explicitly bash-only with proper shebang
   - Lua: Compatible with Neovim's Lua runtime
3. **Testing philosophy:** Manual testing is typical; validate changes in context
4. **No external dependencies** for core functionality unless documented in README.md
