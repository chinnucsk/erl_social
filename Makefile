REBAR :=rebar

.PHONY: all deps clean

all:app

app:deps

deps: 
	@$(REBAR) get-deps

clean:
	@$(REBAR) clean
