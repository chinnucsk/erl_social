-module(douban_user).

-export([
			info/1
		]).

-include("platten.hrl").

-spec info(list(tuple())) -> any().
info(Args) ->
	Token = platten_util:get_key(access_token, Args, ?TOKEN),
	Path = "/v2/user/~me",
	{ok, {_,_,Body}} = platten_util:req({get, {doubanapi,Path}, [platten_util:ct(json),{"Authorization","Bearer "++Token}], []}),
	Res = platten_util:decode_body(Body),
	Uid = platten_util:get_key(<<"id">>, Res),
	{binary_to_list(Uid),Res}.


