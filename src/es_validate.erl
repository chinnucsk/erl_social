-module(es_validate).

-export([
		sina_validate/2,
		qq_validate/2,
		douban_validate/2
		]).

%% @spec sina_validate(binary(),binary()) -> boolean()
%% @doc validate sina token and uid whether is matched.
-spec sina_validate(binary(),binary()) -> boolean().
sina_validate(Uid,Token) ->
	Id = erl_social_util:to_l(es_sina:get_token_info(erl_social_util:to_l(Token))),
	case erl_social_util:to_l(Uid) == Id of
		true ->
			true;
		false ->
			false
	end.

%% @spec qq_validate(binary(),binary()) -> boolean()
%% @doc validate sina token and uid whether is matched.
-spec qq_validate(binary(),binary()) -> boolean().
qq_validate(Uid,Token) ->
	OpenId = es_qq:get_openid(erl_social_util:to_l(Token)),
	case OpenId == Uid of
		true ->
			true;
		false ->
			false
	end.

%% @spec douban_validate(binary(),binary()) -> boolean()
%% @doc validate sina token and uid whether is matched.
-spec douban_validate(binary(),binary()) -> boolean().
douban_validate(Uid,Token) ->
	{Id,_} = es_douban:info([{access_token,erl_social_util:to_l(Token)}]),
	case Id == erl_social_util:to_l(Uid) of
		true ->
			true;
		false ->
			false
	end.
