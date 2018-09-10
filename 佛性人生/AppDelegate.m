//
//  AppDelegate.m
//  佛性人生
//
//  Created by sunny&pei on 2018/4/4.
//  Copyright © 2018年 sunny&pei. All rights reserved.
//

#import "AppDelegate.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#define IOS11_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)
//#define IOS9_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
//#define IOS8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
//#define IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self replyPushNotificationAuthorization:application];
    return YES;
}
#pragma mark - 申请通知权限
- (void)replyPushNotificationAuthorization:(UIApplication *)application{
        //iOS 10以后
        if (@available(iOS 10.0, *)) {
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            //设置代理，不然无法监听通知的接收和点击事件
            center.delegate = self;
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (!error && granted) {
                    //用户点击允许
                    NSLog(@"注册成功");
                }else{
                    //用户点击不允许
                    NSLog(@"注册失败");
                }
            }];
            // 可以通过 getNotificationSettingsWithCompletionHandler 获取权限设置
            //之前注册推送服务，用户点击了同意还是不同意，以及用户之后又做了怎样的更改我们都无从得知，现在 apple 开放了这个 API，我们可以直接获取到用户的设定信息了。注意UNNotificationSettings是只读对象哦，不能直接修改！
            [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                NSLog(@"打印用户设置========%@",settings);
            }];
            //设置推送内容
            UNMutableNotificationContent *content = [UNMutableNotificationContent new];
            content.title = @"还在纠结吗？让我来帮你选择吧！";
//            content.subtitle = @"副标题";
//            content.body = @"这是信息中心";
            content.badge = @1;
            content.categoryIdentifier = @"BuddaNotifationID";
            content.sound = [UNNotificationSound defaultSound];
            
            //        需要解锁显示，红色文字。点击不会进app。
            //        UNNotificationActionOptionAuthenticationRequired = (1 << 0),
            //
            //        黑色文字。点击不会进app。
            //        UNNotificationActionOptionDestructive = (1 << 1),
            //
            //        黑色文字。点击会进app。
            //        UNNotificationActionOptionForeground = (1 << 2),
            UNNotificationAction *action = [UNNotificationAction actionWithIdentifier:@"enterApp" title:@"进入" options:UNNotificationActionOptionForeground];
            UNNotificationAction *clearAction = [UNNotificationAction actionWithIdentifier:@"destructive" title:@"忽略" options:UNNotificationActionOptionDestructive];
            NSString *requestID = @"requestID";
            UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"BuddaNotifationID" actions:@[action,clearAction] intentIdentifiers:@[requestID] options:UNNotificationCategoryOptionNone];
            [center setNotificationCategories:[NSSet setWithObject:category]];
            //设置推送方式
            NSDateComponents *component = [[NSDateComponents alloc]init];
//            component.weekday = 6;
            component.hour = 11;
            component.minute = 35;
            component.second = 20;
            UNCalendarNotificationTrigger *calenderTrigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:component repeats:YES];
            
            //添加request
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestID content:content trigger:calenderTrigger];
            [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                
            }];
        } else{
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
            [application registerUserNotificationSettings:settings];
        }
    
    
}
#pragma mark - UNUserNotificationCenterDelegate
//将要发送通知
//- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
//    //收到推送的请求
//    UNNotificationRequest *request = notification.request;
//    //收到推送的内容
//    UNNotificationContent *content = request.content;
//    //收到用户的基本信息
//    NSDictionary *userInfo = content.userInfo;
//    //收到推送消息的角标
//    NSNumber *badge = content.badge;
//    //收到推送的消息的body
//    NSString *body = content.body;
//    //
//    UNNotificationSound *sound = content.sound;
//    //
//    NSString *subtitle = content.title;
////    if ([notification.request.trigger isKindOfClass:[UNCalendarNotificationTrigger class]]) {
////        <#statements#>
////    }
//    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
//}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler{
//    UNNotification *noti = response.notification;
//    UNNotificationRequest *request = noti.request;
//    UNNotificationContent *content = request.content;
    [center removeAllDeliveredNotifications];

}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if(IOS11_OR_LATER){
        /*
         iOS 11后，直接设置badgeNumber = -1就生效了
         */
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = -1;
    }else{
        UILocalNotification *clearEpisodeNotification = [[UILocalNotification alloc] init];
        clearEpisodeNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:(0.3)];
        clearEpisodeNotification.timeZone = [NSTimeZone defaultTimeZone];
        clearEpisodeNotification.applicationIconBadgeNumber = -1;
        [[UIApplication sharedApplication] scheduleLocalNotification:clearEpisodeNotification];
    }

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
