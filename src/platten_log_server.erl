-module(platten_log_server).

-behaviour(gen_server).

-export([
		start_link/0,
		log/2
		]).

-export([
		init/1,
		handle_call/3,
		handle_cast/2,
		handle_info/2,
		terminate/2,
		code_change/3
		]).

-include("platten.hrl").

-record(state, {io}).

start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

log(Type,Info) ->
	gen_server:call(?MODULE,{Type,Info}).

%%% =================================================================
%%% internal
%%% =================================================================

init([]) ->
	{ok,Io} = file:open(?LOG_FILE, [read,write,append]),
	{ok, #state{io=Io}}.

terminate(_Reason, #state{io=Io}) ->
	file:close(Io),
	ok.

handle_call({debug,Info}, _From, #state{io=Io}=State) ->
	Res = "[debug] info " ++ Info,
	Return = file:write(Io, Res),
	{reply, Return, State};
handle_call({error,Info}, _From, #state{io=Io}=State) ->
	Res = "[error] info " ++ Info,
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



