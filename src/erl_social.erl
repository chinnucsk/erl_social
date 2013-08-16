-module(erl_social).

-export([start/0]).

-export([
		oauth/2,
		user/2,
		friendship/1,
		blog/2,
		blog_pic/2,
		blog_pic_url/2,
		qzone_share/1,
		validate/3
		]).

%% @type provider()=sina|qq|douban.

start() ->
	application:start(?MODULE),
	start_log().

%% @spec oauth(provider(),Args::[{client_id,Value::list()}|{client_secret,Value::list()}|{grant_type,Value::list()}|{code,Value::list()}|{redirect_uri,Value::list()}]) -> AccessToken::list()
%% @doc doc Get access_token from The third platform.
oauth(sina,Args) ->
	es_sina:oauth(Args);
oauth(qq,Args) ->
	es_qq:oauth(Args);
oauth(douban,Args) ->
	es_douban:oauth(Args).

%% @spec user(provider(),Args::[{access_token,Value::list()}|{uid,Value::list()}|{screen_name,Value::list()}]|[{access_token,Value::list()}|{oauth_consume_key,Value::list()}]|[{access_token,list()}]) -> Body::json()
%% @doc Get the user informations from The third platform using token and other parmeters.
user(sina,Args) ->
	es_sina:info(Args);
user(qq,Args) ->
	es_qq:info(Args);
user(douban,Args) ->
	es_douban:info(Args).

%% @spec friendship(Args::[{access_token,Value::list()}]) -> Body::json()
%% @doc create friendship.
friendship(Args) ->
	es_sina:create_friendship(Args).

%% @spec blog(provider(),Args::[{access_token,Value::list()}|{status,Value::list()}]) -> Res::success|failed
%% @doc Post microblog.
blog(sina,Args) ->
	es_sina:blog(Args);
blog(qq,Args) ->
	es_qq:blog(Args).


%% @spec blog_pic(provider(),Args::[{access_token,Value::list()}|{status,Value::list()}|{pic,Value::list()}]|[{access_token,Value::list()}|{oauth_consumer_key,Value::list()}|{openid,Value::list()}|{format,Value::json|xml}|{content,Value::list()}|{pic,Value::list()}]) -> Res::success|failed
%% @doc Post microblog with pictures.
blog_pic(sina,Args) ->
	es_sina:blog_pic(Args);
blog_pic(qq,Args) ->
	es_qq:blog_pic(Args).

%% @spec blog_pic_url(sina,Args::[{access_token,Value::list()}|{status,Value::list()}|{url,Value::list()}]) -> Res::success|failed
%% @doc Post mircroblog with url and status.
blog_pic_url(sina,Args) ->
	es_sina:blog_pic_url(Args).

%% @spec qzone_share(Args::[{access_token,Value::list()}|{oauth_consumer_key,Value::list()}|{openid,Value::list()}|{format,Value::json|xml}|{title,Value::list()}|{url,Value::list()}|{site,Value::list()}|{fromurl,Value::list()}]) -> Res::success|failed
%% @doc Post share to qzone and qq microblog.
qzone_share(Args) ->
	es_qzone:share(Args).

%% @spec validate(provider(),Uid::binary(),Token::binary()) -> boolean()
%% @doc Validate Uid ang Token whether matches.
validate(sina,Uid,Token) ->
	es_validate:sina_validate(Uid,Token);
validate(qq,Uid,Token) ->
	es_validate:qq_validate(Uid,Token);
validate(douban,Uid,Token) ->
	es_validate:douban_validate(Uid,Token).


%% ==================================================================
%% private functions
%% ==================================================================

%% @doc start log server
%% There two type log server, one is normal(simple log server),
%% another is lager(lager server).
%% @end.
start_log() ->
    case application:get_env(erl_social,logtype) of
		{ok, closed} ->
			ok;
        {ok,normal} ->
			supervisor:start_child(erl_social_sup,{erl_social_log_server,{erl_social_log_server,start_link,[]},permanent,5000,worker,dynamic});
        {ok,lager} ->
            application:start(lager)
    end.

