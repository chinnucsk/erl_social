platten sdk
============

Platten_sdk is a sdk for connecting the thrid platform.

We can login ,get user info and send messages on third platform.

Mainly,including QQ,Sina,Douban.

Introduce
-------------
The platten.hrl mainly define the default value for the corresponding platform.

Platten_util.erl is a tool for our application. 

*_oauth for oauth.

*_user for get userinfo.

* blog for send a status to the platform.

*_log for debug infomations.

Attention
------------

The parameter code needs you get from the  web of return_uri from platform server. 

Use the Code to get access_token.

Use the access_token to get user_info or send messages or other things.

How To Use
------------

The parameter of args is tuple list, if you didn't define, some paras will use the default in platten.hrl.

* make && ./start.sh 

* platten_sdk:oauth(sina,Args).
  platten_sdk:oauth(qq,Args).
  platten_sdk:oauth(douban,Args).

* platten_sdk:user(sina, Args).
  platten_sdk:user(qq, Args).
  platten_sdk:user(douban, Args).

* platten_sdk:friendship(Args).

* platten_sdk:blog(Args).

* platten_sdk:blog_pic(Args).



