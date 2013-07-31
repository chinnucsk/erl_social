-module(platten_log).

-export([
		error/1,
		format/2
		]).

error(Args) ->
	erlang:error(Args).

format(A, B) ->
	io:format(A,B).
