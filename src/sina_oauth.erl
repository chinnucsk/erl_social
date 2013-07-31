-module(sina_oauth).

-export([
		oauth/1
		]).

-include("platten.hrl").

-spec oauth(list(tuple())) -> any().
oauth(Args) ->
	Args1 = platten_util:set_all_key([{client_id, ?APP_KEY},
								{client_secret, ?APP_SECRET},
								{grant_type, ?GRANT_TYPE},
								{code, ?CODE},
								{redirect_uri, ?REDIRECT_URI}], Args),
	Path = "/oauth2/access_token",
	BodyReq = platten_util:create_body(Args1),
	platten_log:format("req~p~n",[BodyReq]),
	{ok, {_,_,Body}} = platten_util:req({post, {sina,Path}, [platten_util:ct(url)], BodyReq}),
	List = platten_util:decode_body(Body),
	platten_log:format("list~p~n",[List]),
	platten_util:get_key(<<"access_token">>, List).



