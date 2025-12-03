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
