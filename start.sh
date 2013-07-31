#!/bin/sh

NODE=platten1@127.0.0.1
COOKIE=platten

exec erl -pa ebin \
		-boot start_sasl \
		-env ERL_LIBS "deps" \
		-name $NODE \
		-s platten_sdk \
		-setcookie $COOKIE 
