//
//  TouchID.m
//  NetualNetworkiOS
//
//  Created by Developer_Yi on 2017/5/10.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "TouchID.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation TouchID
 +(void)create
{
    //创建LAContext
    LAContext *context = [LAContext new];
    //这个属性是设置指纹输入失败之后的弹出框的选项
    context.localizedFallbackTitle = @"继续进入";
    NSError *error = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请按home键指纹解锁" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                
            }else{
                NSLog(@"%@",error.localizedDescription);
                switch (error.code) {
                    case LAErrorSystemCancel:
                    {
                        
                        break;
                    }
                    case LAErrorUserCancel:
                    {
                       
                        break;
                    }
                    case LAErrorAuthenticationFailed:
                    {
                        
                        break;
                    }
                    case LAErrorPasscodeNotSet:
                    {
                        
                        break;
                    }
                    case LAErrorTouchIDNotAvailable:
                    {
                      
                        break;
                    }
                    case LAErrorTouchIDNotEnrolled:
                    {
                        
                        break;
                    }
                    case LAErrorUserFallback:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                          
                        }];
                        break;
                    }
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            
                        }];
                        break;
                    }
                }
            }
        }];
    }else{
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
            {
                
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                
                break;
            }
            default:
            {
                
                break;
            }
        }
    }

}
@end
