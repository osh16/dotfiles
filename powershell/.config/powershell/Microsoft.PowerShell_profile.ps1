Set-PSReadLineOption -EditMode Vi
Set-PSReadlineKeyHandler -Key Tab -Function Complete

Set-PSReadlineKeyHandler -Chord Ctrl+n -Function NextSuggestion
Set-PSReadlineKeyHandler -Chord Ctrl+p -Function PreviousSuggestion

. $HOME/.config/powershell/extra_variables.ps1
