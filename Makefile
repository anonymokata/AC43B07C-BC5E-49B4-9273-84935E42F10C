CFLAGS=		-g -O2 -Wall -Wextra -std=c99 -rdynamic -Isrc $(OPTFLAGS)
PREFIX?=	/usr/local

TARGET=		build/libroman_calculator.a
SO_TARGET=	$(patsubst %.a,%.so,$(TARGET))
TARGET_SOURCES=	$(wildcard src/**/*.c src/*.c)
TARGET_OBJECTS=	$(patsubst src/%.c,build/%.o,$(TARGET_SOURCES))

TEST_TARGET=	tests/check_roman_calculator
TEST_SOURCES=	$(wildcard tests/check_*.c)
TEST_OBJECTS=	$(patsubst %.c,%,$(TEST_SOURCES))

# The Target Build
all: $(TARGET) $(SO_TARGET)

# The Development Build
dev: CFLAGS=-g -Isrc -Wall -Wextra $(OPTFLAGS)
dev: all check

# Recipe for Object Files
$(TARGET_OBJECTS): build/%.o: src/%.c
	$(COMPILE.c) $(OUTPUT_OPTION) $<

# Recipe for Static Library. Links the TARGET to all objects.
$(TARGET): CFLAGS += -fPIC
$(TARGET): build $(TARGET_OBJECTS)
	$(AR) rcs $@ $(TARGET_OBJECTS)
	ranlib $@

# Recipe for Shared Library. Links each SO_TARGET to all objects.
$(SO_TARGET): $(TARGET) $(TARGET_OBJECTS)
	$(CC) -shared -o $@ $(TARGET_OBJECTS)

# Create build and bin subdirectories for object/library files and binaries.
build:
	@mkdir -p build
	@mkdir -p bin

# The Unit Tests
$(TEST_TARGET): $(TARGET)
	$(CC) $(CFLAGS) $(TEST_SOURCES) \
	-o $(TEST_TARGET) \
	$(TARGET) \
	$(shell pkg-config --libs check)
.PHONY: check
check: $(TEST_TARGET)
	./$(TEST_TARGET)

# The Cleaner.
clean:
	@rm -rf build $(TEST_OBJECTS) $(TEST_TARGET)

# Library Installer
install: all
	install -d $(DESTDIR)/$(PREFIX)/lib/
	install $(TARGET) $(DESTDIR)/$(PREFIX)/lib/
