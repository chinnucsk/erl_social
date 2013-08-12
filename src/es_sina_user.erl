-module(es_sina_user).

-export([
			info/1
		]).

-include("erl_social.hrl").

-spec info(list(tuple())) -> any().
info(Args) ->
	Token = erl_social_util:get_key(access_token, Args, ?TOKEN),
	{Name, Value} = get_value(Args),
	Path = "/users/show.json" ++ "?access_token=" ++ Token ++ 
			"&" ++ Name ++ "=" ++ Value,
	Body = ?handle(erl_social_util:req({get, {sina,Path}, [erl_social_util:ct(json)], []})),
	erl_social_util:decode_body(Body).

%%% =================================================================
%%% private
%%% ==================================================================
get_value(Args) ->
	case erl_social_util:get_key(uid, Args) of
		false ->
			case erl_social_util:get_key(screen_name, Args) of
				false ->
					erl_social_log:error("lacking uid or screen_name");
				Name ->
					{"screen_name", http_uri:encode(Name)}
			end;
		Uid ->
			{"uid", Uid}
	end.
