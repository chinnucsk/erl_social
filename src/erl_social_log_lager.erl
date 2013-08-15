-module(erl_social_log_lager).

-export([execute/3]).

-compile([{parse_transform, lager_transform}]).

%% API

%% @doc retrive lager log function according different type.
execute(Type, Format, Args) ->
	log(msg(Type),Format,Args).

%% ================================================================
%% private functions
%% ================================================================

%% @doc judge the info type.
msg(debug) ->
	debug;
msg(_) ->
	error.

%% @doc call lager log functions.
log(debug, Format, Args) ->
	lager:debug(Format, Args);
log(error, Format, Args) ->
	lager:error(Format, Args).
