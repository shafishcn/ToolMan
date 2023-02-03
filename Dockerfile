FROM debian:latest
RUN apt install python3 python3-pip python3-cryptography python3-netifaces -y \
    && apt install less libxext6 libxrender1 libxtst6 libfreetype6 libxi6 curl git -y

RUN python3 -m pip install -U pip
RUN pip3 install projector-installer
RUN projector ide autoinstall --config-name Idea --ide-name "IntelliJ IDEA Ultimate 2020.3.4"

CMD projector run

apt install python3 python3-pip python3-cryptography python3-netifaces less libxext6 libxrender1 libxtst6 libfreetype6 libxi6 curl git -y
apt install curl git -y
python3 -m pip install -U pip

/data/docker/idea/jetbra/ja-netfilter.jar=jetbrains