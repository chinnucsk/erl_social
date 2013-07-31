-module(test).

-export([start/0]).
-export([start1/0]).

start() ->
	Auth = "OAbKJCwaDTGMC20RWxjBZmdxlqfTRUYo",
	Url = "https://10.32.8.2:9081/3.0/user/me",
	Head = [{"Authorization","Bearer OAbKJCwaDTGMC20RWxjBZmdxlqfTRUYo"},
			{"Content-Type","application/json"}],
	Body = [],
	Res = lhttpc:request(Url, get, Head, Body, infinity),
	io:format("res is ~p~n",[Res]).

start1() ->
	inets:start(),
	ssl:start(),
	Url = "https://10.32.8.2:9081/3.0/user/me",
	F = httpc:request(get, {Url,[{"Authorization","Bearer OAbKJCwaDTGMC20RWxjBZmdxlqfTRUYo"},{"User-Agent","xxx"}]},[],[]),
	io:format("F ~p~n",[F]).
