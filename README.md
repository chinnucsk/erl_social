erl_social
============

__Authors:__ [`lucas`](mailto:564985699@qq.com).


Erl_social is a sdk for connecting the thrid platform.

We can login ,get user info and send messages on third platform.

Mainly,including QQ,Sina,Douban.

Introduce
-------------

Application erl_social is a tool to develop The third platform using erlang. 

File introduce:

*  `erl_social.erl` providing call interface.

* `erl_social_app.erl` application file.

* `erl_soical_sup.erl` start supervision.

* `erl_social_log_adapter.erl` choose log module.

* `erl_social_log_lager.erl` call lager log server interface.

* `erl_social_log_normal.erl` call local simple log server interface.

* `erl_social_log_server.erl` gen_server for logging local.

* `erl_social_util.erl normal tool.

* `erl_sina.erl` providing sina call interface.

* `erl_qq.erl` providing qq call interface.

* `erl_douban.erl` providing douban call interface.

* `erl_qzone.erl` providing qqzone and qq microblog call interface.

* `erl_validate.erl` providing check value call interface.

Configure
--------------

The configure file are in priv, named app.config. You can modify it according your need.

Including erl_social,lager.

example:
```javascript
[{erl_social,[
    {providers,[
        {sina,[
            {app_key,"2128144137"},
            {grant_type, "authorization_code"},
            {app_secret,"4bd23d77f8015cbf956f113825a164b5"},
            {url,"http://lucas.yunio.com:8001"},
            {format, "json"}
        ]},
        {qq,[
            {app_key,"100498331"},
            {grant_type, "authorization_code"},
            {app_secret,"b0c64798dd28da85f7fb7ca38ae6f6cc"},
            {url,"http://3.yunio.com"},
            {format, "json"}
        ]},
        {douban,[
            {app_key,"06b6c6228430e83b142452678c92b8b1"},
            {grant_type, "authorization_code"},
            {app_secret,"844ea0d505816b63"},
            {url,"http://lucas.yunio.com:8001"},
            {format, "json"}
        ]}
 ]},
    {logtype, lager},
    {logfile,"/home/lucas/erl_social.txt"}
]}]	
```
* `erl_social`:
        `providers`:define The Third Platform.
            `sina|qq|douban`:The Third Platform name.
                `app_key`:application key.
                `grant_type`:the type of grant.
                `app_secret`:the secret of application.
                `url`:the redirect url.
                `format`:return typ.
        `logtype`: closed|normal|lage,define the log server state and open type.        `logfile`: when logtype is normal,the location of logfile.

* `lager`:
	The configure of `lager` please reference [`this lager`](https://github.com/basho/lager) <br /> 

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

Now providing two kinds of log server,one is a simple server which recording the simple infomations to a file, another is lager which you can get detail informations.

At the same time,you can see blows to close the log server.

In the priv/app.config,erl_social:logtype has three value:
	* closed; // close the log server
	* normal; // open a simple log server
	* lager; //open lager server

When logging,erl_social provides a log adaptor to choose which method to log it.

1.Normal:Server start a log server called erl_social_log_server, you can define the log path in priv/app.config ,named erl_social:logfile.

erl_social_log_normal:execute/3 

```javascript
	example:
		2013-8-13  11-13-33   [error] module (es_sina) info lacking uid or scre
en_name

		2013-8-13  11-53-24   [debug] module (es_qzone) info {"ret":0,"msg":"ok"
,"share_id":1376366004}
```

2.Larger:Start application lager,you can define the lager configure in priv/app.config, application lager.

erl_social_log_lager:execute/3

```jvascript
	example:
		2013-08-15 14:44:42.760 [debug] <0.210.0>@lager_handler_watcher:94 Lager
installed handler {lager_file_backend,"log/error_lucas.log"} into lager_event

		2013-08-15 14:45:03.270 [error] <0.128.0> POST /index/login [lucas_web]
500 407ms
```

How To Use
------------

The parameter of args is tuple list, if you didn't define, some paras will use the default in erl_social.hrl.

The Parameter instructions declare in erl_social.erl.


* make && ./start.sh

* erl_social:start().//start application erl_social;

* erl_social:oauth(sina,Args).//get access_token;

  erl_social:oauth(qq,Args).

  erl_social:oauth(douban,Args).

* erl_social:user(sina, Args).//get user infomations;

  erl_social:user(qq, Args).

  erl_social:user(douban, Args).

* erl_social:friendship(Args).//create user friendship;

* erl_social:blog(sina,Args).//post a microblog;

  erl_social:blog(qq,Args).

* erl_social:blog_pic(sina,Args).//post a picture microblog;

  erl_social:blog_pic(qq,Args).

* erl_social:blog_pic_url(sina,Args).//post a url microblog;

* erl_social:qzone_share(Args).//post status to qzone and q microblog;

* erl_social:validate(sina,Uid,Token).// check; 

  erl_social:validate(qq,Uid,Token).

  erl_social:validate(douban,Uid,Token).
