-module(erl_social_log).

-export([
		error/2,
		format/2
		]).

error(Module,Reason) ->
	erl_social_log_server:log(error,Module,Reason).

format(Module,Reason) ->
	erl_social_log_server:log(debug,Module,Reason).
	
