``` yml
version: '3.6'
services:
    web:
        image: 'gitlab/gitlab-ee:latest'
        container_name: 'gitlab-server'
        restart: unless-stopped
        hostname: 'gitlab-shafish'
        environment:
            GITLAB_OMNIBUS_CONFIG: |
                external_url 'https://192.168.0.157'
                # Add any other gitlab.rb configuration here, each on its own line
        ports:
            - '80:80'
            - '443:443'
            - '22:22'
        volumes:
            - '/data/docker/gitlab/config:/etc/gitlab'
            - '/data/docker/gitlab/logs:/var/log/gitlab'
            - '/data/docker/gitlab/data:/var/opt/gitlab'
        shm_size: '256m'
```

## 默认密码

https://192.168.0.157
root
cat /data/docker/gitlab/config/initial_root_password

## 修改密码

``` shell
docker exec -it gitlab-server bash
cd /opt/gitlab/bin
gitlab-rails console -e production
u=User.where(id:1).first
u.password='你的密码'
u.password_confirmation='你的密码'
u.save!
quit
```