-module(es_qzone_tests).

-compile(export_all).

-include_lib("eunit/include/eunit.hrl").

setup() ->
	application:set_env(erl_social,providers,[
        								{qq,[
            								{app_key,"2128144137"},
            								{grant_type, "authorization_code"},
            								{app_secret,"4bd23d77f8015cbf956f113825a164b5"},
            								{url,"http://lucas.yunio.com:8001"},
            								{format, "json"}
        							]}]),
	application:set_env(erl_social,port,7084),
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
		{"share", fun share_test/0}
	].

share_test() ->
	?assertEqual(success,es_qzone:share([{access_token,"123456789"},{openid,"123456"},{title,"123"},{url,"http://www.baidu.com"},{site,"123"},{fromurl,"http://lucas.com"}])).	
