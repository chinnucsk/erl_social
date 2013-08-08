platten sdk
============

Platten_sdk is a sdk for connecting the thrid platform.

We can login ,get user info and send messages on third platform.

Mainly,including QQ,Sina,Douban.

Introduce
-------------
The platten.hrl mainly define the default value for the corresponding platform.

Platten_util.erl is a tool for our application. 

* _oauth for oauth.

* _user for get userinfo.

* _blog for send a status to the platform.

* _log for debug infomations.

Attention
------------

The parameter code needs you get from the  web of return_uri from platform server. 

Use the Code to get access_token.

Use the access_token to get user_info or send messages or other things.

Log 
------------

Server start a log server called platten_log_server, you can define the log path in include file(`paras` LOG_FILE).

platten_log:error/1, will print error type infos.

platten_log:format/1, will print debug type infos.

How To Use
------------

The parameter of args is tuple list, if you didn't define, some paras will use the default in platten.hrl.

The Parameter instructions delcars in platten_sdk.erl.


* make && ./start.sh 

* platten_sdk:oauth(sina,Args).
  platten_sdk:oauth(qq,Args).
  platten_sdk:oauth(douban,Args).

* platten_sdk:user(sina, Args).
  platten_sdk:user(qq, Args).
  platten_sdk:user(douban, Args).

* platten_sdk:friendship(Args).

* platten_sdk:blog(sina,Args).
  platten_sdk:blog(qq,Args).

* platten_sdk:blog_pic(sina,Args).
  platten_sdk:blog_pic(qq,Args).

* platten_sdk:qzone_share(Args).


