-module(erl_social_adapter).

-export([get_mod/0]).

%% API. This module used for match log module.

%% @doc get current module.
get_mod() ->
	{ok, Type} = application:get_env(erl_social,logtype),
	mod(Type).

%% ===================================================================
%% private functions
%% ===================================================================

%% @doc get mod type.
mod(closed) ->
	none;
mod(normal) ->
	erl_social_log_normal;
mod(lager) ->
	erl_social_log_lager.
