-define(log(Type,Module,Req,Bodys),
		case erl_social_adapter:get_mod() of
			none ->
				ok;
			Mod ->
				Mod:execute(Type,erl_social_util:normal_format(), [erl_social_util:to_l(Module),erl_social_util:to_l(Req),erl_social_util:to_l(Bodys)])
		end).

-define(handle(Module,Req,Res),
	case Res of
		{ok, {{200,_},_,Bodys}} ->
				?log(debug,Module,Req,Bodys),
				Bodys;
		{ok, {_,_,Bodys}} ->
				?log(debug,Module,Req,Bodys),
				Bodys;
		{error, Reason} ->
				?log(error,Module,Req,Reason),
				{error,Reason}
	end).

-define(check_value(Res),
	case Res of
		{error,Reason} ->
			throw({error,Reason});
		_ ->
			Res
	end).
