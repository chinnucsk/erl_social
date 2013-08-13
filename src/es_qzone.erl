-module(es_qzone).

-export([
		share/1
		]).

-include("erl_social.hrl").

%% @spec share(list(tuple())) -> any()
%% @doc qq post share with url to microblog and qqzone.
-spec share(list(tuple())) -> any().
share(Args) ->
    Format = erl_social_util:get_env(qq,format),
    AppKey = erl_social_util:get_env(qq,app_key),
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
    Res = case ?handle(?MODULE,erl_social_util:req({post, {qq,Path}, [erl_social_util:ct(url)], BodyReq})) of
        {error,_} ->
            failed;
        _ ->
            success
        end,
    Res.


