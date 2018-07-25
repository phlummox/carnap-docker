
FROM ubuntu:xenial

RUN apt-get clean && \
  apt-get update && \
  apt-get install -y  \
    aptitude    \
    bzip2       \
    ca-certificates \
    curl        \
    git         \
    less        \
    make        \
    mercurial   \
    python-software-properties \
    screen      \
    software-properties-common \
    sudo        \
    time        \
    vim         \
    wget        \
    xterm

RUN : "build tools" && \
  apt-get update && \
  apt-get install -y \
    binutils          \
    bsdmainutils      \
    build-essential   \
    coreutils         \
    findutils         \
    gawk              \
    libbz2-dev        \
    libgmp-dev        \
    libncurses5-dev   \
    libncursesw5-dev  \
    libreadline6-dev  \
    libreadline-dev   \
    libyaml-dev       \
    locales           \
    netcat            \
    net-tools         \
    nodejs-legacy     \
    patchutils        \
    tar               \
    zlib1g-dev


# Set the locale - was (and may still be ) necessary for ghcjs-boot to work
# Got this originally here: # http://askubuntu.com/questions/581458/how-to-configure-locales-to-unicode-in-a-docker-ubuntu-14-04-container
#
# 2015-10-25 It seems like ghcjs-boot works without this now but when I 
# removed it, vim starting emitting error messages when using plugins 
# pathogen and vim2hs together.  
#
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  

RUN : "adding .local/bin" && \
  mkdir -p ~/.local/bin 

RUN : "install stack" && \
  curl -L https://www.stackage.org/stack/linux-x86_64 | tar xz --wildcards --strip-components=1 -C ~/.local/bin '*/stack' 

ENV PATH="/root/.local/bin:${PATH}"

RUN  \
  stack setup

RUN \
  stack --resolver=lts-6.2 setup && \
  stack --resolver=lts-6.2 install cabal-install alex happy hscolour hsc2hs

ENV CARNAP_HM=/opt/carnap

RUN \
  mkdir -p ${CARNAP_HM} && \
  cd ${CARNAP_HM} && \
  git clone https://github.com/phlummox/Carnap.git .

WORKDIR ${CARNAP_HM}

RUN \
  git checkout 13bc8c1030a6e0ab546ef36bd54b24a99472c3fc

COPY patches/* ./

RUN \
  for patch in server-sqlite-fixes Carnap-fixes semigroupoids; do \
    git apply $patch; \
  done



