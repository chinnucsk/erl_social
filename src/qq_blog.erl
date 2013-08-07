-module(qq_blog).

-export([
			blog/1,
			blog_pic/1
		]).

-include("platten.hrl").

-spec blog(list(tuple())) -> any().
blog(Args) ->
	Args1 = platten_util:set_all_key([{access_token, ?TOKEN},
								{oauth_consumer_key,?APP_KEY_QQ},
								{openid,""},
								{format,"json"},
								{content,""}], Args),
	Path = "/t/add_t",
	BodyReq = platten_util:create_body(Args1), 
	platten_util:req({post, {qq,Path}, [platten_util:ct(url)], BodyReq}),
	ok.

-spec blog_pic(list(tuple())) -> any().
blog_pic(Args) ->
	Args1 = platten_util:set_all_key([{access_token, ?TOKEN},
	                               {status, ?CONTENT},
								   {pic, ?PIC}, Args]),
	{PicPath, Args2} = platten_util:getout_key(pic, Args1),
	{ok, Pic} = file:read_file(PicPath),
	PicBin = platten_util:get_binary(Pic),
	Path = "/2/statuses/upload.json",
	Boundary = "--------------lucastesthhaha",
	Files = [{file, filename:basename(PicPath), PicBin}],
	BodyReq = platten_util:format_multipart_formdata(Boundary, Args2, Files),
	platten_util:req({post, {sina,Path}, [platten_util:ct(Boundary),platten_util:header(BodyReq)], BodyReq}),
	ok.

	
