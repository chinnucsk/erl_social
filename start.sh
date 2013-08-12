#!/bin/sh

CONFIG=priv/app.config
NODE=erl_social@127.0.0.1
COOKIE=erl_social

exec erl -pa ebin \
		-boot start_sasl \
		-env ERL_LIBS "deps" \
		-config $CONFIG\
		-name $NODE \
		-s platten_sdk \
		-setcookie $COOKIE 
