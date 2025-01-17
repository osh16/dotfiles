Set-PSReadLineOption -EditMode Vi
Set-PSReadlineKeyHandler -Key Tab -Function Complete

. $HOME/.config/powershell/extra_variables.ps1
