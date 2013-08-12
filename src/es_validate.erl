-module(es_validate).

-export([
		sina_validate/2,
		qq_validate/2,
		douban_validate/2
		]).

sina_validate(Uid,Token) ->
	Body = erl_sina_user:info([[access_token,binary_to_list(Token)]]),
	DBody = erl_social_util:decode_body(Body),
	Id = erl_social_util:get_key(<<"id">>,DBdoy),
	case Uid == Id of
		true ->
			true;
		false ->
			false
	end.

qq_validate(Uid,Token) ->
	OpenId = es_qq_user:get_openid(binary_to_list(Token)),
	case OpenId == Uid of
		true ->
			true;
		false ->
			false
	end.

douban_validate(Uid,Token) ->
	{Id,_} = es_douban_user:info([{access_token,binary_to_list(Token)}]),
	case bianry_to_list(Id) == Uid of
		true ->
			true;
		false ->
			false
	end.
