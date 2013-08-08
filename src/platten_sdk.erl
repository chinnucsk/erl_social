-module(platten_sdk).

-export([start/0]).

-export([oauth/2,
		user/2,
		friendship/1,
		blog/2,
		blog_pic/2
		]).

start() ->
	application:start(?MODULE).

%% oauth(sina,Args::[{client_id,Value::list()},{client_secret,Value::list()},{grant_type,Value::list()},{code,Value::list()},{redirect_uri,Value::list()}]) -> {Uid::list(),AccessToken::list()}.
%% oauth(qq,Args::[{client_id,Value::list()},{client_secret,Value::list()},{grant_type,Value::list()},{code,Value::list()},{redirect_uri,Value::list()}]) -> AccessToken::list().
%% oauth(douban,Args::[{client_id,Value::list()},{client_secret,Value::list()},{grant_type,Value::list()},{code,Value::list()},{redirect_uri,Value::list()}]) -> AccessToken::list().
oauth(sina,Args) ->
	sina_oauth:oauth(Args);
oauth(qq,Args) ->
	qq_oauth:oauth(Args);
oauth(douban,Args) ->
	douban_oauth:oauth(Args).

%% user(sina,Args::[{access_token,Value::list()},{uid,Value::list()}|{screen_name,Value::list()}]) -> Body::json().
%% user(qq,Args::[{access_token,Value::list()},{oauth_consume_key,Value::list()}]) -> {Openid::list(), Body::json()}. 
%% user(douban,Args::[{{access_token,list()}}]) -> {Uid::list(), Body::json()}.
user(sina,Args) ->
	sina_user:info(Args);
user(qq,Args) ->
	qq_user:info(Args);
user(douban,Args) ->
	douban_user:info(Args).

%% friendship(Args::[{access_token,Value::list()}]) -> Body::json().
friendship(Args) ->
	sina_friendship:create(Args).

%% blog(Args::[{access_token,Value::list()},{status,Value::list()}]) -> Res::success|failed.
blog(sina,Args) ->
	sina_blog:blog(Args);
blog(qq,Args) ->
	qq_blog:blog(Args).


%% blog_pic(sina,Args::[{access_token,Value::list()},{status,Value::list()},{pic,Value::list()}]) -> Res::success|failed.
%% blog_pic(qq,Args::[{access_token,Value::list()},{oauth_consumer_key,Value::list()},{openid,Value::list()},{format,Value::json|xml},{content,Value::list()},{pic,Value::list()}]) -> Res::success|failed.
blog_pic(sina,Args) ->
	sina_blog:blog_pic(Args);
blog_pic(qq,Args) ->
	qq_blog:blog_pic(Args).



