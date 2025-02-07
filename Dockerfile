FROM codercom/code-server:latest

USER root

# Install Python 3 and vim
RUN apt-get update && \
    apt-get install -y vim fzf ripgrep sed gh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install dependencies for building Python
RUN apt-get update && \
    apt-get install -y wget build-essential libssl-dev zlib1g-dev libncurses5-dev \
    libncursesw5-dev libreadline-dev libsqlite3-dev libgdbm-dev libdb5.3-dev \
    libbz2-dev libexpat1-dev liblzma-dev tk-dev libffi-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Download and build Python 3.12
RUN wget https://www.python.org/ftp/python/3.12.9/Python-3.12.9.tgz && \
    tar xzf Python-3.12.9.tgz && \
    cd Python-3.12.9 && \
    ./configure --enable-optimizations && \
    make -j $(nproc) && \
    make altinstall && \
    cd .. && \
    rm -rf Python-3.12.9 Python-3.12.9.tgz

USER 1000

# Copy settings.json
COPY settings.json /config/data/User/settings.json
COPY keybindings.json /config/data/User/keybindings.json