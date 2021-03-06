default: all

PROJECT := lite
PREFIX ?= /usr/local

DEBUG ?= -g -ggdb -DDEBUG
ifeq ($(DEBUG),)
	override DEBUG := -DNDEBUG -O2
endif

override LDFLAGS += -lstdc++
override CFLAGS += $(DEBUG) -MD -MP
override CXXFLAGS += $(DEBUG) -MD -MP

PROGRAMS := \
	argsort \
	bagofwords \
	dijkstra \
	heapsort \
	kruskal \
	mergesort \
	misra-gries \
	tarjan \
	treesort \
	#

HEADERS := $(wildcard *.h)

TESTS := \
	test_intrusive \
	test_associative \
	test_queue \
	test_list \
	#

COMMON := \
	#

DEPENDS = $(PROGRAMS:=.d) $(TESTS:=.d) $(COMMON:=.d)
-include $(DEPENDS)

OBJECTS = $(PROGRAMS:=.o) $(TESTS:=.o) $(COMMON:=.o)

bagofwords: LDFLAGS += -lm

$(PROGRAMS) $(TESTS) : %: %.o $(COMMON:=.o)

all: $(PROGRAMS)

RUN_TESTS := $(addprefix run/,$(TESTS))

.PHONY: test
test: $(RUN_TESTS)

.PHONY: $(RUN_TESTS)
$(RUN_TESTS) : run/%: %
	./$<

.PHONY: clean
clean:
	rm -rf $(PROGRAMS) $(TESTS) $(OBJECTS) $(DEPENDS)

.PHONY: install
install: all
	install -D -m 0644 -t $(PREFIX)/include/$(PROJECT) $(HEADERS)
	install -D -m 0755 -t $(PREFIX)/bin $(PROGRAMS)

#
