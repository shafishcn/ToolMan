``` bash
mkdir slashbase && cd slashbase
curl -x socks5://127.0.0.1:1080 --location --output install.sh https://raw.githubusercontent.com/slashbaseide/slashbase/main/deploy/install.sh
chmod +x install.sh
./install.sh
```