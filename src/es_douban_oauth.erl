-module(es_douban_oauth).

-export([
		oauth/1
		]).

-include("erl_social.hrl").

-spec oauth(list(tuple())) -> any().
oauth(Args) ->
	Args1 = erl_social_util:set_all_key([{client_id, ?APP_KEY_DOUBAN},
								{client_secret, ?APP_SECRET_DOUBAN},
								{grant_type, ?GRANT_TYPE},
								{code, ?CODE},
								{redirect_uri, ?REDIRECT_URI}], Args),
	Path = "/service/auth2/token",
	BodyReq = erl_social_util:create_body(Args1),
	Body = ?handle(erl_social_util:req({post, {douban,Path}, [erl_social_util:ct(url)], BodyReq})),
	List = erl_social_util:decode_body(Body),
	binary_to_list(erl_social_util:get_key(<<"access_token">>, List)).



