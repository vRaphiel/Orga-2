CC := gcc
CFLAGS := -Wall -Wextra -pedantic

.PHONY: all
all: app

app: main.o
	$(CC) $(CFLAGS) $^ -o $@

main.o: main.c
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: clean
clean:
	rm -f *.o
	rm -f app