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