-module(es_moca).

%% export API
-export([init/3]).
-export([service_available/2]).
-export([is_authorized/2]).
-export([forbidden/2]).
-export([content_types_provided/2]).
-export([content_types_accepted/2]).

%% @doc cowboy init to upgrade protocol.
init({_,http},_Req,_Opts) ->
	{upgrade, protocol, cowboy_rest}.

%% @doc validate service_avaliable is valid.
service_available(Req,Ctx) ->
	{true, Req, Ctx}.

%% @doc valide if authorized.
is_authorized(Req, Ctx) ->
	{true, Req, Ctx}.

%% @doc valide if forbidden.
forbidden(Req, Ctx) ->
	{false, Req, Ctx}.

%% @doc define the cowboy post/put content types.
content_types_provided(Req, Ctx) ->
	{[{{<<"application">>,<<"json">>,'*'}, to_json}], Req, Ctx}.

%% @doc define the cowboy get content types.
content_types_accepted(Req, Ctx) ->
    {[{'*', from_json}], Req, Ctx}.
	
