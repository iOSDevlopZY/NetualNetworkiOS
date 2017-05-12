//
//  AppDelegate.m
//  NetualNetworkiOS
//
//  Created by Developer_Yi on 2017/5/7.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "AppDelegate.h"
#import "BPNN.h"
#import <UserNotifications/UserNotifications.h>
#import "TouchID.h"

@interface AppDelegate ()
{
    NSTimer *timer1;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
     [TouchID create];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
   [self createLocalNotification];
}
#pragma mark-创建本地通知
- (void)createLocalNotification
{
    int c=process();
    if(c!=0)
    {
        UNNotificationAction *enterAction = [UNNotificationAction actionWithIdentifier:@"enterApp" title:@"恢复训练" options:UNNotificationActionOptionForeground];
        UNNotificationAction *ingnoreAction = [UNNotificationAction actionWithIdentifier:@"ignore" title:@"忽略" options:UNNotificationActionOptionDestructive];
        UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"helloIdentifier" actions:@[enterAction,ingnoreAction] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
        
        UNNotificationAttachment *attachment=[UNNotificationAttachment attachmentWithIdentifier:@"imageAttach" URL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"icon" ofType:@"png"]] options:nil error:nil];
        UNMutableNotificationContent *content=[[UNMutableNotificationContent alloc]init];
        content.badge=@1;
        content.title=@"提示";
        content.body=@"神经网络训练已暂停";
        content.categoryIdentifier = @"helloIdentifier";
        content.attachments=@[attachment];
        content.sound=[UNNotificationSound defaultSound];
        UNTimeIntervalNotificationTrigger *trigger=[UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2 repeats:NO ];
        UNNotificationRequest *request=[UNNotificationRequest requestWithIdentifier:@"myNoti" content:content trigger:trigger];
        [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObjects:category, nil]];
        //添加通知请求
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            
        }];
    }
    
    
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
   
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
