/*

MBase64 Class taken from Randy Charles Morin
www.kbcafe.com

*/

#include "MBase64.hpp"


int MBase64::encode64(MString& input, MString& output)
{
        std::vector<unsigned char> vby1;
        size_t stringSize = input.size();
        char * stringBuffer = input.strData();    
        unsigned char uc;
        for (size_t i=0; i<stringSize; i++)
          { 
             uc = stringBuffer[i];
	     vby1.push_back(uc);
          }
        
	output = encode(vby1);
        return 1;
}

int MBase64::encode64(char * input, int inputSize, MString& output)
{
        std::vector<unsigned char> vby1;
        unsigned char uc;
        for (size_t i=0; i<inputSize; i++)
          { 
             uc = input[i];
	     vby1.push_back(uc);
          }
        
	output = encode(vby1);
        return 1;
}


int MBase64::decode64(std::vector<unsigned char>& returnVector, MString& base64string)
{
        returnVector = decode(base64string);
        return 1;
}


bool MBase64::isBase64(char c)
{
   if (c >= 'A' && c <= 'Z')
   {
           return true;
   }
   if (c >= 'a' && c <= 'z')
   {
           return true;
   }
   if (c >= '0' && c <= '9')
   {
           return true;
   }
   if (c == '+')
   {
           return true;
   };
   if (c == '/')
   {
           return true;
   };
   if (c == '=')
   {
           return true;
   };
   return false;
};

//**************************************************************************

//BELOW ARE PRIVATE METHODS INTENDED BY USE OF THE CLASS ONLY

//**************************************************************************

char MBase64::encode(unsigned char uc)
{
        if (uc < 26)
        {
                return 'A'+uc;
        }
        if (uc < 52)
        {
                return 'a'+(uc-26);
        }
        if (uc < 62)
        {
                return '0'+(uc-52);
        }
        if (uc == 62)
        {
                return '+';
        }
        return '/';
};

unsigned char MBase64::decode(char c)
{
   if (c >= 'A' && c <= 'Z')
   {
           return c - 'A';
   }
   if (c >= 'a' && c <= 'z')
   {
           return c - 'a' + 26;
   }
   if (c >= '0' && c <= '9')
   {
           return c - '0' + 52;
   }
   if (c == '+')
   {
           return 62;
   };
   return 63;
};

std::string MBase64::encode(const std::vector<unsigned char> & vby)
{
       std::string retval;
       if (vby.size() == 0)
       {
               return retval;
       };
       for (int i=0;i<vby.size();i+=3)
       {
               unsigned char by1=0,by2=0,by3=0;
               by1 = vby[i];
               if (i+1<vby.size())
               {
                       by2 = vby[i+1];
               };
               if (i+2<vby.size())
               {
                       by3 = vby[i+2];
               }
               unsigned char by4=0,by5=0,by6=0,by7=0;
               by4 = by1>>2;
               by5 = ((by1&0x3)<<4)|(by2>>4);
               by6 = ((by2&0xf)<<2)|(by3>>6);
               by7 = by3&0x3f;
               retval += encode(by4);
               retval += encode(by5);
               if (i+1<vby.size())
               {
                       retval += encode(by6);
               }
               else
               {
                       retval += "=";
               };
               if (i+2<vby.size())
               {
                       retval += encode(by7);
               }
               else
               {
                       retval += "=";
               };
               if (i % (76/4*3) == 0)
               {
                       retval += "\r\n";
               }
       };
       return retval;
};

std::vector<unsigned char> MBase64::decode(
       const std::string & _str)
{
       std::string str;
       for (int j=0;j<_str.length();j++)
       {
               if (isBase64(_str[j]))
               {
                       str += _str[j];
               }
       }
       std::vector<unsigned char> retval;
       if (str.length() == 0)
       {
               return retval;
       }
       for (int i=0;i<str.length();i+=4)
       {
               char c1='A',c2='A',c3='A',c4='A';
               c1 = str[i];
               if (i+1<str.length())
               {
                       c2 = str[i+1];
               };
               if (i+2<str.length())
               {
                       c3 = str[i+2];
               };
               if (i+3<str.length())
               {
                       c4 = str[i+3];
               };
               unsigned char by1=0,by2=0,by3=0,by4=0;
               by1 = decode(c1);
               by2 = decode(c2);
               by3 = decode(c3);
               by4 = decode(c4);
               retval.push_back( (by1<<2)|(by2>>4) );
               if (c3 != '=')
               {
                       retval.push_back( ((by2&0xf)<<4)|(by3>>2) );
               }
               if (c4 != '=')
               {
                       retval.push_back( ((by3&0x3)<<6)|by4 );
               };
       };
       return retval;
};



	
