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