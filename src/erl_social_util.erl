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
		 get_format_string/3,
		 normal_format/0,
		 check_if_null/2
		 ]).

-include("erl_social.hrl").

%% @doc get the enviroment varibal of application erl_social.
get_env(Provider,Type) ->
	{ok,List} = application:get_env(erl_social,providers),
	TValue = proplists:get_value(Provider,List),
	proplists:get_value(Type,TValue).

%% @doc remove the key from args.
getout_key(Key, Args) ->
	Pic = get_key(Key, Args),
	Args1 = lists:keydelete(Key, 1, Args),
	{Pic, Args1}.

%% @doc get the value of the key,see get_key/3.
get_key(Key, Args) ->
	get_key(Key, Args, false).

%% @doc get the value of the key, if not found ,use Default.
get_key(Key, Args, Default) ->
	case lists:keyfind(Key, 1, Args) of
		false ->
			Default;
		{_, T} ->
			T
	end.
%% @doc set the default value to key in args,if key not found. 
set_key(Key, Args, Default) ->
	case get_key(Key, Args) of
		false ->
			[{Key, Default}|Args];
		_ ->
			Args
	end.

%% @doc set the default value to key in args,if key not found. 
set_all_key([], Args) ->
	check_if_null(Args,[]);
set_all_key([{status, Default}|Rest], Args) ->
	Args1 = set_key(status, Args, Default),
	set_all_key(Rest, set_uri_key(status, Args1));
set_all_key([{Key, Default}|Rest], Args) ->
	Args1 = set_key(Key, Args, Default),
	set_all_key(Rest, Args1).

%% @doc set url key and encode it ,and add to the args.
set_uri_key(Key, Args) ->
	case lists:keyfind(Key, 1, Args) of
		false ->
			erl_social_log:error(?MODULE,"set uri key error");
		{Key, Value} ->
			lists:keyreplace(Key, 1, Args, {Key, http_uri:encode(Value)})
	end.

%% @doc check if exists null value, for example = "".
check_if_null([],Acc) ->
	lists:reverse(Acc);
check_if_null([{Key,Value}|_Rest],_Acc) when Value == "" ->
	Reason = atom_to_list(Key) ++ " is null",
	erl_social_log:error(?MODULE,Reason),
	?check_value({error,Reason});
check_if_null([{Key,Value}|Rest],Acc) ->
	check_if_null(Rest, [{Key,Value}|Acc]).

%% @doc create post body.
create_body(Args) ->
	Args1 = do_create_body(Args, []),
	do_combine(Args1, []).

%% @doc The third platform general path.
url({sina, Path}) ->
    Url = case application:get_env(erl_social,moca_server) of 
			{ok,enable} ->
				["http://localhost:8081", Path];
			{ok,_} ->
				["https://api.weibo.com", Path]
		  end,
    lists:flatten(Url);
url({douban, Path}) ->
    Url = case application:get_env(erl_social,moca_server) of 
			{ok,enable} ->
				["http://localhost:8081", Path];
			{ok,_} ->
				["https://www.douban.com", Path]
		  end,
    lists:flatten(Url);
url({doubanapi, Path}) ->
    Url = case application:get_env(erl_social,moca_server) of 
			{ok,enable} ->
				["http://localhost:8081", Path];
			{ok,_} ->
				["https://api.douban.com", Path]
		  end,
    lists:flatten(Url);
url({qq, Path}) ->
    Url = case application:get_env(erl_social,moca_server) of 
			{ok,enable} ->
				["http://localhost:8081", Path];
			{ok,_} ->
				["https://graph.qq.com", Path]
		  end,
	lists:flatten(Url).

%% @doc make the content-length.
header(Length) ->
	{"Content-Length", Length}.

%% @doc make the content-type.
ct(url) ->
	{"Content-Type", "application/x-www-form-urlencoded"};
ct(mul) ->
	{"Content-Type", "multipart/form-data"};
ct(json) ->
	{"Content-Type","application/json"};
ct(Boundary) ->
	{"Content-Type", "multipart/form-data; boundary=" ++ Boundary}.

%% @doc make a req use lhttpc.
req({Method, Path, Hdrs, Body}) ->
    Hdrs1 = [{"user-agent", "eunit"} | Hdrs],
    lhttpc:request(url(Path), Method, Hdrs1, Body, infinity).

%% @doc encode the json args.
encode_body(Args) ->
	jsx:encode(Args).

%% @doc decode the json args.
decode_body(Args) ->
	jsx:decode(Args, [{labels, binary}]).

%% @doc multipart formata body.
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

%% @doc turn value to list.
to_l(Key) when is_list(Key) ->
	Key;
to_l(Key) when is_atom(Key) ->
	erlang:atom_to_list(Key);
to_l(Key) when is_integer(Key) ->
	erlang:integer_to_list(Key);
to_l(Key) when is_binary(Key) ->
	erlang:binary_to_list(Key).

%% @doc get the currend value ,and put out as list.
get_format_string(Type, Format, Args)->
	{{Y,M,D},{HH,MM,SS}} = calendar:now_to_local_time(os:timestamp()),
	Format1 = lists:flatten("~B-~2.10.0B-~2.10.0BT~2.10.0B:~2.10.0B:~2.10.0BZ [" ++ erl_social_util:to_l(Type) ++ "]" ++ Format ++ "\r\n"),
	Args1 = [Y, M, D, HH, MM, SS] ++ Args,
	lists:flatten(io_lib:format(Format1, Args1)).

normal_format()->
	"(module) ~s (request) ~s (reponse) ~s".

%%% ===============================================================
%%% private
%%% ==============================================================

do_create_body([], Acc) ->
	Acc;
do_create_body([{Key, Value}|Rest], Acc) ->
	List = lists:concat([to_l(Key), "=", Value]),
	do_create_body(Rest, [List|Acc]).


do_combine([], Acc) ->
	{_, Res} = lists:split(1, lists:reverse(lists:flatten(Acc))),
	lists:reverse(Res);
do_combine([A |Rest], Acc) ->
	List = lists:concat([A, "&"]),
	do_combine(Rest, [List|Acc]).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").

util_test() ->
	
	%% getout_key test
	?assertEqual({"/home/lucas/1.pic",[]},getout_key(pic,[{pic,"/home/lucas/1.pic"}])),

	%% get_key test
	?assertEqual("123",get_key(name,[{name,"123"}])),
	?assertEqual(false,get_key(name,[{id,123}])),
	?assertEqual(456,get_key(id,[{name,"123"}],456)),

	%% set_key test
	?assertEqual([{name,"lucas"}],set_key(name,[{name,"lucas"}],"alias")),
	?assertEqual([{name,"alias"}],set_key(name,[],"alias")),

	%% set_all_key test
	?assertEqual([{name,"lucas"}],set_all_key([{name,"lucas"}],[])),
	?assertEqual([{name,"alias"}],set_all_key([{name,"lucas"}],[{name,"alias"}])),
	
	%% check_if_null test
	?assertEqual([{name,"lucas"}],check_if_null([{name,"lucas"}],[])),

	%% create_body test
	?assertEqual("name=lucas&id=123",create_body([{name,"lucas"},{id,"123"}])),

	%% header test
	?assertEqual({"Content-Length", 100},header(100)),

	%% encode_body test
	?assertEqual(<<"{\"name\":123}">>,encode_body([{name,123}])),

	%% decode_body test
	?assertEqual([{<<"name">>,123}],decode_body(<<"{\"name\":123}">>)).

-endif.

