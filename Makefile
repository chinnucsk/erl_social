REBAR :=rebar

.PHONY: all deps clean

all:app

app:compile
	@$(REBAR) compile

compile:deps

deps: 
	@$(REBAR) get-deps

clean:
	@$(REBAR) clean
