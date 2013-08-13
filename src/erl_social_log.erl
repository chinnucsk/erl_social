-module(erl_social_log).

-export([
		error/2,
		format/2
		]).

%% @spec error(any(),list()) -> ok | {error, file:posix() | badarg | terminated}
%% @doc log infomations use error.
-spec error(any(),list()) -> ok | {error, file:posix() | badarg | terminated}.
error(Module,Reason) ->
	erl_social_log_server:log(error,Module,Reason).

%% @spec format(any(),list()) -> ok | {error, file:posix() | badarg | terminated}
%% @doc log infomations use debug.
-spec format(any(),list()) -> ok | {error, file:posix() | badarg | terminated}.
format(Module,Reason) ->
	erl_social_log_server:log(debug,Module,Reason).
	
