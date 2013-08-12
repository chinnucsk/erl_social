-module(es_qq).

-export([
		oauth/1,
		info/1,
		get_openid/1,
		blog/1,
		blog_pic/1,
		zone_share/1
		]).

-include("erl_social.hrl").

-spec oauth(list(tuple())) -> any().
oauth(Args) ->
    AppKey = erl_social_util:get_env(qq,app_key),
    AppSecret = erl_social_util:get_env(qq,app_secret),
    GrantType = erl_social_util:get_env(qq,grant_type),
    Url = erl_social_util:get_env(qq,url),
	Args1 = erl_social_util:set_all_key([{client_id, AppKey},
								{client_secret, AppSecret},
								{grant_type, GrantType},
								{code, ""},
								{redirect_uri, Url}], Args),
	Path = "/oauth2.0/token",
	BodyReq =erl_social_util:create_body(Args1),
	Body = ?handle(erl_social_util:req({post, {qq,Path}, [erl_social_util:ct(url)], BodyReq})),
	get_token(Body).

-spec info(list(tuple())) -> any().
info(Args) ->
    Token = erl_social_util:get_key(access_token, Args, ""),
    OpenId = get_openid(Token),
    OauthConsumerKey = erl_social:get_env(qq,app_key),
    Path = "/user/get_simple_userinfo?access_token=" ++ Token ++ "&oauth_consumer_key=" ++ OauthConsumerKey ++ "&openid=" ++ erl_social_util:to_l(OpenId),
    Body = ?handle(erl_social_util:req({get, {qq,Path}, [], []})),
    Res = erl_social_util:decode_body(Body),
    {erl_social_util:to_l(OpenId), Res}.

get_openid(Token) ->
    Path = "/oauth2.0/me?access_token=" ++ Token,
    Body = ?handle(erl_social_util:req({get, {qq,Path}, [], []})),
    [_,Body1,_] = string:tokens(erl_social_util:to_l(Body)," "),
    Res = erl_social_util:decode_body(list_to_binary(Body1)),
    erl_social_util:get_key(<<"openid">>, Res).

-spec blog(list(tuple())) -> any().
blog(Args) ->
    Format = erl_social:get_env(qq,format),
    AppKey = erl_social:get_env(qq,app_key),
    Args1 = erl_social_util:set_all_key([{access_token, ""},
                                {oauth_consumer_key,AppKey},
                                {openid,""},
                                {format, Format},
                                {content,""}], Args),
    Path = "/t/add_t",
    BodyReq = erl_social_util:create_body(Args1),
    Res = case ?handle(erl_social_util:req({post, {qq,Path}, [erl_social_util:ct(url)], BodyReq})) of
        {error,_} ->
            failed;
        _ ->
            success
        end,
    Res.

-spec blog_pic(list(tuple())) -> any().
blog_pic(Args) ->
    Format = erl_social:get_env(qq,format),
    AppKey = erl_social:get_env(qq,app_key),
    Args1 = erl_social_util:set_all_key([{access_token, ""},
                                   {oauth_consumer_key, AppKey},
                                   {openid, ""},
                                   {format, Format},
                                   {content, ""},
                                   {pic, ""}], Args),
    {PicPath, Args2} = erl_social_util:getout_key(pic, Args1),
    {ok, Pic} = file:read_file(PicPath),
    PicBin = erl_social_util:to_l(Pic),
    {ok,Ctype} = emagic:from_buffer(Pic),
    Path = "/t/add_pic_t",
    Boundary = "--ABCD",
    Files = [{pic, PicPath, PicBin}],
    BodyReq = erl_social_util:format_multipart_formdata(Boundary, Args2, Files, erl_social_util:to_l(Ctype)),
    Length = integer_to_list(length(BodyReq)),
    Res = case ?handle(erl_social_util:req({post, {qq,Path}, [erl_social_util:ct(Boundary),erl_social_util:header(Length)], BodyReq})) of
        {error,_} ->
            failed;
        _ ->
            success
        end,
    Res.

-spec zone_share(list(tuple())) -> any().
zone_share(Args) ->
    Format = erl_social:get_env(qq,format),
    AppKey = erl_social:get_env(qq,app_key),
    Args1 = erl_social_util:set_all_key([{access_token, ""},
                                {oauth_consumer_key,AppKey},
                                {openid,""},
                                {format,Format},
                                {title,""},
                                {url,""},
                                {site,""},
                                {fromurl,""}], Args),
    Path = "/share/add_share",
    BodyReq = erl_social_util:create_body(Args1),
    Res = case ?handle(erl_social_util:req({post, {qq,Path}, [erl_social_util:ct(url)], BodyReq})) of
        {error,_} ->
            failed;
        _ ->
            success
        end,
    Res.

%%% =====================================================================
%%% private
%%% =====================================================================
get_token(String) ->
	List = string:tokens(erl_social_util:to_l(String),"&"),
	List1 = do_parse(List, []),
	proplists:get_value("access_token", List1).

do_parse([], Acc) ->
	Acc;
do_parse([A|Rest], Acc) ->
	[Key, Value] = string:tokens(A, "="),
	do_parse(Rest, [{Key,Value}|Acc]).

