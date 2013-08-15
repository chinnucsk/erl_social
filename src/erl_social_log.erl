-module(erl_social_log).

-export([
		execute/3
		]).


%% API

%% @doc erl_social_log module.
execute(Type, Format, Args) ->
	log(Type, Format, Args).

%% ==================================================================
%% private functions
%% ==================================================================

%% @doc get log type.
msg(debug) ->
	debug;
msg(_) ->
	error.

%% @doc call normat log module.
log(Type, Format, Args) ->
	erl_social_log_server:log(msg(Type),Format,Args).

