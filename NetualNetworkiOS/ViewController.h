//
//  ViewController.h
//  NetualNetworkiOS
//
//  Created by Developer_Yi on 2017/5/7.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol viewControllerDelegate <NSObject>

- (void)passTimes:(int )times;

@end
@interface ViewController : UIViewController
@property(nonatomic,strong)id<viewControllerDelegate>passaddress;

@end

