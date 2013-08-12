-module(es_qq_zone_share).

-export([
			share/1
		]).

-include("erl_social.hrl").

-spec share(list(tuple())) -> any().
share(Args) ->
	Args1 = erl_social_util:set_all_key([{access_token, ?TOKEN},
								{oauth_consumer_key,?APP_KEY_QQ},
								{openid,""},
								{format,?FORMAT_QQ},
								{title,""},
								{url,""},
								{site,?TITLE},
								{fromurl,?FROMURL}], Args),
	Path = "/share/add_share",
	BodyReq = erl_social_util:create_body(Args1), 
	Res = case ?handle(erl_social_util:req({post, {qq,Path}, [erl_social_util:ct(url)], BodyReq})) of
		{error,_} ->
			failed;
		_ ->
			success
		end,
	Res.
