source ~/.antigen/antigen.zsh

antigen use oh-my-zsh

antigen bundle archlinux
antigen bundle colored-man-pages
antigen bundle command-not-found
antigen bundle docker
antigen bundle extract
antigen bundle git
antigen bundle git-extras
antigen bundle github
antigen bundle python
antigen bundle pip
antigen bundle tmux
antigen bundle tmuxinator
antigen bundle vagrant
antigen bundle virtualenvwrapper
antigen bundle z
antigen bundle zsh-users/zsh-syntax-highlighting

antigen theme https://github.com/denysdovhan/spaceship-prompt spaceship

antigen apply

source ~/.zsh_aliases
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
