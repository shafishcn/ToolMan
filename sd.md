## python3.10.6
ubuntu22.04自带
`sudo apt install python3-pip`

## n卡驱动
``` shell
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt-get update
sudo ubuntu-drivers devices
sudo apt install nvidia-driver-530 # xxx-open那个用不了
```
## cuda
- 查看安装版本
`nvidia-smi`

- 安装地址
https://developer.nvidia.com/cuda-12-1-0-download-archive?target_os=Linux&target_arch=x86_64&Distribution=Ubuntu&target_version=22.04&target_type=deb_network

``` shell
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.0-1_all.deb
sudo dpkg -i cuda-keyring_1.0-1_all.deb
sudo apt-get update
sudo apt-get -y install cuda
```

## sd
``` shell
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git
cd stable-diffusion-webui
python3 launch.py # 报错退出了两次，重新执行该命令即可
```

## 插件
- Stable-Diffusion-Webui-Civitai-Helper	https://github.com/butaixianran/Stable-Diffusion-Webui-Civitai-Helper
- a1111-sd-webui-lycoris	https://github.com/KohakuBlueleaf/a1111-sd-webui-lycoris
- a1111-sd-webui-tagcomplete	https://github.com/DominikDoom/a1111-sd-webui-tagcomplete.git
- sd-dynamic-prompts	https://github.com/adieyal/sd-dynamic-prompts.git
- sd-webui-additional-networks	https://github.com/kohya-ss/sd-webui-additional-networks.
- sd-webui-cutoff	https://github.com/hnmr293/sd-webui-cutoff.git
- sd-webui-infinite-image-browsing	https://github.com/zanllp/sd-webui-infinite-image-browsing.git
- sd-webui-llul	https://github.com/hnmr293/sd-webui-llul
- stable-diffusion-webui-images-browser	https://github.com/AlUlkesh/stable-diffusion-webui-images-browser.git
- stable-diffusion-webui-localization-zh_Hans	https://github.com/hanamizuki-ai/stable-diffusion-webui-localization-zh_Hans.git
- stable-diffusion-webui-wd14-tagger	https://github.com/toriato/stable-diffusion-webui-wd14-tagger.git
- ultimate-upscale-for-automatic1111	https://github.com/Coyote-A/ultimate-upscale-for-automatic1111.git

## python版本管理顺便测试安装下so-vits-svc
> https://realpython.com/intro-to-pyenv/

``` shell
apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev openssl-dev
curl https://pyenv.run | bash
```

``` shell
# Load pyenv automatically by appending
# the following to 
~/.bash_profile if it exists, otherwise ~/.profile (for login shells)
and ~/.bashrc (for interactive shells) :

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Restart your shell for the changes to take effect.

# Load pyenv-virtualenv automatically by adding
# the following to ~/.bashrc:

eval "$(pyenv virtualenv-init -)"
```
``` shell
exec "$SHELL"
```
### 查看可安装版本
pyenv install --list | grep " 3\.[6789]"
### 安装特定版本
pyenv install -v 3.7.2
### 卸载特定版本
pyenv uninstall 3.7.2
### 切换版本
pyenv global 3.7.2
### 查看安装版本
pyenv versions
### 创建指定版本的环境
``` python
pyenv install -v 3.8.9
pyenv virtualenv 3.8.9 svc
git clone https://github.com/svc-develop-team/so-vits-svc
cd so-vits-svc
pyenv local svc
python -V
# 升级下pip
/home/用户名/.pyenv/versions/3.8.9/envs/svc/bin/python3.8 -m pip install --upgrade pip
# 安装so-vits-svc依赖
pip install -r requirements.txt
#启动
python webUI.py
```

## 升级xformers
python3 launch.py --xformers --reinstall-xformers

python3 launch.py --xformers

## 升级sd webui
git fetch --all
git pull

## 代理配置（未验）
vim sdhome/modules/launch_utils.py

``` python
## 添加--proxy=http://192.168.0.109:8118
...
def run_pip(command, desc=None, live=default_command_live):
    ...
    return run(f'"{python}" -m pip --proxy=http://192.168.0.109:8118 {command} --prefer-binary{index_url_line}', desc=f"Installing {desc}", errdesc=f"Couldn't install {desc}", live=live)
...
def prepare_environment():
    ...
    torch_command = os.environ.get('TORCH_COMMAND', f"pip --proxy=http://192.168.0.109:8118 install torch==2.0.1 torchvision==0.15.2 --extra-index-url {torch_index_url}")
    ...
...    
```