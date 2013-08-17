-module(es_moca_sina_oauth).

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
-export([from_json/2]).

-record(state, {}).

%% ===================================================================
%% Callbacks
%% ===================================================================

rest_init(Req, _) ->
	{ok, Req, #state{}}.

allowed_methods(Req, Ctx) ->
    {[<<"POST">>], Req, Ctx}.

malformed_request(Req, Ctx) ->
	{false, Req, Ctx}.

resource_exists(Req, Ctx) ->
   	{true, Req, Ctx}.

from_json(Req, Ctx) ->
	Result = handle(),
	{true, set_body(Result, Req),Ctx}.

%% ===================================================================
%% Private
%% ===================================================================

handle() ->
	[
	{uid,"123456"},
	{access_token,"123456789"}
	].

set_body(Result, Req) ->
	Body = erl_social_util:encode_body(Result),
	cowboy_req:set_resp_body(Body,Req).
