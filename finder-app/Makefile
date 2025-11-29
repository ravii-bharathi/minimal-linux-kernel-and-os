# finder-app/Makefile


CC = gcc
CROSS_COMPILE ?= aarch64-none-linux-gnu-
TARGET = writer
SRC = writer.c
OBJ = writer.o

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(OBJ)
	$(CROSS_COMPILE)$(CC) $(OBJ) -o $(TARGET)

$(OBJ): $(SRC)
	$(CROSS_COMPILE)$(CC) -c $(SRC) -o $(OBJ)

clean:
	rm -f $(TARGET) $(OBJ)
