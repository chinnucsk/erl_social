-module(platten_sdk).

-export([start/0]).

-export([oauth/2,
		user/2,
		friendship/1,
		blog/1,
		blog_pic/1
		]).

start() ->
	application:start(?MODULE).

oauth(sina,Args) ->
	sina_oauth:oauth(Args);
oauth(qq,Args) ->
	qq_oauth:oauth(Args);
oauth(douban,Args) ->
	douban_oauth:oauth(Args).

user(sina,Args) ->
	sina_user:info(Args);
user(qq,Args) ->
	qq_user:info(Args);
user(douban,Args) ->
	douban_user:info(Args).

friendship(Args) ->
	sina_friendship:create(Args).

blog(Args) ->
	sina_blog:blog(Args).

blog_pic(Args) ->
	sina_blog:blog_pic(Args).


