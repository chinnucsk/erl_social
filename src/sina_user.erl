-module(sina_user).

-export([
			info/1
		]).

-include("platten.hrl").

-spec info(list(tuple())) -> any().
info(Args) ->
	Token = platten_util:get_key(access_token, Args, ?TOKEN),
	{Name, Value} = get_value(Args),
	Path = "/users/show.json" ++ "?access_token=" ++ Token ++ 
			"&" ++ Name ++ "=" ++ Value,
	Body = ?handle(platten_util:req({get, {sina,Path}, [platten_util:ct(json)], []})),
	platten_util:decode_body(Body).

%%% =================================================================
%%% private
%%% ==================================================================
get_value(Args) ->
	case platten_util:get_key(uid, Args) of
		false ->
			case platten_util:get_key(screen_name, Args) of
				false ->
					platten_log:error("lacking uid or screen_name");
				Name ->
					{"screen_name", http_uri:encode(Name)}
			end;
		Uid ->
			{"uid", Uid}
	end.
