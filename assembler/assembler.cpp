

/*
  Syntax:
  Load-immediate: li $RD,imm
  Add:            add $RD,$RS,$RT
  Subtract:       sub $RD,$RS,$RT
  Print:          print $RT
  Compare:        cmp $RS,$RT,S
*/
#include <iostream>
#include <string>
#include <fstream>
#include <vector>
#include <cstdlib>
#define ERROR -1
#define LI 0
#define ADD 1
#define SUB 2
#define PRINT 3
#define CMP 4

int getFunct(std::string & instruction);
int getReg(const std::string && reg_string);
void li(std::string& buf);
void add(std::string& buf);
void sub(std::string& buf);
void print(std::string& buf);
void cmp(std::string& buf);

std::vector<std::string> out_buffer;
int linecnt=1;

int main(int argc, char *argv[]){
  if(argc < 1){
    std::cout<<"Must give .asm file"<<std::endl;
    return 1;
  }
  std::string filePath = argv[1];
  std::ifstream FILE(filePath);
  std::string buf;


  while(std::getline(FILE,buf)){
    int funct = getFunct(buf);
    switch (funct){
      case LI : li(buf); break;
      case ADD : add(buf); break;
      case SUB : sub(buf); break;
      case PRINT : print(buf);break;
      case CMP : cmp(buf); break;
      case ERROR:
        std::cout<<"Error at Line "<<linecnt<<": Invalid Operation"<<std::endl;
        exit(1);
        break;
    }


    ++linecnt;
  }

  FILE.close();


}


void li(std::string & buf){
  int reg = getReg(buf.substr(4,2));
  int imm = std::stoi(buf.substr(7,buf.size()-7),nullptr,10);
  std::cout<<reg<<" "<<imm<<std::endl;

}
void add(std::string& buf){

}
void sub(std::string& buf){

}
void print(std::string& buf){

}
void cmp(std::string& buf){

}

int getReg(const std::string && reg){
  if(reg.compare("r0")==0 || reg.compare("0")==0){
    return 0;
  }
  if(reg.compare("r1")==0 || reg.compare("1")==0){
    return 1;
  }
  if(reg.compare("r2")==0 || reg.compare("2")==0){
    return 2;
  }
  if(reg.compare("r3")==0 || reg.compare("3")==0){
    return 3;
  }
  return ERROR;
}

int getFunct(std::string & instruction){
  int len=0;
  while(instruction[++len]!=' ');
  if(instruction.compare(0,len,"li")==0){
    return LI;
  }
  if(instruction.compare(0,len,"add")==0){
    return ADD;
  }
  if(instruction.compare(0,len,"sub")==0){
    return SUB;
  }
  if(instruction.compare(0,len,"print")==0){
    return PRINT;
  }
  if(instruction.compare(0,len,"cmp")==0){
    return CMP;
  }
  return ERROR;

}
