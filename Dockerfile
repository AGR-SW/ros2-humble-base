FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive 
ENV TZ=Asia/Seoul

LABEL "purpose"="practice"
LABEL email="jaichang@angel-robotics.com"
LABEL name="jaichang"
LABEL version="1.0"
LABEL description="Ros2-Humble-Base"

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y net-tools \ 
    sudo \ 
    git \ 
    curl \
    gnupg2 \
    lsb-release \
    iputils-ping \
    locales \ 
    apt-utils

RUN locale-gen en_US en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
RUN export LANG=en_US.UTF-8

RUN sudo apt install -y software-properties-common && sudo add-apt-repository universe
# RUN apt-cache policy | grep universe 500 http://us.archive.ubuntu.com/ubuntu jammy/universe arm64 Packages release v=22.04,o=Ubuntu,a=jammy,n=jammy,l=Ubuntu,c=universe,b=arm64

RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key  -o /usr/share/keyrings/ros-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

RUN apt-get update && apt-get install -y \
  build-essential \
  cmake \
  git \
  python3-colcon-common-extensions \
  python3-flake8 \
  python3-flake8-blind-except \
  python3-flake8-builtins \
  python3-flake8-class-newline \
  python3-flake8-comprehensions \
  python3-flake8-deprecated \
  python3-flake8-docstrings \
  python3-flake8-import-order \
  python3-flake8-quotes \
  python3-pip \
  python3-pytest \
  python3-pytest-cov \
  python3-pytest-repeat \
  python3-pytest-rerunfailures \
  python3-rosdep \
  python3-setuptools \
  python3-vcstool \
  wget \ 
  libpython3-dev && \
  apt-get clean -y && \
  apt-get autoremove -y && \
  rm -rfv /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get update && apt-get install --no-install-recommends -y \
  libasio-dev \
  libtinyxml2-dev \ 
  libcunit1-dev \ 
  ros-humble-example-interfaces \
  ros-humble-rqt-py-common \
  cmake && rm -rf /var/lib/apt/lists/*
 
RUN pip3 install --upgrade pip
RUN python3 -m pip install --upgrade setuptools protobuf wheel

RUN python3 -m pip install -U \
  argcomplete \
  flake8-blind-except \
  flake8-builtins \
  flake8-class-newline \
  flake8-comprehensions \
  flake8-deprecated \
  flake8-docstrings \
  flake8-import-order \
  flake8-quotes \
  pytest-repeat \
  pytest-rerunfailures \
  pytest

# ROS2 기본 설치 - 이미지 용량 고려 
RUN apt-get update && apt-get install -y ros-humble-ros-base && rm -rf /var/lib/apt/lists/*

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV ROS_DISTRO humble

# ROS2 의존성 초기화 및 업데이트 
RUN rosdep init && rosdep update

# 이미지 파일 경량화를 위한 작업 
RUN apt-get clean -y && \
    apt-get autoremove -y && \
    rm -rfv /var/lib/apt/lists/* /tmp/* /var/tmp/*

# 환경 변수 적용 
RUN echo "source /opt/ros/humble/setup.bash" > ~/.bashrc \
    echo "source /ws/install/setup.bash" >  ~/.bashrc

CMD ["/bin/bash"]
