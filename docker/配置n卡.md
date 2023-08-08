## 驱动、cuda
## doker
## NVIDIA Container Toolkit 
> https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#installation-guide

``` shell
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
      && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
      && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
            sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
            sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
sudo docker run --rm --runtime=nvidia --gpus all nvidia/cuda:11.6.2-base-ubuntu20.04 nvidia-smi            
```

## 使用
``` shell
docker run xxx \
  --runtime=nvidia \
  -e NVIDIA_VISIBLE_DEVICES=all \
  xxx
```
``` yml
version: '3.3'
services:
    xx:
        container_name: xx
        environment:
            - NVIDIA_VISIBLE_DEVICES=all
        runtime: nvidia
        image: 'xxx'
```