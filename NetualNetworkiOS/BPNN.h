//
//  BPNN.h
//  NetualNetworkiOS
//
//  Created by Developer_Yi on 2017/5/8.
//  Copyright © 2017年 mac. All rights reserved.
//

#ifndef BPNN_h
#define BPNN_h
void CreateTestExample(const char *inPath,const char *outPath,const char *oper);
void readData(const char *inPath,const char *outPath);
void initBPNework();
double  trainNetwork(int TrainC,int remain);
double Result(double var1,double var2);
int process();
#endif /* BPNN_h */
