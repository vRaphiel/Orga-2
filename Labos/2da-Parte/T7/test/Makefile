CC := gcc
CFLAGS := -Wall -g 

.PHONY: all clean

all: app

app: test.o
	$(CC) $(CFLAGS) $^ -o $@

test.o: test.c
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: clean

clean:
	rm -f *.o
	rm -f app