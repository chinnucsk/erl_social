-module(qq_user).

-export([
			info/1,
			get_openid/1
		]).

-include("platten.hrl").

-spec info(list(tuple())) -> any().
info(Args) ->
	Token = platten_util:get_key(access_token, Args, ?TOKEN),
	OpenId = get_openid(Token),
	OauthConsumerKey = ?APP_KEY_QQ,
	Path = "/user/get_simple_userinfo?access_token=" ++ Token ++ "&oauth_consumer_key=" ++ OauthConsumerKey ++ "&openid=" ++ binary_to_list(OpenId),
	{ok, {_,_,Body}} = platten_util:req({get, {qq,Path}, [], []}),
	Res = platten_util:decode_body(Body),
	{binary_to_list(OpenId), Res}.

get_openid(Token) ->
	Path = "/oauth2.0/me?access_token=" ++ Token,
	{ok, {_,_,Body}} = platten_util:req({get, {qq,Path}, [], []}),
	[_,Body1,_] = string:tokens(binary_to_list(Body)," "),
	Res = platten_util:decode_body(list_to_binary(Body1)),
	platten_util:get_key(<<"openid">>, Res).

	
