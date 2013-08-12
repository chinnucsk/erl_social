-define(handle(Res),
	case Res of
		{ok, {{200,_},_,Bodys}} ->
				erl_social_log:format(erl_social_util:to_l(Bodys)),
				Bodys;
		{ok, {_,_,Bodys}} ->
				erl_social_log:format(erl_social_util:to_l(Bodys)),
				Bodys;
		{error, Reason} ->
				erl_social_log:error(erl_social_util:to_l(Reason)),
				{error,Reason}
	end).

-define(check_value(Res)
	case Res of
		{error,Reason} ->
			throw({error,Error});
		_ ->
			Res
	end).
