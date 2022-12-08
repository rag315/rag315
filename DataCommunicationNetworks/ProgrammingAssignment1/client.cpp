// Author: Rebecca Garcia, rag315
// Based on code provided by Maxwell Young
// Also referenced the following sources:
// https://stackoverflow.com/questions/10712117/how-to-count-the-characters-in-a-text-file
// https://www.udacity.com/blog/2021/05/how-to-read-from-a-file-in-cpp.html
// https://beej.us/guide/bgnet/html/

#include <iostream>
#include <sys/types.h>   // defines types (like size_t)
#include <sys/socket.h>  // defines socket class
#include <netinet/in.h>  // defines port numbers for (internet) sockets, some address structures, and constants
#include <netdb.h> 
#include <fstream>
#include <arpa/inet.h>   // if you want to use inet_addr() function
#include <string.h>
#include <unistd.h>

using namespace std;

int main(int argc, char *argv[]) {
  


  struct hostent *s; 
  s = gethostbyname(argv[1]);       // pulls IP address from hostname
  // Initializing
  struct sockaddr_in server;        
  int mysocket = 0;                   
  socklen_t slen = sizeof(server);  

  int socket2 = 0;                  
  char handshake[512] = "ABC";
  char  rport[512];


  // Allocates a Socket
  if ((mysocket=socket(AF_INET, SOCK_DGRAM, 0))==-1) 
    cout << "Error in creating socket.\n";

                                            // zeros structure of getaddrinfo
  memset((char *) &server, 0, sizeof(server));
  server.sin_family = AF_INET;              // Always set to AF_INET   
  server.sin_port = htons(atoi(argv[2]));            // puts in Network Byte Order 
                                            // The bcopy() function copies n bytes from the area pointed to 
                                            // by s1 to the area pointed to by s2 (*s1, *s2, size_t n)
  bcopy((char *)s->h_addr,                  // Any IP address for host (h_addr)
	(char *)&server.sin_addr.s_addr,        // 4-byte IP address in Network Byte Order
	s->h_length);
 
  // obtained from https://stackoverflow.com/questions/32737083/extracting-ip-data-using-gethostbyname                                         
  struct in_addr a;
  printf("name: %s\n", s->h_name);
  while (*s->h_aliases)
      printf("alias: %s\n", *s->h_aliases++);
  while (*s->h_addr_list)
  {
      bcopy(*s->h_addr_list++, (char *) &a, sizeof(a));
      printf("address: %s\n", inet_ntoa(a));
  }

  // ---------- HandShake  & Random Port --------------------------------------
 
  if (sendto(mysocket, handshake, 8, 0, (struct sockaddr*)&server, slen) == -1)
      cout << "Error in sendto function.\n";
 
  if (recvfrom(mysocket, rport, 512, 0, (struct sockaddr*)&server, &slen) == -1){
        cout << "r_port failed to receive" << endl; 
  } else {
        cout << "Random Port: " << rport << endl;
  }
  
  int r_port = atoi(rport); // converting to integer
  
  close(mysocket);  // Closing Socket

  // Part 2 ---------------------------------------------------
  
  // Allocates a Socket
  if ((socket2 = socket(AF_INET, SOCK_DGRAM, 0)) == -1) {
      cout << "Error in creating socket.\n";
  }
  else {
  //    cout << "socket2 allocated. \n";
  }
  // Using Random Port
  server.sin_port = htons(r_port);            
 
  // Flag to intiliaze receiving loop on server end
  char flag[2] = {'Y'}; 

  // Determining Length of File
  ifstream myfile1(argv[3]);
  myfile1.seekg(0, std::ios_base::end);
  std::streampos end_pos = myfile1.tellg();
  // cout << "End Position " << end_pos << endl;
  myfile1.close();
  int filelength = end_pos;
 
  // Opening File and Initializing
  ifstream myfile(argv[3]);
  char mychar = 0;
  string mystring;
  char myarray[4];
  int count = 0;
  int loopcount = 0;
  string myline;


  if (myfile.is_open()) {
      // Initial Flag Send
      if (sendto(socket2, flag, 2, 0, (struct sockaddr*)&server, slen) == -1) {
          cout << "Error in sending flag .\n";
      }
      else {
      //    cout << "Flag Sent. \n";
      }
      // Loop for length of file
       while (loopcount <= filelength) {

           // Read char by char
           mychar = myfile.get();

           // add to char to size 4 array
           myarray[count] = mychar; 
          
           // On 4th array count, send data
           if (count == 3) {

               if (sendto(socket2, myarray, 4, 0, (struct sockaddr*)&server, slen) == -1) {
                   cout << "Error in sendto function.\n";
               }
               else {
                   cout << "Sent: " << myarray[0] << myarray[1] << myarray[2] << myarray[3] << endl;
               }

                // Clearing Variables
                
               count = -1;
               memset(myarray, 0, sizeof(myarray));

               // Sending Flag
               if (sendto(socket2, flag, 2, 0, (struct sockaddr*)&server, slen) == -1) {
                   cout << "Error in sending flag .\n";
               }
               else {
                 //  cout << "Flag Sent. \n";
               }

              // Receiving Ack
              char  ack[512];
              recvfrom(socket2, ack, 512, 0, (struct sockaddr*)&server, &slen);
              cout << ack << endl;

           }
           // Increasing loop counts
           ++count;
           ++loopcount;
            

       }
       
  }
  // Sending the last flag twice is not the most efficient, but it works. Trying to optimize led to issues
  memset(flag, 0, sizeof(flag));
  flag[2] = { 'N' };
  if (sendto(socket2, flag, 2, 0, (struct sockaddr*)&server, slen) == -1) {
      cout << "Error in sendto function.\n";
  }
  else {
     // cout << "Last Flag Sent \n";
  }
      
  if (sendto(socket2, flag, 2, 0, (struct sockaddr*)&server, slen) == -1) {
      cout << "Error in sendto function.\n";
  }
  else {
    //  cout << "Last Flag Sent \n";
  }


  // Closing File
  myfile.close();
  // Closing Socket
  close(socket2);
  
  return 0;
}
