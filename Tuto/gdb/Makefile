CC := gcc
CFLAGS := -Wall -g 

.PHONY: all clean

all: app

app: main.o utils.o
	$(CC) $(CFLAGS) $^ -o $@

utils.o: utils.c utils.h
	$(CC) $(CFLAGS) -c $< -o $@

main.o: main.c utils.h
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: clean

clean:
	rm -f *.o
	rm -f app