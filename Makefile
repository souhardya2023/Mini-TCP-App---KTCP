CC = gcc
CFLAGS = -Wall -g -Isrc
LDFLAGS = -L. -lksocket -pthread
LIBRARY = libksocket.a

# Source files
SRC = src/ksocket.c src/initksocket.c src/user1.c src/user2.c

# Object files
OBJ = ksocket.o initksocket.o user1.o user2.o

# =========================
# Default target
# =========================
all: $(LIBRARY) initksocket user1 user2

# =========================
# Static Library
# =========================
$(LIBRARY): ksocket.o
	ar rcs $(LIBRARY) ksocket.o

# =========================
# Object files
# =========================
ksocket.o: src/ksocket.c src/ksocket.h
	$(CC) $(CFLAGS) -c src/ksocket.c -o ksocket.o

initksocket.o: src/initksocket.c src/ksocket.h
	$(CC) $(CFLAGS) -c src/initksocket.c -o initksocket.o

user1.o: src/user1.c src/ksocket.h
	$(CC) $(CFLAGS) -c src/user1.c -o user1.o

user2.o: src/user2.c src/ksocket.h
	$(CC) $(CFLAGS) -c src/user2.c -o user2.o

# =========================
# Executables
# =========================
initksocket: initksocket.o $(LIBRARY)
	$(CC) $(CFLAGS) -o initksocket initksocket.o $(LDFLAGS)

user1: user1.o $(LIBRARY)
	$(CC) $(CFLAGS) -o user1 user1.o $(LDFLAGS)

user2: user2.o $(LIBRARY)
	$(CC) $(CFLAGS) -o user2 user2.o $(LDFLAGS)

# =========================
# Run Targets
# =========================
run_init:
	./initksocket

run_recv:
	./user2 127.0.0.1 5076 127.0.0.1 8081

run_send:
	./user1 127.0.0.1 8081 127.0.0.1 5076

run_recv2:
	./user2 127.0.0.1 5077 127.0.0.1 8082

run_send2:
	./user1 127.0.0.1 8082 127.0.0.1 5077

# =========================
# Clean
# =========================
clean:
	rm -f *.o user1 user2 initksocket $(LIBRARY) received_file_*.txt