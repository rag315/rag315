// Author: Rebecca Garcia
// Based on code provided by Maxwell Young
// And the Following Resources: 
// https://stackoverflow.com/questions/10712117/how-to-count-the-characters-in-a-text-file
// https://www.udacity.com/blog/2021/05/how-to-read-from-a-file-in-cpp.html
// https://www.programiz.com/cpp-programming/examples/even-odd
// https://forums.codeguru.com/showthread.php?353217-example-of-SO_RCVTIMEO-using-setsockopt()
// https://stackoverflow.com/questions/2876024/linux-is-there-a-read-or-recv-from-socket-with-timeout?noredirect=1&lq=1

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
#include "client.h"

using namespace std;


int main(int argc, char *argv[]){

	// declare and setup server
	struct hostent *em_host;            // pointer to a structure of type hostent
	em_host = gethostbyname(argv[1]);   // host name for emulator
	if(em_host == NULL){                // failed to obtain server's name
		cout << "Failed to obtain server.\n";
		exit(EXIT_FAILURE);
	}
 
  // ******************************************************************
  // ******************************************************************

  // client sets up datagram socket for sending
  int CESocket = socket(AF_INET, SOCK_DGRAM, 0);  
  if(CESocket < 0){
  	cout << "Error: failed to open datagram socket.\n";
  }

  // set up the sockaddr_in structure for sending
  struct sockaddr_in CE; 
  socklen_t CE_length = sizeof(CE);
  bzero(&CE, sizeof(CE)); 
  CE.sin_family = AF_INET;	
  bcopy((char *)em_host->h_addr, (char*)&CE.sin_addr.s_addr, em_host->h_length);  // both using localhost so this is fine
  char * end;
  int em_rec_port = strtol(argv[2], &end, 10);  // get emulator's receiving port and convert to int
  CE.sin_port = htons(em_rec_port);             // set to emulator's receiving port

  // ******************************************************************
  // ******************************************************************

  // client sets up datagram socket for receiving
  int ECSocket = socket(AF_INET, SOCK_DGRAM, 0);  
  if(ECSocket < 0){
  	cout << "Error: failed to open datagram socket.\n";
  }

  // set up the sockaddr_in structure for receiving
  struct sockaddr_in EC; 
  socklen_t EC_length = sizeof(EC);
  bzero(&EC, sizeof(EC)); 
  EC.sin_family = AF_INET;	
  EC.sin_addr.s_addr = htonl(INADDR_ANY);	
  char * end2;
  int cl_rec_port = strtol(argv[3], &end2, 10);  // client's receiving port and convert to int
  EC.sin_port = htons(cl_rec_port);             // set to emulator's receiving port

  // Setting Socket Options
  struct timeval tv;
  tv.tv_sec = 2; 
  tv.tv_usec = 0;
  setsockopt(ECSocket, SOL_SOCKET, SO_RCVTIMEO, (const char*)&tv, sizeof(tv));


  // do the binding
  if (bind(ECSocket, (struct sockaddr *)&EC, EC_length) == -1){
  		cout << "Error in binding.\n";
  } 


  // --------------------------------------------------------------------------
   // Initializing
  int type = 1;
  int seqNum = 0;   // Sent Sequence Num
  int recvNum = 1;  // Receiving Sequence Num

  int payLen = 30;
  int packetLen = 50;

  char  ACK[512];
  // Setting Up Logs
  ofstream ofileSeq("clientseqnum.log");
  ofstream ofileACK("clientack.log");

  // Determining Length of File
  ifstream myfile1(argv[4]);     
  myfile1.seekg(0, std::ios_base::end);
  std::streampos end_pos = myfile1.tellg();
  cout << "End Position " << end_pos << endl;
  myfile1.close();
  int filelength = end_pos;
  int i_end = (end_pos / payLen);	// Times to loop through will full length packets
  int j_end = (end_pos % payLen);	// The left over characters to loop through

  cout << "i-end " << i_end << endl;
  cout << "j-end " << j_end << endl;

  // Opening File and Initializing
  //ifstream myfile(argv[3]);
  char mychar = 0;
  string mystring;
  char myarray[payLen];



  ifstream myfile(argv[4]);

  // Loop for sending full length data packets
  for (int i = 0; i < i_end; i++) {

      // Determing Sequence Number
      if (i == 0) {
          seqNum = 0;
      }
      else if (i % 2 == 0) {
          seqNum = 0;
      }
      else {
          seqNum = 1;
      }
      // Iterate through characters of file
      for (int k = 0; k < payLen; k++) {
          // Read char by char
          mychar = myfile.get();
          myarray[k] = mychar;
      }

      // Initializing Serialized Packet
      char spacket[packetLen];
      memset(spacket, 0, packetLen);

      packet mySerialPacket(type, seqNum, strlen(myarray), myarray); // make the packet to be serialized and sent

      mySerialPacket.serialize(spacket); // serialize so spacket contains serialized contents of mySendPacket's payload
      cout << "Sending serialized packet with payload:" << myarray << endl;
      cout << "This is what the serialized packet looks like: " << spacket << endl;
      

      // Clearing Last Received ACK
      char serialized[packetLen];
      memset(serialized, 0, packetLen);
      // Receiving ACKs Go Here
      // Checking ACK SeqNum
      while (recvNum != seqNum) {
          while (recvfrom(ECSocket, serialized, 512, 0, (struct sockaddr*)&EC, &EC_length) == -1) {
              cout << "ACK Failed to Receive, Resending Packet: " << seqNum << endl;
              // Resending Packet
              sendto(CESocket, spacket, 50, 0, (struct sockaddr*)&CE, CE_length);
              // Relogging SeqNum
              ofileSeq << seqNum;
              ofileSeq << endl;
          }
          // Deserialize ACK
          char ackload[512];
          memset(ackload, 0, 512);
          packet rcvdPacket(0, 0, 0, ackload);
          rcvdPacket.deserialize(serialized);
          rcvdPacket.printContents();       // Print ACK
          recvNum = rcvdPacket.getSeqNum(); // Receiving Sequence Num

          // Log ACK #
          ofileACK << rcvdPacket.getSeqNum();
          ofileACK << endl;
      }

  }
  // Sending last data packet
  // Initializing
  type = 3;
  if (seqNum == 0) {
      seqNum = 1;
      recvNum = 0;
  }
  else {
      seqNum = 0;
      recvNum = 1;
  }
  // Clearing Values
  memset(myarray, 0, payLen);


  // Iterate through characters of file.
  for (int j = 0; j < j_end; j++) {
      // Read char by char
      mychar = myfile.get();
      myarray[j] = mychar;
  }
  // Initializing Serialized Packet
  char spacket[packetLen];
  memset(spacket, 0, packetLen);

  packet mySerialPacket(type, seqNum, strlen(myarray), myarray); // make the packet to be serialized and sent

  mySerialPacket.serialize(spacket); // serialize so spacket contains serialized contents of mySendPacket's payload
  cout << "Sending serialized packet with payload:" << myarray << endl;
  cout << "This is what the serialized packet looks like: " << spacket << endl;
  
  // Log SeqNum
  ofileSeq << seqNum;
  ofileSeq << endl;
  // Clearing Last Received ACK
  char serialized[packetLen];
  memset(serialized, 0, packetLen);
  // Receiving ACKs Go Here
  // Checking ACK SeqNum
  while (recvNum != seqNum) {
      while (recvfrom(ECSocket, serialized, 512, 0, (struct sockaddr*)&EC, &EC_length) == -1) {
          cout << "ACK Failed to Receive, Resending Packet: " << seqNum << endl;
          // Resending Packet
          sendto(CESocket, spacket, 50, 0, (struct sockaddr*)&CE, CE_length);
          // Relogging SeqNum
          ofileSeq << seqNum;
          ofileSeq << endl;
      }
      // Deserialize ACK
      char ackload[512];
      memset(ackload, 0, 512);
      packet rcvdPacket(0, 0, 0, ackload);
      rcvdPacket.deserialize(serialized);
      rcvdPacket.printContents();       // Print ACK
      recvNum = rcvdPacket.getSeqNum(); // Receiving Sequence Num

      // Updating Type
      type = rcvdPacket.getType();

      // Log ACK #
      ofileACK << rcvdPacket.getSeqNum();
      ofileACK << endl;
  }
  // Closing Sockets
  close(ECSocket);
  close(CESocket);
  return 0;
}
