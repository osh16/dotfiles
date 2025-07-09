## asdf

Generic runtime version manager tool like nvm which is particularly useful for C#/.NET

- *install_software.sh* has installation instructions
- *.zshrc* has autocompletion and $PATH setup

```bash
# Enables dotnet-core
asdf plugin add dotnet-core azure-functions-core-tools

# Lists all versions available for download
asdf list all dotnet-core

# Download a few versions
asdf install dotnet-core latest
asdf install dotnet-core 8.0.412
asdf install dotnet-core 9.0.302
asdf install azure-functions-core-tools latest

# Set global default version 
asdf set -u dotnet-core 9.0.302
asdf set -u azure-functions-core-tools latest

# Set local default version
asdf set dotnet-core 8.0.412

# List installed versions
asdf list 

# List current version
asdf current 
```
