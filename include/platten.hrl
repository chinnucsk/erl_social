%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% sina 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-define(APP_KEY, "2128144137").
-define(APP_SECRET, "4bd23d77f8015cbf956f113825a164b5").
-define(CODE, "9df9d4d4c798302f06fb6bcbb1fef804").

-define(TOKEN, "2.00G66nIC8VTB1C048355a4505KOVZC").

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% douban 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-define(APP_KEY_DOUBAN, "06b6c6228430e83b142452678c92b8b1").
-define(APP_SECRET_DOUBAN, "844ea0d505816b63").
-define(CODE_DOUBAN, "").

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% qq 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-define(APP_KEY_QQ, "100498331").
-define(APP_SECRET_QQ, "b0c64798dd28da85f7fb7ca38ae6f6cc").
-define(CODE_QQ, "").
-define(REDIRECT_URI_QQ, "http://3.yunio.com").
-define(FORMAT_QQ, "json").
-define(TITLE, "lucas").
-define(FROMURL, "http://3.yunio.com").

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% public 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-define(REDIRECT_URI, "http://lucas.yunio.com:8001").
-define(GRANT_TYPE, "authorization_code").
-define(LOG_FILE, "/home/lucas/platten.log").
-define(CONTENT, "FUCK YOU").
-define(PIC, "/home/lucas/name.gif").
-define(URL, "http://a.hiphotos.baidu.com/album/w%3D2048/sign=fcafacd600e9390156028a3e4fd455e7/ca1349540923dd54d638b39ed009b3de9d8248f8.jpg").



-define(handle(Res),
	case Res of
		{ok, {{200,_},_,Bodys}} ->
%				platten_log:format(platten_util:to_l(Bodys)),
				Bodys;
		{ok, {_,_,Bodys}} ->
%				platten_log:format(platten_util:to_l(Bodys)),
				Bodys;
		{error, Reason} ->
%				platten_log:error(platten_util:to_l(Reason)),
				{error,Reason}
	end).
