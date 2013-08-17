-module(erl_social_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

%% @doc start the erl_social application.
start(_StartType, _StartArgs) ->
	inets:start(),
	ssl:start(),
	lhttpc:start(),
	application:start(ranch),
	application:start(cowboy),
    erl_social_sup:start_link().

%% @doc stop the erl_social application.
stop(_State) ->
    ok.


