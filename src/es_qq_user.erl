-module(es_qq_user).

-export([
			info/1,
			get_openid/1
		]).

-include("erl_social.hrl").

-spec info(list(tuple())) -> any().
info(Args) ->
	Token = erl_social_util:get_key(access_token, Args, ?TOKEN),
	OpenId = get_openid(Token),
	OauthConsumerKey = ?APP_KEY_QQ,
	Path = "/user/get_simple_userinfo?access_token=" ++ Token ++ "&oauth_consumer_key=" ++ OauthConsumerKey ++ "&openid=" ++ binary_to_list(OpenId),
	Body = ?handle(erl_social_util:req({get, {qq,Path}, [], []})),
	Res = erl_social_util:decode_body(Body),
	{binary_to_list(OpenId), Res}.

get_openid(Token) ->
	Path = "/oauth2.0/me?access_token=" ++ Token,
	Body = ?handle(erl_social_util:req({get, {qq,Path}, [], []})),
	[_,Body1,_] = string:tokens(binary_to_list(Body)," "),
	Res = erl_social_util:decode_body(list_to_binary(Body1)),
	erl_social_util:get_key(<<"openid">>, Res).

	
