-module(es_validate_tests).

-compile(export_all).

-include_lib("eunit/include/eunit.hrl").

setup() ->
	application:set_env(erl_social,providers,[
        								{sina,[
            								{app_key,"2128144137"},
            								{grant_type, "authorization_code"},
            								{app_secret,"4bd23d77f8015cbf956f113825a164b5"},
            								{url,"http://lucas.yunio.com:8001"},
            								{format, "json"}
        							]}]),
	application:set_env(erl_social,providers,[
        								{qq,[
            								{app_key,"2128144137"},
            								{grant_type, "authorization_code"},
            								{app_secret,"4bd23d77f8015cbf956f113825a164b5"},
            								{url,"http://lucas.yunio.com:8001"},
            								{format, "json"}
        							]}]),
	application:set_env(erl_social,providers,[
        								{douban,[
            								{app_key,"2128144137"},
            								{grant_type, "authorization_code"},
            								{app_secret,"4bd23d77f8015cbf956f113825a164b5"},
            								{url,"http://lucas.yunio.com:8001"},
            								{format, "json"}
        							]}]),
	application:set_env(erl_social,port,7085),
	application:set_env(erl_social,logtype,closed),
	application:set_env(erl_social,moca_server,enable),
	application:set_env(erl_social,dispatch_file,"../priv/dispatch.script"),
	application:start(inets),
	application:start(ssl),
	application:start(lhttpc),
	application:start(ranch),
	application:start(cowboy),
	erl_social:start().

cleanup(_) ->
	application:stop(erl_social).

all_test_() ->
	{setup, fun setup/0, fun cleanup/1, specs()}.

%% ===================================================================
%% Test Cases
%% ===================================================================

specs() ->
	[
		{"sina validate", fun sina_validate_test/0},
		{"douban validate", fun douban_validate_test/0},
		{"qq validate", fun qq_validate_test/0}
	].

sina_validate_test() ->
	?assertEqual(true,es_validate:sina_validate(<<"123456">>,<<"123456789">>)).

douban_validate_test() ->
	?assertEqual(true,es_validate:douban_validate(<<"123456">>,<<"123456789">>)).

qq_validate_test() ->
	?assertEqual(true,es_validate:qq_validate(<<"123456">>,<<"123456789">>)).	

