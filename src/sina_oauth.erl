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
	Body = ?handle(platten_util:req({post, {sina,Path}, [platten_util:ct(url)], BodyReq})),
	List = platten_util:decode_body(Body),
	AccessToken  = binary_to_list(platten_util:get_key(<<"access_token">>, List)),
	Uid  = binary_to_list(platten_util:get_key(<<"uid">>, List)),
	{Uid, AccessToken}.



