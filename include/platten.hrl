%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% sina 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-define(APP_KEY, "2128144137").
-define(APP_SECRET, "4bd23d77f8015cbf956f113825a164b5").
-define(CODE, "9df9d4d4c798302f06fb6bcbb1fef804").

-define(TOKEN, "2.00G66nIC8VTB1C048355a4505KOVZC").
-define(CONTENT, "FUCK YOU").
-define(PIC, "/home/lucas/name.gif").

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% douban 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-define(APP_KEY_DOUBAN, "06b6c6228430e83b142452678c92b8b1").
-define(APP_SECRET_DOUBAN, "844ea0d505816b63").
-define(CODE_DOUBAN, "").

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% qq 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-define(APP_KEY_QQ, "100493774").
-define(APP_SECRET_QQ, "b89597d7694819f289175337ab315cb6").
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


-define(handle(Res),
	case Res of
		{ok, {_,_,Bodys}} ->
%				platten_log:format(platten_util:to_l(Bodys)),
				Bodys;
		{error, Reason} ->
				platten_log:error(platten_util:to_l(Reason)),
				{error,Reason}
	end).
