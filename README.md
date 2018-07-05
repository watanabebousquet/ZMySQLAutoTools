## ZMySQLAutoTools文档手册 

作者：**张盛东**

目标：**自动化构建部署MySQL数据库，一键式备份，监控，主从集群部署等。以及jdk，tomcat，nginx等基础中间件的自动化部署安装及运维。**

---
### 手册目录
- [安装 ZMySQLAutoTools](#安装ZMySQLAutoTools)
  - [环境准备](#环境准备)
  - [解压ZMySQLAutoTools](#解压ZMySQLAutoTools)
  - [python3.x安装](#python3.x安装)
  - [ansible安装](#ansible安装)
  - [配置ansible](#配置ansible)

### 环境准备
本实验为：4台虚拟机，操作系统为:Centos 6.8(6以上均可)


   **主机名**     | **ip地址**         | **备注**   |
   ---------------:|:-------------------|--------------|
   host_50           | 10.1.11.50     |主控机    |
   host_51          | 10.1.11.51     |被控客户端   |
   host_52          |10.1.11.52               |被控客户端   |
   host_53          |10.1.11.53               |被控客户端   |

### 解压ZMySQLAutoTools

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

