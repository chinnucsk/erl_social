REBAR := bin/rebar
EDOWNPATH := deps/edown/ebin
GIT_SERVER := https://github.com/basho/rebar.git
DEPS := $(CURDIR)/deps
BIN := $(CURDIR)/bin

.PHONY: all deps doc clean

all:app

app:compile
	@$(REBAR) compile

compile:deps

deps:$(REBAR) 
	@$(REBAR) get-deps

doc:
	./edown_make -pa $(EDOWNPATH)

bin/%:
	mkdir -p $(DEPS) $(BIN)
	git clone $(GIT_SERVER) $(DEPS)/$*
	$(MAKE) -C $(DEPS)/$*
	cp $(DEPS)/$*/$* $(BIN)/$*

clean:$(REBAR)
	@$(REBAR) clean

ifndef SUITES
EUNIT_SUITEs = 
else
EUNIT_SUITES = suites=$(SUITES)
endif

test:$(REBAR) deps
	@$(REBAR) eunit skip_deps=true $(EUNIT_SUITES)

ct: $(REBAR) deps
	@CT_COMPILE=true $(REBAR) compile -D TEST
	@$(REBAR) ct skip_deps=true -v
