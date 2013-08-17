-module(es_sina_tests).

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
	application:set_env(erl_social,port,7081),
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
		{"oauth", fun oauth_test/0},
		{"info", fun info_test/0},
		{"blog", fun blog_test/0},
		{"blog_pic", fun blog_pic_test/0},
		{"blog_url", fun blog_url_test/0},
		{"friendship", fun friendship_test/0},
		{"query_token", fun query_token_test/0}
	].

oauth_test() ->
	?assertEqual({"123456","123456789"},es_sina:oauth([{code,"123"}])).	

info_test() ->
	?assertEqual([{<<"uid">>,"123456"},{<<"name">>,"lucas"}],es_sina:info([{access_token,"123456789"},{uid,"123456"}])).	

blog_test() ->
	?assertEqual(success,es_sina:blog([{access_token,"123456789"},{status,"123"}])).	

blog_pic_test() ->
	?assertEqual(success,es_sina:blog_pic([{access_token,"123456789"},{status,"123"},{pic,"/home/lucas/Pictures/1.png"}])).	

blog_url_test() ->
	?assertEqual(success,es_sina:blog_pic_url([{access_token,"123456789"},{status,"123"},{url,"http://www.baidu.com"}])).	

friendship_test() ->
	?assertEqual(success,es_sina:create_friendship([{access_token,"123456789"},{uid,"654321"}])).	

query_token_test() ->
	?assertEqual("123456",es_sina:get_token_info("123456789")).	
