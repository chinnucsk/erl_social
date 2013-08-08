-module(platten_log).

-export([
		error/1,
		format/1
		]).

error(Reason) ->
	platten_log_server:log(error,Reason).

format(Reason) ->
	platten_log_server:log(debug,Reason).
