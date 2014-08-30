#archlinux config

主要保存arch系统的一些配置文件 

其中包括系统级别，应用程序，其他


##系统配置 

|       配置文件   |  对应中文含义| 对应系统路径      |
|:----------------:|:-------------|:-----------------:|
|system/pacman.conf|   包管理配置 | /etc/pacman.conf  |
|system/xinitrc    | 启动图形界面 | ～/.xinitrc       |
|system/bashrc     | 自定义命令   | ～/.bashrc        |
|system/rc.conf    | 系统启动     |      /etc/rc.conf |
|system/fstab      | 系统启动挂载 | /ect/fstab        |
|system/fonts.cong |  系统默认字体 ： ～/.config/fontconfig/fonts.conf | 

> 注：建议从/ect/X11/xinit/xinitrc 拷贝，不要链接。 
更新后系统后，链接的东西可能被冲掉，以致不能启动。 
如果系统不能启动，先看下 xinitrc 这个东东吧


##应用

|   配置文件   | 应用程序    |
|:------------:|:-----------:|
| myawesome/   | awesome     |
| .vim         | vim         |


- 这里还有一些conkyrc 



