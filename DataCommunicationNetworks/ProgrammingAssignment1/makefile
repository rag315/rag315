all: client server

client: client.o
	g++ client.cpp -o client
	
server: server.o
	g++ server.cpp -o server	
	
clean:
	\rm *.o client server
