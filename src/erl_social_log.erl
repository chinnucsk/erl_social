-module(erl_social_log).

-export([
		error/1,
		format/1
		]).

error(Reason) ->
	erl_social_log_server:log(error,Reason).

format(Reason) ->
	erl_social_log_server:log(debug,Reason).
