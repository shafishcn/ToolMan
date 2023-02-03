## gitee、github仓库管理
> 仓库在两个平台都同步操作，在github或者gitee平台创建好仓库后，在仓库git配置文件中添加对应url地址即可。

`vim 仓库/.git/config`
``` shell
[remote "origin"]
        url = git@gitee.com:shafish/ToolMan.git
        fetch = +refs/heads/*:refs/remotes/origin/*
```
``` shell
[remote "origin"]
        url = git@gitee.com:shafish/ToolMan.git
        url = git@github.com:shafishcn/ToolMan.git
        fetch = +refs/heads/*:refs/remotes/origin/*
``` 

## 基本配置
- `git config --list`：查看git配置
- `git config --global user.name "shafish"`：显示名
- `git config --global user.email shafish_cn@163.com`：邮箱
- `git config user.name`：查看配置项及配置文件路径
- `git init`：创建本地git仓库
- `git remote add origin git@github.com:shafishcn/code.git`：本地仓库关联远程