// Author: Rebecca Garcia, rag315
// Based on code provided by Maxwell Young
// Also referenced the following sources:
// https://cplusplus.com/reference/cstdlib/rand/
// https://beej.us/guide/bgnet/html/

#include<iostream>
#include <sys/types.h>   // defines types (like size_t)
#include <sys/socket.h>  // defines socket class
#include <netinet/in.h>  // defines port numbers for (internet) sockets, some address structures, and constants
#include <time.h>        // used for random number generation
#include <string.h> // using this to convert random port integer to string
#include <arpa/inet.h>
#include <stdio.h>
#include <unistd.h>

#include <cstdlib>
#include <fstream>

using namespace std;

int main(int argc, char *argv[]){
  // Initializing
  struct sockaddr_in server;    
  struct sockaddr_in client;    
  int mysocket = 0;             
 
  int i = 0;                    
  socklen_t clen = sizeof(client);  
  
  char handshake[512];
  int socket2 = 0;
  
  // Allocates a Socket
  if ((mysocket=socket(AF_INET, SOCK_DGRAM, 0))==-1)
    cout << "Error in socket creation.\n";
  // zeros structure of getaddrinfo
  memset((char *) &server, 0, sizeof(server));
  server.sin_family = AF_INET;
  server.sin_port = htons(atoi(argv[1]));
  // converts multi-byte integer types from host byte order to network byte order
  server.sin_addr.s_addr = htonl(INADDR_ANY);   
  // Binding Socket w/ error handle
  if (bind(mysocket, (struct sockaddr *)&server, sizeof(server)) == -1)
    cout << "Error in binding.\n";
  
  // ---------- Handshake & Random Port --------------------

  if (recvfrom(mysocket, handshake, 512, 0, (struct sockaddr*)&client, &clen) == -1) {
      cout << "Failed to receive handshake.\n";
  }
  else {
      cout << "Handshake: " << handshake << endl;

  };

  srand(time(NULL)); // for random seed
  int randPort = (rand() % 64511) + 1024;

  char rport[10];
  memset(rport, 0, 10);
  snprintf(rport, sizeof(rport), "%d", randPort);

  cout << endl << "Random Port: " << rport << endl << endl;

  if (sendto(mysocket, rport, 64, 0, (struct sockaddr*)&client, clen) == -1) {
      cout << "Error in sendto function.\n";
  }

 
  close(mysocket);  // Closing Socket  

  
  // PART 2 ----------------------------------

  // Allocates a Socket
  if ((socket2 = socket(AF_INET, SOCK_DGRAM, 0)) == -1) {
      cout << "Error in socket creation.\n";
  }
  else {
   //   cout << "Socket2 allocated. \n";
  }

  server.sin_port = htons(randPort);    // Using Random Port

  // Binding Socket w/ error handle
  if (bind(socket2, (struct sockaddr*)&server, sizeof(server)) == -1) {
      cout << "Error in binding.\n";
  }
  else {
   //   cout << "Socket 2 bound \n";
  }



  char flag[2];
  char myarray[4];
  string mystring;


  if (recvfrom(socket2, flag, 2, 0, (struct sockaddr*)&client, &clen) == -1) {
      cout << "Failed to receive flag. \n";
  }
  else {
   //   cout << "Received flag: " << flag << endl;
  }

 std::ofstream myfile;
 myfile.open("upload.txt");

  while (flag[0] == 'Y') {
          
      if (recvfrom(socket2, myarray, 4, 0, (struct sockaddr*)&client, &clen) == -1) {
          cout << "Failed to receive Data Packet.\n";
      } else {

        // Appending to string
        mystring += myarray[0];
        mystring += myarray[1];
        mystring += myarray[2];
        mystring += myarray[3];
        // Appending to file
        myfile << mystring;

        // Clearing Variables
        mystring.clear();
        memset(myarray, 0, sizeof(myarray));
      } 
      
        // Flag Call
      if (recvfrom(socket2, flag, 2, 0, (struct sockaddr*)&client, &clen) == -1) {
        //  cout << "Failed to receive flag.\n";
      }
      else {
        //  cout << "flag Received: " << flag << endl;
      }
      // Sending Ack
      char ack[] = "Got all that data, thanks!";
      if (sendto(socket2, ack, 64, 0, (struct sockaddr*)&client, clen) == -1) {
          cout << "Error in sendto function.\n";
      }

  
  }
  
  // Closing File
  myfile.close();
  // Closing Socket
  close(socket2);
  
  return 0;
}
