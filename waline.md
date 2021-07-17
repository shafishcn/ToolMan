[waline](https://waline.js.org/)是一款从 [Valine](https://valine.js.org/) 衍生的带后端评论系统。其比valine添加了登录、多部署、多数据存储、评论内容校验、防灌水、保护敏感数据等功能。其实纯粹是为mkdocs选一个评论系统，Valine简洁好用但不想用个人帐号注册leancloud，so，就是你了--waline。

## 一、安装mysql数据库
创建个数据库，记录好用户名、密码、数据库名这三个信息，导入 https://github.com/walinejs/waline/blob/main/assets/waline.sql 创建对应表

## 二、设置系统环境变量
- 1.添加变量
vim /etc/profile.d/waline.sh

```shell
MYSQL_DB=数据库名
MYSQL_USER=用户名
MYSQL_PASSWORD=密码
SECURE_DOMAINS=shafish.cn
```

- 2.变量生效
resource /etc/profile

- 3.检查变量
```shell
echo $MYSQL_DB
echo $MYSQL_USER
echo MYSQL_PASSWORD
```

## 三、安装Waline
- 安装后台运行命令pm2
npm install -g pm2

- 安装waline
npm install @waline/vercel

- pm2运行waline
pm2 start node_modules/@waline/vercel/vanilla.js

- 查看状态
pm2 list

- 删除应用
pm2 delete all
pm2 delete appName

> 如果修改了应用配置行为，需要先删除应用，重新启动后方才会生效

## 四、更多waline服务端配置
- https://waline.js.org/reference/server.html
- https://waline.js.org/guide/server/notification.html
- https://waline.js.org/guide/server/intro.html#%E7%A4%BE%E4%BA%A4%E7%99%BB%E5%BD%95

## 五、域名访问
- 1.域名dns解析添加A记录：`xxx.shafish.cn`
下面2～4点如果安装了宝塔面板可以直接在面板图形操作。
- 2.free.org配置ssl
```shell
# 填入生成的pem信息
vim /etc/letsencrypt/live/xxx.shafish.cn/fullchain.pem
vim /etc/letsencrypt/live/xxx.shafish.cn/privkey.pem
```
- 3.配置站点
```shell
mkdir -p /www/wwwroot/xxx.shafish.cn
vim /www/server/panel/vhost/nginx/xxx.shafish.cn.conf
```

```conf
server
{
    listen 80;
	listen 443 ssl http2;
    server_name xxx.shafish.cn;
    index index.php index.html index.htm default.php default.htm default.html;
    root /www/wwwroot/xxx.shafish.cn;
    
    #SSL-START SSL相关配置，请勿删除或修改下一行带注释的404规则
    #error_page 404/404.html;
    #HTTP_TO_HTTPS_START
    if ($server_port !~ 443){
        rewrite ^(/.*)$ https://$host$1 permanent;
    }
    #HTTP_TO_HTTPS_END   自行配置ssl证书 这里使用了free.org配置
    ssl_certificate    /etc/letsencrypt/live/xxx.shafish.cn/fullchain.pem;
    ssl_certificate_key    /etc/letsencrypt/live/xxx.shafish.cn/privkey.pem;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:HIGH:!aNULL:!MD5:!RC4:!DHE;
    ssl_prefer_server_ciphers on;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;
    error_page 497  https://$host$request_uri;

    #SSL-END
    
    #ERROR-PAGE-START  错误页配置，可以注释、删除或修改
    error_page 404 /404.html;
    error_page 502 /502.html;
    #ERROR-PAGE-END
    
    #PHP-INFO-START  PHP引用配置，可以注释或修改
    #PROXY-START
    location ~ /purge(/.*) { 
        proxy_cache_purge cache_one $host$request_uri$is_args$args;
        #access_log  /www/wwwlogs/xxx.shafish.cn_purge_cache.log;
    }
    location / 
    {
        proxy_pass http://127.0.0.1:8360; # 反代本地8360端口
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header REMOTE-HOST $remote_addr;
                
        #持久化连接相关配置
        #proxy_connect_timeout 30s;
        #proxy_read_timeout 86400s;
        #proxy_send_timeout 30s;
        #proxy_http_version 1.1;
        #proxy_set_header Upgrade $http_upgrade;
        #proxy_set_header Connection "upgrade";
        
        add_header X-Cache $upstream_cache_status;
        
        expires 12h;
    }
    
    location ~ .*\.(php|jsp|cgi|asp|aspx|flv|swf|xml)?$
    {
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header REMOTE-HOST $remote_addr;
        proxy_pass http://127.0.0.1:8360;
        
    }
    
    location ~ .*\.(html|htm|png|gif|jpeg|jpg|bmp|js|css)?$
    {
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header REMOTE-HOST $remote_addr;
        proxy_pass http://127.0.0.1:8360;
        
        #缓存相关配置
        #proxy_cache cache_one;
        #proxy_cache_key $host$request_uri$is_args$args;
        #proxy_cache_valid 200 304 301 302 1h;
        
        expires 24h;
    }
    #PROXY-END

	include enable-php-70.conf;
    #PHP-INFO-END
    
    #REWRITE-START URL重写规则引用,修改后将导致面板设置的伪静态规则失效
    include /www/server/panel/vhost/rewrite/xxx.shafish.cn.conf;
    #REWRITE-END
    
    #禁止访问的文件或目录
    location ~ ^/(\.user.ini|\.htaccess|\.git|\.svn|\.project|LICENSE|README.md)
    {
        return 404;
    }
    
    #一键申请SSL证书验证目录相关设置
    location ~ \.well-known{
        allow all;
    }
    
    access_log  /www/wwwlogs/xxx.shafish.cn.log;
    error_log  /www/wwwlogs/xxx.shafish.cn.error.log;
}
```
- 4.检查nginx配置，reload配置
```shell
nginx -t
nginx -s reload
```

## 六、客户端接入
> mkdocs中使用

### mkdocs.yml
```yaml
theme:
  custom_dir: overrides # 使用自定义主题
```

### overrides/main.html
overrides目录与mkdocs.yml同级

```html
{% extends "base.html" %}

{% block disqus %}
  <!-- Add custom comment system integration here -->
  <script src="//cdn.jsdelivr.net/npm/@waline/client"></script>
  <div id="waline"></div>
  <script>
    Waline({
      el: '#waline',
      dark: 'html[data-md-color-scheme="slate"]', // 无效，再说
      avatar: 'robohash', // 头像
      //login: 'force',  //强制登录
      requiredMeta: ['nick', 'mail'], // 必填项
      serverURL: 'https://xxx.shafish.cn/', // waline系统后端地址
    });
  </script>
{% endblock %}
```
ok
## 七、更多waline前端配置

https://waline.js.org/guide/client/intro.html