#!/bin/bash 
##g
fail()                                                        {
        if [ $? -eq 1 ];then                                                  echo "安装失败!"                             
		exit 1
		fi
	}		

pipinstall(){
		pip3 install --target vendor -r requirements.txt
		fail
		echo " 安装完成!请进入calibre-web的目录（位于根目录下），键入命令python3 cps.py以启动!
	               如需 后台运行请键入命令【nohup python3 cps.py 】
	              如需开机启动请自行将以上命令加入开机启动脚本中。
             	现在，请启动cps.py,然后在web浏览器输入【ip地址:8083】即可进入数据库设置界面!"	
	}
cont(){
	pwd_="`pwd`"
	if [ $? -eq 1 ];then
		echo "Calibre-web下载失败!请手动访问https://github.com/janeczku/calibre-web下载!下载完成之后，请将未解压的文件与此脚本放在同一文件夹内，然后再执行此脚本。"
		exit 1 
	elif [ -e $pwd/calibre-web-master/  ];then
		cd $pwd/calibre-web-master
	fi
	pipinstall
} 

apt-get update
echo " 注意事项：如果您的服务器在中国大陆，在开始安装Calibre-web之前，请确认您已修改hosts并且可加速解析访问GitHub。如果您未修改hosts，请在安装程序执行之前将其修改，或者使用代理软件代理Wget。 Calibre将被安装在根目录下。【按Ctrl-C退出；按任意键继续。】"
read continue_
#### download and install calibre-web ####
download()
{
	iam="`whoami`"
       	cd /$pwd/
	      if [ -e /$pwd/.pip/ ];then     
		      rm -rf /$pwd/.pip/pip.conf
		      touch /$pwd/.pip/pip.conf  
		      echo [global] >> /$pwd/.pip/pip.conf 
		      echo trusted-host = pypi.douban.com >> /$pwd/.pip/pip.conf  
		      echo index-url = http://pypi.douban.com/simple >> /$pwd/.pip/pip.conf   
	      else    
	      mkdir /$pwd/.pip/
		      > /$pwd/.pip/pip.conf 
,		      echo [global] >> /$pwd/.pip/pip.conf 
		      echo trusted-host = pypi.douban.com >> /$pwd/.pip/pip.conf  
		      echo index-url = http://pypi.douban.com/simple >> /$pwd/.pip/pip.conf   
	      fi
		      more /$pwd/.pip/pip.conf
	fail
	if [ -e /usr/bin/wget -a /usr/bin/unzip ];then
		wget https://github.com/janeczku/calibre-web/archive/master.zip -O cali.zip
	        unzip /$pwd/cali.zip
		cont
	else
		apt install wget -y
		apt install unzip -y
		wget https://github.com/janeczku/calibre-web/archive/master.zip -O cali.zip
	unzip /$pwd/cali.zip	
	fi
	cont
		}
#### install pip ####
pip()
{
	if [ -e /usr/bin/pip -a /usr/bin/pip3 ];then
		download
	else
		apt-get install python-pip -y
		apt-get install python3-pip -y
	download
fi
}
	
#### install git ####
gits()
{
if [ -e  /usr/lib/git-core  ];then
	pip
else
	apt-get install git -y
	pip
fi
}

#### install python ####
if [  -e /usr/lib/python3/ -a /usr/lib/python2.7/ -a /usr/lib/python3.5/ ];then
	gits
else
	apt-get install python3 -y
       	apt-get install python2.7 -y
	apt-get install python3.5 -y
	gits
fi
##by bssjgb1157 2020.2

