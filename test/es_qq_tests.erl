-module(es_qq_tests).

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
	application:set_env(erl_social,logtype,closed),
	application:set_env(erl_social,port,8082),
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
		{"oauth", fun oauth_test/0},
		{"info", fun info_test/0},
		{"blog", fun blog_test/0},
		{"blog_pic", fun blog_pic_test/0},
		{"get_openid", fun get_openid_test/0}
	].

oauth_test() ->
	?assertEqual("123456789",es_qq:oauth([{code,"123"}])).	

info_test() ->
	?assertMatch({"123456",_},es_qq:info([{access_token,"123456789"}])).	

blog_test() ->
	?assertEqual(success,es_qq:blog([{access_token,"123456789"},{content,"123"},{openid,"123456"}])).	

blog_pic_test() ->
	?assertEqual(success,es_qq:blog_pic([{access_token,"123456789"},{content,"123"},{pic,"/home/lucas/Pictures/1.png"},{openid,"123456"}])).	

get_openid_test() ->
	?assertEqual(<<"123456">>,es_qq:get_openid("123456789")).	
