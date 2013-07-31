sina
====
This is a sina sdk for web application in erlang.

Another, adding douban interface to this application.

You can add redefine the value in sina.hrl, we will use them as default value in codes.

How to use:

*1. ./start.sh 

*2. sina:ouath([]). 获取授权 

*3. sina:user([{screen_name, "lucas-lzz"}]). 查看用户信息 

*4. sina:blog([]). 发微博 

*5. sina:blog_pic([]). 发微博带图片 

*6. sina:friendship([]). 关注 

*7. douban_oauth:oauth([]).

*8 douban_user:info([]).
