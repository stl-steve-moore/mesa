/*

Base64 Class taken from Randy Charles Morin
www.kbcafe.com

*/

#include "MString.hpp"
//#include "MHL7Msg.hpp"
#include <iostream>
#include <string>
#include <vector>

using namespace std;

class MBase64
///Class can encode a MHL7Msg into a base64 string or convert back from a base64 string to a normal string.
{
        
public:
      
        int encode64(char * input, int inputSize, MString& output);
        ///< method for converting a MHL7Msg into a base64 string

	int encode64(MString& input, MString& output);
	///< method for converting the input string into a base64 output string

	int decode64(std::vector<unsigned char>& returnVector, MString& base64string);
	///< method for decoding a base64 string into a vector of characters

        bool isBase64(char c);
        ///< method for determining if a character is in base64

private:
	//private methods used by encode64 and/or decode64
	std::string encode(const std::vector<unsigned char> & vby);
        std::vector<unsigned char> decode(const std::string & str);
        char encode(unsigned char uc);
        unsigned char decode(char c);
};
