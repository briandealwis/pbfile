CC = gcc

all: pbfile

pbfile: pbfile.m
	$(CC) -o pbfile $> -framework Foundation -framework Cocoa

clean:
	rm -f pbfile
