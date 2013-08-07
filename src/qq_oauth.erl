-module(qq_oauth).

-export([
		oauth/1
		]).

-include("platten.hrl").

-spec oauth(list(tuple())) -> any().
oauth(Args) ->
	Args1 = platten_util:set_all_key([{client_id, ?APP_KEY_QQ},
								{client_secret, ?APP_SECRET_QQ},
								{grant_type, ?GRANT_TYPE},
								{code, ?CODE},
								{redirect_uri, ?REDIRECT_URI_QQ}], Args),
	Path = "/oauth2.0/token",
	BodyReq =platten_util:create_body(Args1),
	platten_log:format("req~p~n",[BodyReq]),
	Body = ?handle(platten_util:req({post, {qq,Path}, [platten_util:ct(url)], BodyReq})),
	get_token(Body).

get_token(String) ->
	List = string:tokens(binary_to_list(String),"&"),
	List1 = do_parse(List, []),
	proplists:get_value("access_token", List1).

do_parse([], Acc) ->
	Acc;
do_parse([A|Rest], Acc) ->
	[Key, Value] = string:tokens(A, "="),
	do_parse(Rest, [{Key,Value}|Acc]).

