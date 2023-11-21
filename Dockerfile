FROM ubuntu:latest

RUN sed -i 's/http:\/\/archive.ubuntu.com\/ubuntu\//http:\/\/mirrors.aliyun.com\/ubuntu\//g' /etc/apt/sources.list

RUN apt-get update && \
    apt-get install -y zsh vim git curl

# install nvm node pnpm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash && \
    export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
    nvm install node && \
    npm install -g pnpm @antfu/ni

# install oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# set oh-my-zsh theme
RUN mkdir -p ~/.oh-my-zsh/custom/themes && \
    curl -o ~/.oh-my-zsh/custom/themes/in.zsh-theme https://raw.githubusercontent.com/inscorpio/oh-my-zsh-theme/main/in.zsh-theme
RUN sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="in"/g' ~/.zshrc

# install zsh plugins
RUN git clone https://github.com/jeffreytse/zsh-vi-mode.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-vi-mode && \
    git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
RUN apt-get install -y autojump
RUN sed -i 's/plugins=(git)/plugins=(git zsh-vi-mode zsh-autosuggestions zsh-syntax-highlighting autojump)/g' ~/.zshrc

VOLUME ["/workspace"]

SHELL ["/bin/zsh", "-c"]
