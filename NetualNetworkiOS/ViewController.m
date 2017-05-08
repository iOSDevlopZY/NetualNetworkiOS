//
//  ViewController.m
//  NetualNetworkiOS
//
//  Created by Developer_Yi on 2017/5/7.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ViewController.h"
#import "BPNN.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+NJ.h"
@interface ViewController ()
{
    bool isFinished;
    double cost;
    NSString *oper;
    NSTimer *timer;
    NSTimer *timer1;
}
//训练次数文本框
@property (weak, nonatomic) IBOutlet UITextField *trainTimesTF;
//训练按钮
@property (weak, nonatomic) IBOutlet UIButton *trainBtn;
//训练误差标签
@property (weak, nonatomic) IBOutlet UILabel *costLabel;
//输入数1
@property (weak, nonatomic) IBOutlet UITextField *enterNumber1;
//输入数2
@property (weak, nonatomic) IBOutlet UITextField *enterNumber2;
//预测按钮
@property (weak, nonatomic) IBOutlet UIButton *pridictBtn;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *operCtl;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    oper =@"+";
    isFinished=false;
    self.trainBtn.layer.borderColor=[UIColor blackColor].CGColor;
    self.trainBtn.layer.cornerRadius=4.0f;
    self.trainBtn.layer.borderWidth=2.0f;
    self.trainBtn.layer.masksToBounds=YES;
    
    self.pridictBtn.layer.borderColor=[UIColor blackColor].CGColor;
    self.pridictBtn.layer.cornerRadius=4.0f;
    self.pridictBtn.layer.borderWidth=2.0f;
    self.pridictBtn.layer.masksToBounds=YES;
    
}
#pragma mark -写入测试数据并且进行训练
- (IBAction)trainExample:(id)sender {
    if(_trainTimesTF.text==nil||[_trainTimesTF.text isEqual:@""])
    {
        UIAlertView *view=[[UIAlertView alloc]initWithTitle:@"错误" message:@"请输入训练次数" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [view show];
    }
    else
    {
        int times=_trainTimesTF.text.intValue;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex:0];
        NSString *inFilePath=[docDir stringByAppendingPathComponent:@"in.txt"];
        NSString *outFilePath=[docDir stringByAppendingPathComponent:@"out.txt"];
        const char * infilePathChar = [inFilePath UTF8String];
        const char * outfilePathChar = [outFilePath UTF8String];
        const char * operChar =[oper UTF8String];
        timer1=[NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(process) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:timer1 forMode:NSRunLoopCommonModes];
        writeTest(infilePathChar, outfilePathChar,operChar);
        readData(infilePathChar, outfilePathChar);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //初始化神经网络
            initBPNework();
            //训练神经网络
            cost=trainNetwork(times);
            isFinished=true;
        });
        timer=[NSTimer timerWithTimeInterval:1 target:self selector:@selector(checkStatus) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    }
}
#pragma mark -检测是否计算完成
- (void)checkStatus
{
    if(isFinished)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        [MBProgressHUD showSuccess:@"训练完成"];
        self.costLabel.text=[NSString stringWithFormat:@"%f",cost];
        isFinished=false;
        [timer invalidate];
        timer=nil;
        [timer1 invalidate];
        timer1=nil;
    }
}
#pragma mark -进度
- (void)process
{
    
     int c=process();
    [MBProgressHUD showMessage:[NSString stringWithFormat:@"训练神经网络%d次",c] toView:self.view];
    
}
//预测
- (IBAction)predict:(id)sender {
    if(_enterNumber1.text==nil||[_enterNumber1.text isEqual:@""]||[_enterNumber2.text isEqual:@""]||_enterNumber2.text==nil)
    {
        UIAlertView *view=[[UIAlertView alloc]initWithTitle:@"错误" message:@"输入数据不能为空" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [view show];
    }
    else
    {
        double val1=_enterNumber1.text.doubleValue;
        double val2=_enterNumber2.text.doubleValue;
        double result=Result(val1,val2);
        self.resultLabel.text=[NSString stringWithFormat:@"%f",result];
    }
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
}
- (IBAction)oper:(id)sender {
    switch([sender selectedSegmentIndex])
    {
        case 0://+
            oper=@"+";
            self.trainTimesTF.text=nil;
            self.enterNumber1.text=nil;
            self.enterNumber2.text=nil;
            break;
        case 1://-
            oper=@"-";
            self.trainTimesTF.text=nil;
            self.enterNumber1.text=nil;
            self.enterNumber2.text=nil;
            break;
        case 2://*
            oper=@"*";
            self.trainTimesTF.text=nil;
            self.enterNumber1.text=nil;
            self.enterNumber2.text=nil;
            break;
        case 3:// /
            oper=@"/";
            self.trainTimesTF.text=nil;
            self.enterNumber1.text=nil;
            self.enterNumber2.text=nil;
            break;
    }
}
@end
