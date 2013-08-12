-module(es_sina_friendship).

-export([
		create/1
		]).

-include("erl_social.hrl").

-spec create(list(tuple())) -> any().
create(Args) ->
	ok = get_value(Args),
	Args1 = erl_social_util:set_all_key([{access_token, ?TOKEN}], Args),
	Path = "/friendships/create.json",
	BodyReq = erl_social_util:create_body(Args1),
	Body = ?handle(erl_social_util:req({post, {sina,Path}, [erl_social_util:ct(url)], BodyReq})),
    erl_social_util:decode_body(Body). 

%%% ================================================================
%%% private
%%% ================================================================
get_value(Args) ->
    case erl_social_util:get_key(uid, Args) of
        false ->
            case erl_social_util:get_key(screen_name, Args) of
                false ->
                    erl_social_log:error("lacking uid or screen_name");
                _ ->
                    ok
            end;
        _ ->
            ok
    end.
	
