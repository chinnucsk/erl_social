-module(es_validate).

-export([
		sina_validate/2,
		qq_validate/2,
		douban_validate/2
		]).

sina_validate(Uid,Token) ->
	Body = erl_sina:info([[access_token,erl_social_util:to_l(Token)]]),
	DBody = erl_social_util:decode_body(Body),
	Id = erl_social_util:get_key(<<"id">>,DBody),
	case Uid == Id of
		true ->
			true;
		false ->
			false
	end.

qq_validate(Uid,Token) ->
	OpenId = es_qq:get_openid(erl_social_util:to_l(Token)),
	case OpenId == Uid of
		true ->
			true;
		false ->
			false
	end.

douban_validate(Uid,Token) ->
	{Id,_} = es_douban:info([{access_token,erl_social_util:to_l(Token)}]),
	case erl_social_util:to_l(Id) == Uid of
		true ->
			true;
		false ->
			false
	end.
