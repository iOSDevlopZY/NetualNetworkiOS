//
//  main.c
//  NeutualNetwork
//
//  Created by Developer_Yi on 2017/4/24.
//  Copyright © 2017年 mac. All rights reserved.
//

#include <stdio.h>
#include <time.h>
#include <math.h>
#include <stdlib.h>
#include "BPNN.h"

#define Data  30000
#define In 2
#define Out 1
#define Neuron 45
#define A  0.2
#define B  0.4
#define a  0.2
#define b  0.3

double d_in[Data][In],d_out[Data][Out];
double w[Neuron][In],o[Neuron],v[Out][Neuron];
double Maxin[In],Minin[In],Maxout[Out],Minout[Out];
double OutputData[Out];
double dv[Out][Neuron],dw[Neuron][In];
double e;

//写入数据
void writeTest(const char *inPath,const char *outPath){
    FILE *fp1,*fp2;
    double r1,r2;
    int i;
    srand((unsigned)time(NULL));
    if((fp1=fopen(inPath,"w"))==NULL){
        printf("can not open the in file\n");
        exit(0);
    }
    if((fp2=fopen(outPath,"w"))==NULL){
        printf("can not open the out file\n");
        exit(0);
    }
    for(i=0;i<Data;i++){
        r1=rand()%1000/100.0;
        r2=rand()%1000/100.0;
        fprintf(fp1,"%lf  %lf\n",r1,r2);
        fprintf(fp2,"%lf \n",r1+r2);
    }
    fclose(fp1);
    fclose(fp2);
}
//从文件读取数据
void readData(const char *inPath,const char *outPath){
    FILE *fp1,*fp2;
    int i,j;
    if((fp1=fopen(inPath,"r"))==NULL){
        printf("can not open the in file\n");
        exit(0);
    }
    for(i=0;i<Data;i++)
        for(j=0; j<In; j++)
            fscanf(fp1,"%lf",&d_in[i][j]);
    fclose(fp1);
    
    if((fp2=fopen(outPath,"r"))==NULL){
        printf("can not open the out file\n");
        exit(0);
    }
    for(i=0;i<Data;i++)
        for(j=0; j<Out; j++)
            fscanf(fp1,"%lf",&d_out[i][j]);
    fclose(fp2);
}
//初始化神经网络
void initBPNework(){
    int i,j;
    //取出最大和最小值
    for(i=0; i<In; i++){
        Minin[i]=Maxin[i]=d_in[0][i];
        for(j=0; j<Data; j++)
        {
            Maxin[i]=Maxin[i]>d_in[j][i]?Maxin[i]:d_in[j][i];
            Minin[i]=Minin[i]<d_in[j][i]?Minin[i]:d_in[j][i];
        }
    }
    
    for(i=0; i<Out; i++){
        Minout[i]=Maxout[i]=d_out[0][i];
        for(j=0; j<Data; j++)
        {
            Maxout[i]=Maxout[i]>d_out[j][i]?Maxout[i]:d_out[j][i];
            Minout[i]=Minout[i]<d_out[j][i]?Minout[i]:d_out[j][i];
        }
    }
    //归一化处理，将样本限制在0到1之间
    for (i = 0; i < In; i++)
        for(j = 0; j < Data; j++)
            d_in[j][i]=(d_in[j][i]-Minin[i]+1)/(Maxin[i]-Minin[i]+1);
    
    for (i = 0; i < Out; i++)
        for(j = 0; j < Data; j++)
            d_out[j][i]=(d_out[j][i]-Minout[i]+1)/(Maxout[i]-Minout[i]+1);
    //初始化神经元
    for (i = 0; i < Neuron; ++i)
        for (j = 0; j < In; ++j){
            //设置每个神经元输入的权重
            w[i][j]=rand()*2.0/RAND_MAX-1;
            //输入权重修正量数组设置为0
            dw[i][j]=0;
        }
    
    for (i = 0; i < Neuron; ++i)
        for (j = 0; j < Out; ++j){
            //设置每个神经元输出的权重
            v[j][i]=rand()*2.0/RAND_MAX-1;
            //输出权重修正量设置为0
            dv[j][i]=0;
        }
}
//神经网络输出
void computO(int var){
    
    int i,j;
    double sum;
    
    for (i = 0; i < Neuron; ++i){
        sum=0;
        for (j = 0; j < In; ++j)
            sum+=w[i][j]*d_in[var][j];
        //利用sigmond激活函数将神经元输出激活
        o[i]=1/(1+exp(-1*sum));
    }
    
    for (i = 0; i < Out; ++i){
        sum=0;
        for (j = 0; j < Neuron; ++j)
            //输出权重和激活后的输出相乘
            sum+=v[i][j]*o[j];
        //BP网络的输出
        OutputData[i]=sum;
    }
}
//反向传播算法
void backUpdate(int var)
{
    int i,j;
    double t;
    for (i = 0; i < Neuron; ++i)
    {
        t=0;
        for (j = 0; j < Out; ++j){
            t+=(OutputData[j]-d_out[var][j])*v[j][i];
            //修改神经元对输出的权重
            dv[j][i]=A*dv[j][i]+B*(OutputData[j]-d_out[var][j])*o[i];
            v[j][i]-=dv[j][i];
        }
        
        for (j = 0; j < In; ++j){
            //修改输入对神经元的权重
            dw[i][j]=a*dw[i][j]+b*t*o[i]*(1-o[i])*d_in[var][j];
            w[i][j]-=dw[i][j];
        }
    }
}
//输出结果
double Result(double var1,double var2)
{
    int i,j;
    double sum;
    //归一化处理
    var1=(var1-Minin[0]+1)/(Maxin[0]-Minin[0]+1);
    var2=(var2-Minin[1]+1)/(Maxin[1]-Minin[1]+1);
    
    for (i = 0; i < Neuron; ++i){
        sum=0;
        sum=w[i][0]*var1+w[i][1]*var2;
        o[i]=1/(1+exp(-1*sum));
    }
    sum=0;
    for (j = 0; j < Neuron; ++j)
        sum+=v[0][j]*o[j];
    
    return sum*(Maxout[0]-Minout[0]+1)+Minout[0]-1;
}
//写入文件
void writeNeuron()
{
    FILE *fp1;
    int i,j;
    if((fp1=fopen("/Users/mac/desktop/NeutualNetwork/neuron.txt","w"))==NULL)
    {
        printf("can not open the neuron file\n");
        exit(0);
    }
    for (i = 0; i < Neuron; ++i)
        for (j = 0; j < In; ++j){
            fprintf(fp1,"%lf ",w[i][j]);
        }
    fprintf(fp1,"\n\n\n\n");
    
    for (i = 0; i < Neuron; ++i)
        for (j = 0; j < Out; ++j){
            fprintf(fp1,"%lf ",v[j][i]);
        }
    
    fclose(fp1);
}
//训练神经网络
double  trainNetwork(int TrainC){
    
    int i,c=0,j;
    //小于训练次数并且样本平均误差>0.01是继续训练
    do{
        e=0;
        for (i = 0; i < Data; ++i){
            //计算输出
            computO(i);
            for (j = 0; j < Out; ++j)
                //计算误差
                e+=fabs((OutputData[j]-d_out[i][j])/d_out[i][j]);
            //后向传播
            backUpdate(i);
        }
        printf("%d----样本平均误差为：%lf\n",c,e/Data);
        c++;
    }while(c<TrainC && e/Data>0.01);
    return e/Data;
}


