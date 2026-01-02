# Dotfiles

## Installation

Clone the repository
```sh
mkdir -p ~/Documents/src/github.com/cutehax0r
cd ~/Documents/src/github.com/cutehax0r
git clone https://github.com/cutehax0r/dotfiles
```

change into the directory
```sh
cd ~/Documents/src/github.com/cutehax0r/dotfiles
```

Symbolic link folders into configuration locations:
```sh
for dir in $(find ./config/* -type d -print  -prune)
do
  ln -s $(realpath $dir) "$HOME/.config/$(basename $dir)"
done
```

Ensure keychain contains the 'secrets' for environment variables in `config/zsh/.zshrc`:
  * `ENV_BW_SESSION` Bitwarden session token
  * `ENV_GEMINI_API_KEY` Google gemini API key
  * `ENV_ANTHROPIC_API_KEY` Anthropic claude API key
  * `ENV_GITHUB_COPILOT_TOKEN` Github copilot API tokenn
  * `ENV_GITHUB_GH_TOKEN` Github token

Using keychain access or through the comand line with:
```sh
security add-generic-password -l "ENV: some label" -a "username" -s "server" -w "your-key-here"
```
