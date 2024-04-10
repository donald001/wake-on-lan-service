# 简介
这是一个局域网电脑唤醒的后端服务项目，可修改的部分为服务启动端口（wol-proxy.v设置的8009）和常用的mac(wol.html中的`mac=`后面部分改成你要唤醒的mac)
# 部署步骤
### 环境准备
1. 确保linux上安装了nginx(如果没有执行：`sudo apt install nginx`)
2. 确保安装了git,gcc和make(如果没有执行：`sudo apt install git`,`sudo apt install make`和`sudo apt install gcc`)
3. 安装vlang环境：
```sh
cd /opt
git clone https://github.com/vlang/v
cd v
make
```
4. 在`/etc/profile`文件中加入v到环境变量：增加一行：`export PATH=/opt/v/:$PATH`。刷新：`source /etc/profile`
### 编译
- 把wol-proxy.v文件放到`/opt/wol`目录下。执行`v .`
### 部署
- 把wol.service文件放到`/etc/systemd/system`目录下

- 执行下面命令让它开机自启
```sh
sudo systemctl enable wol.service
sudo systemctl start wol.service
```
- 把`wol-nginx.conf`放到`/etc/nginx/conf.d/`目录下
- 开启nginx: `nginx`或重启`nginx -s reload`
- 访问（ip要改成你的linux的ip）：http://192.168.1.19/wol.html