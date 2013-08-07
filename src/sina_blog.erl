-module(sina_blog).

-export([
			blog/1,
			blog_pic/1
		]).

-include("platten.hrl").

-spec blog(list(tuple())) -> any().
blog(Args) ->
	Args1 = platten_util:set_all_key([{access_token, ?TOKEN},
								{status, ?CONTENT}], Args),
	Path = "/2/statuses/update.json",
	BodyReq = platten_util:create_body(Args1), 
	Res = case ?handle(platten_util:req({post, {sina,Path}, [platten_util:ct(url)], BodyReq})) of
		{error,_} ->
			failed;
		_ ->
			success
		end,
	Res.	

-spec blog_pic(list(tuple())) -> any().
blog_pic(Args) ->
	Args1 = platten_util:set_all_key([{access_token, ?TOKEN},
	                               {status, ?CONTENT},
								   {pic, ?PIC}], Args),
	{PicPath, Args2} = platten_util:getout_key(pic, Args1),
	{ok, Pic} = file:read_file(PicPath),
	PicBin = binary_to_list(Pic),
	Path = "/2/statuses/upload.json",
	Boundary = "--ABCD",
	Files = [{pic, PicPath, PicBin}],
	BodyReq = platten_util:format_multipart_formdata(Boundary, Args2, Files),
	Length = integer_to_list(length(BodyReq)),
	Res1 = platten_util:req({post, {sina,Path}, [platten_util:ct(Boundary),platten_util:header(Length)], BodyReq}),
	Res = case ?handle(Res1) of
		{error,_} ->
			failed;
		_ ->
			success
	end,
	Res.

	
