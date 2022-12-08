#ifndef CLIENT_H
#define CLIENT_H
 
class client{
	
private:
	
public:
	
	std::ofstream * ofileSeq;
	std::ofstream * ofileAck;
	std::ifstream * myIStream;
	
	// Functions	
	client(char * filename, char * seqlog, char * acklog);
	int sendData(int seqNumber, int socket, sockaddr_in & saddr);
	//void lastSend(int socket, sockaddr_in & saddr);
	//int receiveAck(int socket, sockaddr_in & saddr);
	//void printState();
};
 
#endif