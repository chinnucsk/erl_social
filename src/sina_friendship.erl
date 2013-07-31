-module(sina_friendship).

-export([
		create/1
		]).

-include("platten.hrl").

-spec create(list(tuple())) -> any().
create(Args) ->
	ok = get_value(Args),
	Args1 = platten_util:set_all_key([{access_token, ?TOKEN}], Args),
	Path = "/friendships/create.json",
	BodyReq = platten_util:create_body(Args1),
	{ok, {_,_,Body}} = platten_util:req({post, {sina,Path}, [platten_util:ct(url)], BodyReq}),
    platten_util:decode_body(Body). 

%%% ================================================================
%%% private
%%% ================================================================
get_value(Args) ->
    case platten_util:get_key(uid, Args) of
        false ->
            case platten_util:get_key(screen_name, Args) of
                false ->
                    platten_log:error("lacking uid or screen_name");
                _ ->
                    ok
            end;
        _ ->
            ok
    end.
	
