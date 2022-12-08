// Author: Maxwell Young
// Date: Feb 1, 2016

#ifndef PACKET_H
#define PACKET_H
 
//using namespace std; 
 
class packet{
	
private:
	
    int type;       // 0 if an ACK, 1 if a data packet
	int seqnum;     // sequence number
	int length;     // number of characters carried in data field 
	char * data;    // remember this should be 0 for ACK packets
 
public:
	
	packet(int t, int s, int l, char * d); // constructor
	int getType();
	int getSeqNum();
	int getLength();
	char * getData();
	void printContents(); // print function for testing
	void serialize(char * s);
	void deserialize(char * s);
};
 
#endif