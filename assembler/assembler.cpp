/*
  Syntax:
  Load-immediate: li $RD,imm
  Add:            add $RD,$RS,$RT
  Subtract:       sub $RD,$RS,$RT
  Print:          print $RT
  Compare:        cmp $RS,$RT,S

  registers can be referenced by $r0 - $r3 or $0 - $3
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
void appendReg(int regNum,std::string & out_instr);
void li(std::string& buf);
void add(std::string& buf);
void sub(std::string& buf);
void print(std::string& buf);
void cmp(std::string& buf);
void write_file(std::string src_file_path);
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
        std::cout<<"Invalid Operation : line "<<linecnt<<std::endl;
        break;
    }


    ++linecnt;
  }


  FILE.close();
  write_file(filePath);

}


void li(std::string & buf){
  int endpos=4;
  while(buf[++endpos]!=',');
  int reg = getReg(buf.substr(4,endpos-4));
  if(reg==ERROR){return;}
  int imm = std::stoi(buf.substr(7,buf.size()-7),nullptr,10);
  if(imm > 7 || imm <-8){
    std::cout<<"Bad Immediate Value : line "<<linecnt<<std::endl;
    return;
  }
  std::string out_instr="";
  out_instr.append("11");
  appendReg(reg,out_instr);
  out_instr.append(std::to_string((imm >>3 )& 1));
  out_instr.append(std::to_string((imm >>2 )& 1));
  out_instr.append(std::to_string((imm >>1 )& 1));
  out_instr.append(std::to_string((imm )& 1));
  //std::cout<<out_instr<<std::endl;
  out_buffer.push_back(out_instr);

}
void add(std::string& buf){
  int start=5;
  int end = 5;
  while(buf[++end]!=',');
  int RD = getReg(buf.substr(start,end-start));
  if(RD==ERROR){return;}
  start = end;
  while(buf[start++]!='$');
  end = start;
  while(buf[++end]!=',');
  int RS = getReg(buf.substr(start,end-start));
  if(RS==ERROR){return;}
  start = end;
  while(buf[start++]!='$');
  int RT = getReg(buf.substr(start,buf.size()-start));
  if(RT==ERROR){return;}
  std::string out_instr = "";
  out_instr.append("01");
  appendReg(RD,out_instr);
  appendReg(RS,out_instr);
  appendReg(RT,out_instr);
  //std::cout<<out_instr<<std::endl;
  out_buffer.push_back(out_instr);

}
void sub(std::string& buf){
  int start=5;
  int end = 5;
  while(buf[++end]!=',');
  int RD = getReg(buf.substr(start,end-start));
  if(RD==ERROR){return;}
  start = end;
  while(buf[start++]!='$');
  end = start;
  while(buf[++end]!=',');
  int RS = getReg(buf.substr(start,end-start));
  if(RS==ERROR){return;}
  start = end;
  while(buf[start++]!='$');
  int RT = getReg(buf.substr(start,buf.size()-start));
  if(RT==ERROR){return;}
  std::string out_instr = "";
  out_instr.append("10");
  appendReg(RD,out_instr);
  appendReg(RS,out_instr);
  appendReg(RT,out_instr);
  //std::cout<<out_instr<<std::endl;
  out_buffer.push_back(out_instr);

}
void print(std::string& buf){
  int endpos=7;
  int reg = getReg(buf.substr(7,buf.size()-7));
  if(reg==ERROR){return;}
  std::string out_instr="";
  out_instr.append("110");
  appendReg(reg,out_instr);
  out_instr.append("000");
  //std::cout<<out_instr<<std::endl;
  out_buffer.push_back(out_instr);
}
void cmp(std::string& buf){
  int start=5;
  int end = 5;
  while(buf[++end]!=',');
  int RS = getReg(buf.substr(start,end-start));
  if(RS==ERROR){return;}
  start = end;
  while(buf[start++]!='$');
  end = start;
  while(buf[++end]!=',');
  int RT = getReg(buf.substr(start,end-start));
  if(RT==ERROR){return;}
  start = end;
  while(buf[start++]!=',');
  int S = getReg(buf.substr(start,buf.size()-start));
  if(!(S==1 || S==2)){
    std::cout<<"Bad S Value : line "<<linecnt<<std::endl;
    return;
  }
  std::string out_instr = "";
  out_instr.append("001");
  if(S==1){
    out_instr.append("0");
  }else{
    out_instr.append("1");
  }
  appendReg(RS,out_instr);
  appendReg(RT,out_instr);

  //std::cout<<out_instr<<std::endl;
  out_buffer.push_back(out_instr);
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
  std::cout<<"Bad Register : line "<<linecnt<<std::endl;
  return ERROR;
}
void appendReg(int regNum,std::string & out_instr){
  if(regNum==0){
    out_instr.append("00");
  }
  else if(regNum==1){
    out_instr.append("01");
  }
  else if(regNum==2){
    out_instr.append("10");
  }
  else if(regNum==3){
    out_instr.append("11");
  }

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

void write_file(std::string src_file_path){
  std::ofstream FILE;
  std::string outputPath = src_file_path;
  outputPath.pop_back();
  outputPath.pop_back();
  outputPath.pop_back();
  outputPath.append("bin");

  FILE.open(outputPath);
  for(std::string & str : out_buffer){
    FILE<<str<<"\n";
  }
  FILE.close();
}
