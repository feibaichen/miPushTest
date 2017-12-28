//
//  AppDelegate.m
//  miPushTest
//
//  Created by Derek on 13/12/17.
//  Copyright © 2017年 Derek. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "MiPushSDK.h"
@interface AppDelegate ()<MiPushSDKDelegate,UNUserNotificationCenterDelegate,UIAlertViewDelegate>
{
     ViewController *vMain;

}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    //只启动APNs.
    //[MiPushSDK registerMiPush:self];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    vMain = [[ViewController alloc] init];
    //vMain.iDelegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vMain];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    NSLog(@"%@", [MiPushSDK getRegId]);
    
    // 同时启用APNs跟应用内长连接
    [MiPushSDK registerMiPush:self type:0 connect:YES];
    
    //[//MiPushSDK registerMiPush:self type:UIRemoteNotificationTypeBadge];
    
    
    // 处理点击通知打开app的逻辑
    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(userInfo){//推送信息
        NSString *messageId = [userInfo objectForKey:@"_id_"];
        if (messageId!=nil) {
            [MiPushSDK openAppNotify:messageId];
        }
        
        //弹出推送的信息数据，测试用（可以删除）==========
        
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"gg" message:[NSString stringWithFormat:@"%@", userInfo] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *act = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:act];
        [nav presentViewController:alert animated:YES completion:nil];
        
        //弹出推送的信息数据，测试用（可以删除）==========
    }
    
    
    return YES;
}

#pragma mark 注册push服务.
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    
    //[MiPushSDK setAlias:@"15671822786"];
    
    //[MiPushSDK subscribe:@"this is a mi push"];
    
    // 注册APNS成功, 注册deviceToken
    [MiPushSDK bindDeviceToken:deviceToken];
    
    
    [MiPushSDK setAlias:@"15671822786"];//设置别名
    
    [MiPushSDK subscribe:@"this is a mi push"];
    
}
#pragma mark Local And Push Notification
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    
    // 当同时启动APNs与内部长连接时, 把两处收到的消息合并. 通过miPushReceiveNotification返回
    [MiPushSDK handleReceiveRemoteNotification:userInfo];
}

// iOS10新加入的回调方法
// 应用在前台收到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        [MiPushSDK handleReceiveRemoteNotification:userInfo];
        
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
       completionHandler(UNNotificationPresentationOptionAlert);
}

// 点击通知进入应用
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        [MiPushSDK handleReceiveRemoteNotification:userInfo];
        
        
        if([[userInfo valueForKey:@"userinfo"] valueForKey:@"uid"] != nil)
        {
            ViewController *mp = [[ViewController alloc] init];
            //携带数据
            //mp.playDoc = [userInfo valueForKey:@"userinfo"];
            
            
            [self.window.rootViewController presentViewController:mp animated:YES completion:nil];
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        }
        
        //进入通知跳转页面写这里
    }
    completionHandler();
}

#pragma mark MiPushSDKDelegate
- (void)miPushRequestSuccWithSelector:(NSString *)selector data:(NSDictionary *)data
{
    //[vMain printLog:[NSString stringWithFormat:@"command succ(%@): %@", [self getOperateType:selector], data]];
    
    if ([selector isEqualToString:@"bindDeviceToken:"]) {
        NSLog(@"regid=%@",data[@"regid"]);
    }
    
    NSLog(@"小米回调成功%@",data);
}

- (void)miPushRequestErrWithSelector:(NSString *)selector error:(int)error data:(NSDictionary *)data
{
    //[vMain printLog:[NSString stringWithFormat:@"command error(%d|%@): %@", error, [self getOperateType:selector], data]];
     NSLog(@"小米回调失败%@",data);
}

- (void)miPushReceiveNotification:(NSDictionary*)data
{
    // 1.当启动长连接时, 收到消息会回调此处
    [MiPushSDK handleReceiveRemoteNotification:data];
    //   当使用此方法后会把APNs消息导入到此
    ///[vMain printLog:[NSString stringWithFormat:@"XMPP notify: %@", data]];
    
    
    NSLog(@"收到小米推送:%@",data);

}
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
    
    if(application.applicationState == UIApplicationStateInactive)
    {
        if([[userInfo valueForKey:@"userinfo"] valueForKey:@"uid"] != nil)
        {
            ViewController *mp = [[ViewController alloc] init];
            //mp.playDoc = [userInfo valueForKey:@"userinfo"];
            [self.window.rootViewController presentViewController:mp animated:YES completion:nil];
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        }
        //[MiPushSDK handleReceiveRemoteNotification:userInfo];
    }
    
}
#endif

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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
