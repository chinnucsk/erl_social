-module(es_douban).

-export([
		oauth/1,
		info/1
		]).

-include("erl_social.hrl").

%% @spec oauth(list(tuple())) -> any()
%% @doc douban get access_token.
-spec oauth(list(tuple())) -> any().
oauth(Args) ->
    AppKey = erl_social_util:get_env(douban,app_key),
    AppSecret = erl_social_util:get_env(douban,app_secret),
    GrantType = erl_social_util:get_env(douban,grant_type),
    Url = erl_social_util:get_env(douban,url),
	Args1 = erl_social_util:set_all_key([{client_id, AppKey},
								{client_secret, AppSecret},
								{grant_type, GrantType},
								{code, ""},
								{redirect_uri, Url}], Args),
	Path = "/service/auth2/token",
	BodyReq = erl_social_util:create_body(Args1),
	Body = ?handle(?MODULE,Path,erl_social_util:req({post, {douban,Path}, [erl_social_util:ct(url)], BodyReq})),
	List = erl_social_util:decode_body(Body),
	erl_social_util:to_l(erl_social_util:get_key(<<"access_token">>, List)).

%% @spec info(list(tuple())) -> any()
%% @doc douban get user infomations.
-spec info(list(tuple())) -> any().
info(Args) ->
    Token = erl_social_util:get_key(access_token, Args, ""),
    Path = "/v2/user/~me",
    Body = ?handle(?MODULE,Path,erl_social_util:req({get, {doubanapi,Path}, [erl_social_util:ct(json),{"Authorization","Bearer "++Token}], []})),
    Res = erl_social_util:decode_body(Body),
    Uid = erl_social_util:get_key(<<"id">>, Res),
    {erl_social_util:to_l(Uid),Res}.



