-module(erl_social).

-export([start/0]).

-export([
		oauth/2,
		user/2,
		friendship/1,
		blog/2,
		blog_pic/2,
		blog_pic_url/2,
		qzone_share/1
		]).

start() ->
	application:start(?MODULE).

%% oauth(sina,Args::[{client_id,Value::list()},{client_secret,Value::list()},{grant_type,Value::list()},{code,Value::list()},{redirect_uri,Value::list()}]) -> {Uid::list(),AccessToken::list()}.
%% oauth(qq,Args::[{client_id,Value::list()},{client_secret,Value::list()},{grant_type,Value::list()},{code,Value::list()},{redirect_uri,Value::list()}]) -> AccessToken::list().
%% oauth(douban,Args::[{client_id,Value::list()},{client_secret,Value::list()},{grant_type,Value::list()},{code,Value::list()},{redirect_uri,Value::list()}]) -> AccessToken::list().
oauth(sina,Args) ->
	es_sina:oauth(Args);
oauth(qq,Args) ->
	es_qq:oauth(Args);
oauth(douban,Args) ->
	es_douban:oauth(Args).

%% user(sina,Args::[{access_token,Value::list()},{uid,Value::list()}|{screen_name,Value::list()}]) -> Body::json().
%% user(qq,Args::[{access_token,Value::list()},{oauth_consume_key,Value::list()}]) -> {Openid::list(), Body::json()}. 
%% user(douban,Args::[{{access_token,list()}}]) -> {Uid::list(), Body::json()}.
user(sina,Args) ->
	es_sina:info(Args);
user(qq,Args) ->
	es_qq:info(Args);
user(douban,Args) ->
	es_douban:info(Args).

%% friendship(Args::[{access_token,Value::list()}]) -> Body::json().
friendship(Args) ->
	es_sina:create_friendship(Args).

%% blog(Args::[{access_token,Value::list()},{status,Value::list()}]) -> Res::success|failed.
blog(sina,Args) ->
	es_sina:blog(Args);
blog(qq,Args) ->
	es_qq:blog(Args).


%% blog_pic(sina,Args::[{access_token,Value::list()},{status,Value::list()},{pic,Value::list()}]) -> Res::success|failed.
%% blog_pic(qq,Args::[{access_token,Value::list()},{oauth_consumer_key,Value::list()},{openid,Value::list()},{format,Value::json|xml},{content,Value::list()},{pic,Value::list()}]) -> Res::success|failed.
blog_pic(sina,Args) ->
	es_sina:blog_pic(Args);
blog_pic(qq,Args) ->
	es_qq:blog_pic(Args).

%% blog_pic_url(sina,Args::[{access_token,Value::list()},{status,Value::list()},{url,Value::list()}]) -> Res::success|failed.
blog_pic_url(sina,Args) ->
	es_sina:blog_pic_url(Args).

%% qzone_share(Args::[{access_token,Value::list()},{oauth_consumer_key,Value::list()},{openid,Value::list()},{format,Value::json|xml},{title,Value::list()},{url,Value::list()},{site,Value::list()},{fromurl,Value::list()}]) -> Res::success|failed.
qzone_share(Args) ->
	es_qq:zone_share(Args).

