-module(es_sina_blog).

-export([
			blog/1,
			blog_pic/1,
			blog_pic_url/1
		]).

-include("erl_social.hrl").

-spec blog(list(tuple())) -> any().
blog(Args) ->
	Args1 = erl_social_util:set_all_key([{access_token, ?TOKEN},
								{status, ?CONTENT}], Args),
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
	Args1 = erl_social_util:set_all_key([{access_token, ?TOKEN},
	                               {status, ?CONTENT},
								   {pic, ?PIC}], Args),
	{PicPath, Args2} = erl_social_util:getout_key(pic, Args1),
	{ok, Pic} = file:read_file(PicPath),
	PicBin = binary_to_list(Pic),
	{ok,Ctype} = emagic:from_buffer(Pic),
	Path = "/2/statuses/upload.json",
	Boundary = "--ABCD",
	Files = [{pic, PicPath, PicBin}],
	BodyReq = erl_social_util:format_multipart_formdata(Boundary, Args2, Files, binary_to_list(Ctype)),
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
	Args1 = erl_social_util:set_all_key([{access_token, ?TOKEN},
	                               {status, ?CONTENT},
								   {url, ?URL}], Args),
	Path = "/2/statuses/upload_url_text.json",
	BodyReq = erl_social_util:create_body(Args1), 
	Res = case ?handle(erl_social_util:req({post, {sina,Path}, [erl_social_util:ct(url)], BodyReq})) of
		{error,_} ->
			failed;
		_ ->
			success
		end,
	Res.	
		
