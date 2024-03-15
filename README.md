# Henrik does dotfiles
The zsh is currently used, install zsh, then [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh).

Relevant files should be symlinked to $HOME.
This could be done with GNU Stow: https://www.gnu.org/software/stow/


Having dircolors work, install `brew install coreutils`, and make a link in path dircolors ->
gdircolors




```
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

```
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```
