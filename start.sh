#!/bin/sh

CONFIG=priv/app.config
NODE=erl_social@127.0.0.1
COOKIE=erl_social
LIB_DIRS="deps"

exec erl -pa ebin \
		-boot start_sasl \
		-env ERL_LIBS "deps" \
		-config $CONFIG\
		-env ERL_LIBS $LIB_DIRS\
		-name $NODE \
		-s erl_social \
		-s sync go \
		-setcookie $COOKIE 
