-module(erl_social_util).

-export([
		 get_env/2,
		 get_key/2,
		 get_key/3,
		 getout_key/2,
		 set_key/3,
		 set_all_key/2,
		 req/1,
		 encode_body/1,
		 decode_body/1,
		 ct/1,
		 header/1,
		 create_body/1,
		 format_multipart_formdata/4,
		 to_l/1,
		 get_time/0
		 ]).

-include("erl_social.hrl").

get_env(Provider,Type) ->
	List = application:get_env(erl_social,providers),
	TValue = proplists:get_value(Provider,List),
	proplists:get_value(Type,TValue).

getout_key(Key, Args) ->
	Pic = get_key(Key, Args),
	Args1 = lists:keydelete(Key, 1, Args),
	{Pic, Args1}.

get_key(Key, Args) ->
	get_key(Key, Args, false).

get_key(Key, Args, Default) ->
	case lists:keyfind(Key, 1, Args) of
		false ->
			Default;
		{_, T} ->
			T
	end.

set_key(Key, Args, Default) ->
	case get_key(Key, Args) of
		false ->
			[{Key, Default}|Args];
		_ ->
			Args
	end.

set_all_key([], Args) ->
	check_if_null(Args,[]);
set_all_key([{status, Default}|Rest], Args) ->
	Args1 = set_key(status, Args, Default),
	set_all_key(Rest, set_uri_key(status, Args1));
set_all_key([{Key, Default}|Rest], Args) ->
	Args1 = set_key(Key, Args, Default),
	set_all_key(Rest, Args1).

set_uri_key(Key, Args) ->
	case lists:keyfind(Key, 1, Args) of
		false ->
			platten_log:error("set uri key error");
		{Key, Value} ->
			lists:keyreplace(Key, 1, Args, {Key, http_uri:encode(Value)})
	end.

check_if_null([],Acc) ->
	lists:reverse(Acc);
check_if_null([{Key,Value}|_Rest],_Acc) when Value == "" ->
	Reason = atom_to_list(Key) ++ "is null",
	erl_social_log:error(?MODULE,Reason),
	?check_value({error,Reason});
check_if_null([{Key,Value}|Rest],Acc) ->
	check_if_null(Rest, [{Key,Value}|Acc]).

create_body(Args) ->
	Args1 = do_create_body(Args, []),
	do_combine(Args1, []).

url({sina, Path}) ->
    Url = ["https://api.weibo.com", Path],
    lists:flatten(Url);
url({douban, Path}) ->
    Url = ["https://www.douban.com", Path],
    lists:flatten(Url);
url({doubanapi, Path}) ->
    Url = ["https://api.douban.com", Path],
    lists:flatten(Url);
url({qq, Path}) ->
	Url = ["https://graph.qq.com", Path],
	lists:flatten(Url).

header(Length) ->
	{"Content-Length", Length}.

ct(url) ->
	{"Content-Type", "application/x-www-form-urlencoded"};
ct(mul) ->
	{"Content-Type", "multipart/form-data"};
ct(json) ->
	{"Content-Type","application/json"};
ct(Boundary) ->
	{"Content-Type", "multipart/form-data; boundary=" ++ Boundary}.

req({Method, Path, Hdrs, Body}) ->
    Hdrs1 = [{"user-agent", "eunit"} | Hdrs],
    lhttpc:request(url(Path), Method, Hdrs1, Body, infinity).

encode_body(Args) ->
	jsx:encode(Args).

decode_body(Args) ->
	jsx:decode(Args, [{labels, binary}]).

format_multipart_formdata(Boundary, Fields, Files, Ctype) ->
    FieldParts = lists:map(fun({FieldName, FieldContent}) ->
                                   [lists:concat(["--", Boundary]),
                                    lists:concat(["Content-Disposition: form-data; name=\"",atom_to_list(FieldName),"\""]),
                                    "",
                                    FieldContent]
                           end, Fields),
    FieldParts2 = lists:append(FieldParts),
    FileParts = lists:map(fun({FieldName, FileName, FileContent}) ->
                                  [lists:concat(["--", Boundary]),
                                   lists:concat(["Content-Disposition: form-data; name=\"",atom_to_list(FieldName),"\"; filename=\"",FileName,"\""]),
                                   lists:concat(["Content-Type: ", Ctype]),
                                   "",
                                   FileContent]
                          end, Files),
    FileParts2 = lists:append(FileParts),
    EndingParts = [lists:concat(["--", Boundary, "--"]), ""],
    Parts = lists:append([FieldParts2, FileParts2, EndingParts]),
    string:join(Parts, "\r\n").

to_l(Key) when is_list(Key) ->
	Key;
to_l(Key) when is_atom(Key) ->
	erlang:atom_to_list(Key);
to_l(Key) when is_binary(Key) ->
	erlang:binary_to_list(Key).

get_time()->
	{{A1,A2,A3},{B1,B2,B3}} = calendar:now_to_local_time(os:timestamp()),
	integer_to_list(A1) ++ "year" ++ integer_to_list(A2) ++ "month" ++ integer_to_list(A3) ++ "day" ++ integer_to_list(B1) ++ "hour" ++ integer_to_list(B2) ++ "min" ++ integer_to_list(B3) ++ "sec".

%%% ===============================================================
%%% private
%%% ==============================================================

do_create_body([], Acc) ->
	lists:reverse(Acc);
do_create_body([{Key, Value}|Rest], Acc) ->
	List = lists:concat([to_l(Key), "=", Value]),
	do_create_body(Rest, [List|Acc]).


do_combine([], Acc) ->
	{_, Res} = lists:split(1, lists:reverse(lists:flatten(Acc))),
	lists:reverse(Res);
do_combine([A |Rest], Acc) ->
	List = lists:concat([A, "&"]),
	do_combine(Rest, [List|Acc]).


