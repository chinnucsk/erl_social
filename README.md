erl_social
============

Erl_social is a sdk for connecting the thrid platform.

We can login ,get user info and send messages on third platform.

Mainly,including QQ,Sina,Douban.

Introduce
-------------

erl_social.erl is a tool for our application. 

* oauth/2: for getting access_token.

* user/2: for getting user infomations.

* blog/2: for sending a status to the platform.

* blog_pic/2: for sending a status and pictures to the platform.

* blog_pic_url/2: for sending a url and status to the sina blog.

* friendship/1: for creatting freiendship on sina blog.

* qzone_share/1: for sending a url and status to qzone and qq blog.

* validate/3: for validating the Token and Uid whether is right .

Configure
--------------

The configure file are in priv, named app.config. You can modify it according your need.

Attention
------------

The parameter code needs you get from the  web of return_uri from platform server. 

Use the Code to get access_token.

Use the access_token to get user_info or send messages or other things.

The Third Platform Url
-----------

* [sina develop url](http://open.weibo.com/wiki/%E5%BE%AE%E5%8D%9AAPI) <br />
* [douban develop url](http://developers.douban.com/wiki/?title=guide) <br />
* [qq develop url](http://wiki.opensns.qq.com/wiki/%E3%80%90QQ%E7%99%BB%E5%BD%95%E3%80%91API%E6%96%87%E6%A1%A3) <br />

Log 
------------

Server start a log server called erl_social_log_server, you can define the log path in priv/app.config ,named logfile.

erl_social_log:error/2, will print error type infos.

```javascript
	example:
		2013-8-13  11-13-33   [error] module (es_sina) info lacking uid or screen_name

```

erl_social_log:format/2, will print debug type infos.

```javascript
	example:
		2013-8-13  11-53-24   [debug] module (es_qzone) info {"ret":0,"msg":"ok","share_id":1376366004}
```
How To Use
------------

The parameter of args is tuple list, if you didn't define, some paras will use the default in erl_social.hrl.

The Parameter instructions declare in erl_social.erl.


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

* erl_social:validate(sina,Uid,Token).

  erl_social:validate(qq,Uid,Token).

  erl_social:validate(douban,Uid,Token).
