## ZMySQLAutoTools文档

作者：**张盛东**

目标：自动化构建部署MySQL数据库，一键式单实例mysql安装，备份，监控，主从集群部署等。以及jdk，tomcat，nginx等基础中间件的自动化部署安装及运维。

此文档：完成一键式单实例mysql安装功能，可以完成批量标准化部署MySQL单实例。用于测试，开发以及生产环境。

---
### 目录
- [安装 ZMySQLAutoTools](#安装ZMySQLAutoTools)
  - [环境准备](#环境准备)
  - [解压ZMySQLAutoTools](#解压ZMySQLAutoTools)
  - [python3.x安装](#python3.x安装)
  - [ansible安装](#ansible安装)
  - [配置ansible](#配置ansible)
-  [自动化单实例MySQL部署](#自动化单实例MySQL部署)
   - [yaml文件配置修改](#yaml文件配置修改)
   - [一键单实例MySQL部署](#一键单实例MySQL部署)

### 环境准备
本实验为：4台虚拟机，操作系统为:Centos 6.8(6以上均可)

   **主机名**     | **ip地址**         | **备注**   |
   ---------------:|:-------------------|--------------|
   host_50           | 10.1.11.50     |主控机    |
   host_51          | 10.1.11.51     |被控客户端   |
   host_52          |10.1.11.52               |被控客户端   |
   host_53          |10.1.11.53               |被控客户端   |


### 解压ZMySQLAutoTools

**1):获得ZMySQLAutoTools安装包**
```bash
cd /tmp/
wget https://github.com/zhangshengdong/ZMySQLAutoTools/archive/master.zip
```
**2):解压ZMySQLAutoTools安装包**
```bash
unzip master
mv ZMySQLAutoTools-master /usr/local/ZMySQLAutoTools
```

### python3.x安装
在ZMySQLAutoTools/packages/python/目录下，有相关的python安装包，通过 installPython.sh 安装部署
```bash
# yum install -y libselinux-python
# cd /usr/local/ZMySQLAutoTools/packages/python/
# bash installPython.sh
```

输出日志为:
```bash
.....
Collecting setuptools
Collecting pip
Installing collected packages: setuptools, pip
Successfully installed pip-9.0.1 setuptools-28.8.0
......
```
说明安装成功

查看版本:
```bash
source /etc/profile
python3 --version
```
### ansible安装
在ZMySQLAutoTools/packages/ansible/目录下，有相关的ansible安装包，通过 ins_ansible.sh 安装部署
```bash
# source /etc/profile
# cd /usr/local/ZMySQLAutoTools/packages/ansible
# bash ins_ansible.sh
```

输出日志为:
```bash
Using /usr/local/python-3.6.2/lib/python3.6/site-packages
Finished processing dependencies for ansible==2.4.0.0
```
说明安装成功

### 配置ansible
1):编辑ansible的配置文件
+ **增加ansible的配置文件**
```bash
mkdir -p /etc/ansible
touch /etc/ansible/hosts
```
+ **配置/etc/ansible/hosts文件，内容如下：**
```bash
host_50 ansible_user=root ansible_host=10.1.11.50
host_51 ansible_user=root ansible_host=10.1.11.51
host_52 ansible_user=root ansible_host=10.1.11.52
host_53 ansible_user=root ansible_host=10.1.11.53
```
2):配置主控机与被控机之间的ssh信任
```bash
ssh-keygen
ssh-copy-id root@10.1.11.50
ssh-copy-id root@10.1.11.51
ssh-copy-id root@10.1.11.52
ssh-copy-id root@10.1.11.53
```
3):测试ansible是否成功
```bash
举例命令:
ansible all -m ping                     //检测所有主机是否pingOK
ansible all -a "/bin/echo hello"        //对所有主机执行hello脚本
ansible all -a "df -h"                  //对所有主机检测硬盘
ansible host_53 -m command -a 'hostname'//对主机host_53,查看hostname的名字
ansible all -m shell -a 'ps -ef |grep mysql'   //对所有主机检测mysql进程
```
ping命令的检测效果日志日志如下:
```bash
[root@MHA-Manager ansible]# ansible all -m ping
host_50 | SUCCESS => {
    "changed": false,
    "failed": false,
    "ping": "pong"
}
host_51 | SUCCESS => {
    "changed": false,
    "failed": false,
    "ping": "pong"
}
host_53 | SUCCESS => {
    "changed": false,
    "failed": false,
    "ping": "pong"
}
host_52 | SUCCESS => {
    "changed": false,
    "failed": false,
    "ping": "pong"
}
```

### 自动化单实例MySQL部署
### yaml文件配置修改
由于MySQL的tar.gz过大，所以手动get到指定目录。并且修改几个yaml，完成一键式部署mysql。
**1):下载MySQL 5.7二进制部署包**
```bash
cd /tmp/
wget https://cdn.mysql.com//Downloads/MySQL-5.7/mysql-5.7.22-linux-glibc2.12-x86_64.tar.gz
```
**2): MySQL 5.7二进制部署包放置到/usr/local/ZMySQLAutoTools/packages/mysql目录下**
```bash
mv /tmp/mysql-5.7.22-linux-glibc2.12-x86_64.tar.gz /usr/local/ZMySQLAutoTools/packages/mysql/
```
**3): 修改install_single_mysql.yaml配置文件**
```bash
[root@MHA-Manager mysql]# cd /usr/local/ZMySQLAutoTools/deploy/mysql
[root@MHA-Manager mysql]# vi install_single_mysql.yaml
---
 - hosts: host_51   //修改为你要远程部署的主机名称
```
### 一键单实例MySQL部署
**1):部署mysql**
```bash
cd /usr/local/ZMySQLAutoTools/deploy/mysql
ansible-playbook install_single_mysql.yaml
```
**2):进入mysql**
```bash
[root@MHA-Manager mysql]# mysql -uroot -p'zsd@7101'
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 3
Server version: 5.7.22-log MySQL Community Server (GPL)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

(root@localhost) [(none)]> 
```
