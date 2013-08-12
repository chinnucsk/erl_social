-module(es_douban_user).

-export([
			info/1
		]).

-include("erl_social.hrl").

-spec info(list(tuple())) -> any().
info(Args) ->
	Token = erl_social_util:get_key(access_token, Args, ?TOKEN),
	Path = "/v2/user/~me",
	Body = ?handle(erl_social_util:req({get, {doubanapi,Path}, [erl_social_util:ct(json),{"Authorization","Bearer "++Token}], []})),
	Res = erl_social_util:decode_body(Body),
	Uid = erl_social_util:get_key(<<"id">>, Res),
	{binary_to_list(Uid),Res}.


