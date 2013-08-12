-module(es_sina).

-export([
		oauth/1,
		info/1,
		blog/1,
		blog_pic/1,
		blog_pic_url/1,
		create_friendship/1
		]).

-include("erl_social.hrl").

-spec oauth(list(tuple())) -> any().
oauth(Args) ->
	AppKey = erl_social_util:get_env(sina,app_key),
	AppSecret = erl_social_util:get_env(sina,app_secret),
	GrantType = erl_social_util:get_env(sina,grant_type),
	Url = erl_social_util:get_env(sina,url),
	Args1 = erl_social_util:set_all_key([{client_id, AppKey},
								{client_secret, AppSecret},
								{grant_type, GrantType},
								{code, ""},
								{redirect_uri, Url}], Args),
	Path = "/oauth2/access_token",
	BodyReq = erl_social_util:create_body(Args1),
	Body = ?handle(erl_social_util:req({post, {sina,Path}, [erl_social_util:ct(url)], BodyReq})),
	List = erl_social_util:decode_body(Body),
	AccessToken  = erl_social_util:to_l(erl_social_util:get_key(<<"access_token">>, List)),
	Uid  = erl_social_util:to_l(erl_social_util:get_key(<<"uid">>, List)),
	{Uid, AccessToken}.

info(Args) ->
    Token = erl_social_util:get_key(access_token, Args, ""),
    {Name, Value} = get_value(Args),
    Path = "/users/show.json" ++ "?access_token=" ++ Token ++
            "&" ++ Name ++ "=" ++ Value,
    Body = ?handle(erl_social_util:req({get, {sina,Path}, [erl_social_util:ct(json)], []})),
    erl_social_util:decode_body(Body).

-spec blog(list(tuple())) -> any().
blog(Args) ->
    Args1 = erl_social_util:set_all_key([{access_token, ""},
                                {status, ""}], Args),
    Path = "/2/statuses/update.json",
    BodyReq = erl_social_util:create_body(Args1),
    Res = case ?handle(erl_social_util:req({post, {sina,Path}, [erl_social_util:ct(url)], BodyReq})) of
        {error,_} ->
            failed;
        _ ->
            success
        end,
    Res.

-spec blog_pic(list(tuple())) -> any().
blog_pic(Args) ->
    Args1 = erl_social_util:set_all_key([{access_token, ""},
                                   {status, ""},
                                   {pic, ""}], Args),
    {PicPath, Args2} = erl_social_util:getout_key(pic, Args1),
    {ok, Pic} = file:read_file(PicPath),
    PicBin = erl_social_util:to_l(Pic),
    {ok,Ctype} = emagic:from_buffer(Pic),
    Path = "/2/statuses/upload.json",
    Boundary = "--ABCD",
    Files = [{pic, PicPath, PicBin}],
    BodyReq = erl_social_util:format_multipart_formdata(Boundary, Args2, Files, erl_social_util:to_l(Ctype)),
    Length = integer_to_list(length(BodyReq)),
    Res1 = erl_social_util:req({post, {sina,Path}, [erl_social_util:ct(Boundary), erl_social_util:header(Length)], BodyReq}),
    Res = case ?handle(Res1) of
        {error,_} ->
            failed;
        _ ->
            success
    end,
    Res.

-spec blog_pic_url(list(tuple())) -> any().
blog_pic_url(Args) ->
    Args1 = erl_social_util:set_all_key([{access_token, ""},
                                   {status, ""},
                                   {url, ""}], Args),
    Path = "/2/statuses/upload_url_text.json",
    BodyReq = erl_social_util:create_body(Args1),
    Res = case ?handle(erl_social_util:req({post, {sina,Path}, [erl_social_util:ct(url)], BodyReq})) of
        {error,_} ->
            failed;
        _ ->
            success
        end,
    Res.

-spec create_friendship(list(tuple())) -> any().
create_friendship(Args) ->
    ok = check_uid_name_exist(Args),
    Args1 = erl_social_util:set_all_key([{access_token, ""}], Args),
    Path = "/friendships/create.json",
    BodyReq = erl_social_util:create_body(Args1),
    Body = ?handle(erl_social_util:req({post, {sina,Path}, [erl_social_util:ct(url)], BodyReq})),
    erl_social_util:decode_body(Body).

%%% ==================================================================
%%% private
%%% ==================================================================
get_value(Args) ->
    case erl_social_util:get_key(uid, Args) of
        false ->
            case erl_social_util:get_key(screen_name, Args) of
                false ->
                    erl_social_log:error(?MODULE,"lacking uid or screen_name");
                Name ->
                    {"screen_name", http_uri:encode(Name)}
            end;
        Uid ->
            {"uid", Uid}
    end.

check_uid_name_exist(Args) ->
    case erl_social_util:get_key(uid, Args) of
        false ->
            case erl_social_util:get_key(screen_name, Args) of
                false ->
                    erl_social_log:error(?MODULE,"lacking uid or screen_name");
                _ ->
                    ok
            end;
        _ ->
            ok
    end.

