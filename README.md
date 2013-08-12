erl_social
============

Erl_social is a sdk for connecting the thrid platform.

We can login ,get user info and send messages on third platform.

Mainly,including QQ,Sina,Douban.

Introduce
-------------
The erl_social.hrl mainly define the default value for the corresponding platform.

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

The Third Platten Url
-----------

* [sina develop url](http://open.weibo.com/wiki/%E5%BE%AE%E5%8D%9AAPI) <br />
* [douban develop url](http://developers.douban.com/wiki/?title=guide) <br />
* [qq develop url](http://wiki.opensns.qq.com/wiki/%E3%80%90QQ%E7%99%BB%E5%BD%95%E3%80%91API%E6%96%87%E6%A1%A3) <br />

Log 
------------

Server start a log server called erl_social_log_server, you can define the log path in include file(`paras` LOG_FILE).

erl_social_log:error/1, will print error type infos.

erl_social_log:format/1, will print debug type infos.

How To Use
------------

The parameter of args is tuple list, if you didn't define, some paras will use the default in erl_social.hrl.

The Parameter instructions delcars in erl_social.erl.


* make && ./start.sh 

* erl_social:oauth(sina,Args).
  erl_social:oauth(qq,Args).
  erl_social:oauth(douban,Args).

* erl_social:user(sina, Args).
  erl_social:user(qq, Args).
  erl_social:user(douban, Args).

* erl_social:friendship(Args).

* erl_social:blog(sina,Args).
  erl_social:blog(qq,Args).

* erl_social:blog_pic(sina,Args).
  erl_social:blog_pic(qq,Args).

* erl_social:qzone_share(Args).


