// Author: Rebecca Garcia
// Based on code provided by Maxwell Young
// October 19, 2022




#include <stdlib.h>
#include <cstring>
#include <cstdlib>
#include <iostream>
#include <sys/types.h>   // defines types (like size_t)
#include <sys/socket.h>  // defines socket class
#include <netinet/in.h>  // defines port numbers for (internet) sockets, some address structures, and constants
#include <netdb.h> 
#include <iostream>
#include <fstream>
#include <arpa/inet.h>   // if you want to use inet_addr() function
#include <string.h>
#include <unistd.h>
#include "packet.h" // include packet class
#include <math.h>

using namespace std;

int main(int argc, char *argv[]){
	
		
	// ******************************************************************
	// ******************************************************************
	
	// sets up datagram socket for receiving from emulator
	int ESSocket = socket(AF_INET, SOCK_DGRAM, 0);  
	if(ESSocket < 0){
		cout << "Error: failed to open datagram socket.\n";
	}

	// set up the sockaddr_in structure for receiving
	struct sockaddr_in ES; 
	socklen_t ES_length = sizeof(ES);
	bzero(&ES, sizeof(ES)); 
	ES.sin_family = AF_INET;	
	ES.sin_addr.s_addr = htonl(INADDR_ANY);	
	char * end;
	int sr_rec_port = strtol(argv[2], &end, 10);  // server's receiving port and convert to int
	ES.sin_port = htons(sr_rec_port);             // set to emulator's receiving port
		
	// Setting Socket Options
	struct timeval tv;
	tv.tv_sec = 2; // 2 seconds
	tv.tv_usec = 0;
	setsockopt(ESSocket, SOL_SOCKET, SO_RCVTIMEO, (const char*)&tv, sizeof(tv));

	// do the binding
	if (bind(ESSocket, (struct sockaddr *)&ES, ES_length) == -1)
		cout << "Error in binding.\n";		
		
	// ******************************************************************
	// ******************************************************************
	
	// declare and setup server
	struct hostent *em_host;            // pointer to a structure of type hostent
	em_host = gethostbyname(argv[1]);   // host name for emulator
	
	if(em_host == NULL){                // failed to obtain server's name
		cout << "Failed to obtain server.\n";
		exit(EXIT_FAILURE);
	}

	int SESocket = socket(AF_INET, SOCK_DGRAM, 0);
	if(SESocket < 0){
		cout << "Error in trying to open datagram socket.\n";
		exit(EXIT_FAILURE);
	}
		
	// setup sockaddr_in struct  
	struct sockaddr_in SE;	
	memset((char *) &SE, 0, sizeof(SE));
	SE.sin_family = AF_INET;
	bcopy((char *)em_host->h_addr, (char*)&SE.sin_addr.s_addr, em_host->h_length);
	int em_rec_port = strtol(argv[3], &end, 10);
	SE.sin_port = htons(em_rec_port);
	
	
	// ******************************************************************
	// ******************************************************************

  // Initializing.
	int payLen = 30;
	int packetLen = 50;

	char payload[packetLen];
	memset(payload, 0, packetLen);
	char serialized[packetLen];


  int type = 1;
  int seqNumA = 0; // current
  int seqNumB = 1; // prior
  char ack[100] = "Got all that data, thanks!";
  // Setting Up Output Log
  ofstream ofileArrival("arrival.log");
  ofstream ofile(argv[4]);  


  // Setting Up for Receiving
  while (type == 1) {
	  // Resetting Serialized Packet Between Loops
	  memset(payload, 0, packetLen);
	  packet rcvdPacket(0, 0, 0, payload);

	  /*
	  cout << "Last Serialized Packet: " << endl;
	  rcvdPacket.printContents();
	  cout << endl << endl;
	  */

	  if (recvfrom(ESSocket, serialized, packetLen, 0, (struct sockaddr*)&ES, &ES_length) == -1) {
		  // cout << "Failed to receive.\n";
	  }
	  else {
		  cout << "Received packet and deserialized to obtain the following: " << endl;
		  rcvdPacket.deserialize(serialized);
		  rcvdPacket.printContents();
		  // Logging Recvd SeqNum
		  ofileArrival << rcvdPacket.getSeqNum();
		  ofileArrival << endl;
		  // Checking SeqNum
		  if (rcvdPacket.getSeqNum() == seqNumA) {
			  // Sending Current ACK
			  packet myAckPacket(0, seqNumA, strlen(ack), ack); // make the packet to be sent
			  char spacket[100];   // for serializing the packet to send	
			  memset(spacket, 0, 100); // serialize the packet to be sent
			  myAckPacket.serialize(spacket);
			  if (sendto(SESocket, spacket, strlen(spacket), 0, (struct sockaddr*)&SE, sizeof(struct sockaddr_in)) == -1) {
				  cout << "Error in sendto function.\n";
			  }
			  // Adding to Deserialized Contents to Output File
			  char buffer[50] = { 0 };
			  snprintf(buffer, 50, "%s", rcvdPacket.getData());
			  ofile << buffer;
		  }
		  else {
			  // Sending Prior ACK
			  packet myAckPacket(0, seqNumB, strlen(ack), ack); // make the packet to be sent
			  char spacket[100];   // for serializing the packet to send	
			  memset(spacket, 0, 100); // serialize the packet to be sent
			  myAckPacket.serialize(spacket);
			  if (sendto(SESocket, spacket, strlen(spacket), 0, (struct sockaddr*)&SE, sizeof(struct sockaddr_in)) == -1) {
				  cout << "Error in sendto function.\n";
			  }
		  }
		  // Updating SeqNum
		  if (seqNumA == 0) {
			  seqNumA = 1;
			  seqNumB = 0;
		  }
		  else {
			  seqNumA = 0;
			  seqNumB = 1;
		  }
		  // Updating Type
		  type = rcvdPacket.getType();
	  }

  }
  // Closing Sockets
  close(ESSocket);
  close(SESocket);
  return 0;
  


}
