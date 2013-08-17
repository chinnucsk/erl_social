-module(es_moca_qq_openid).

-include_lib("mixer/include/mixer.hrl").

-mixin([{es_moca, [
                init/3,
                is_authorized/2,
                forbidden/2,
                service_available/2,
                content_types_provided/2,
                content_types_accepted/2
            ]}]).

-export([rest_init/2]).
-export([allowed_methods/2]).
-export([malformed_request/2]).
-export([resource_exists/2]).
-export([to_json/2]).

-record(state, {}).

%% ===================================================================
%% Callbacks
%% ===================================================================

rest_init(Req, _) ->
	{ok, Req, #state{}}.

allowed_methods(Req, Ctx) ->
    {[<<"GET">>], Req, Ctx}.

malformed_request(Req, Ctx) ->
	{false, Req, Ctx}.

resource_exists(Req, Ctx) ->
   	{true, Req, Ctx}.

to_json(Req, Ctx) ->
	Result = handle(),
	{Result, Req,Ctx}.

%% ===================================================================
%% Private
%% ===================================================================

handle() ->
	<<"callback( {\"client_id\":\"100498331\",\"openid\":\"123456\"} );\n">>.

