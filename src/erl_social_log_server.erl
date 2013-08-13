-module(erl_social_log_server).

-behaviour(gen_server).

-export([
		start_link/0,
		log/3
		]).

-export([
		init/1,
		handle_call/3,
		handle_cast/2,
		handle_info/2,
		terminate/2,
		code_change/3
		]).

-include("erl_social.hrl").

-record(state, {io}).

%% @spec start_link() -> pid()
%% @doc start gen server.
start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).
%% @type logtype() =debug|error
%% @spec log(logtype(),any(),list()) -> ok | {error, file:posix() | badarg | terminated}
%% @doc log the info with type,module in the logfile. 
log(Type,Module,Info) ->
	gen_server:call(?MODULE,{Type,Module,Info}).

%%% =================================================================
%%% internal
%%% =================================================================

init([]) ->
	{ok,LogFile} = application:get_env(erl_social,logfile),
	{ok,Io} = file:open(LogFile, [read,write,append]),
	{ok, #state{io=Io}}.

terminate(_Reason, #state{io=Io}) ->
	file:close(Io),
	ok.

handle_call({debug,Module,Info}, _From, #state{io=Io}=State) ->
	Time = erl_social_util:get_time(),
	Res = Time ++ " [debug] module (" ++ erl_social_util:to_l(Module) ++  ") info " ++ Info ++ "\r\n",
	Return = file:write(Io, Res),
	{reply, Return, State};
handle_call({error,Module,Info}, _From, #state{io=Io}=State) ->
	Time = erl_social_util:get_time(),
	Res = Time ++ " [error] module (" ++ erl_social_util:to_l(Module) ++  ") info " ++ Info ++ "\r\n",
	Return = file:write(Io, Res),
	{reply, Return, State}.

handle_info({'EXIT', _Pid, _Reason}, #state{io=Io} = State) ->
	file:close(Io),
	{stop, exit, State};
handle_info({'DOWN', _Ref, process, _Pid, _Reason}, #state{io=Io} = State) ->
	file:close(Io),
    {noreply, State}.
		
handle_cast(_, State) ->
	{noreply, State}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.



