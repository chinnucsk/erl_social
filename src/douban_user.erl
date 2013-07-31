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
	platten_util:decode_body(Body).


