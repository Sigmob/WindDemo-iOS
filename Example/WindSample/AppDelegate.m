//
//  AppDelegate.m
//  WindmillSample
//
//  Created by Codi on 2021/12/6.
//

#import "AppDelegate.h"
#import <WindSDK/WindSDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self initLogService];
    [self initTableApparance];
    
    WindAdOptions *option = [[WindAdOptions alloc] initWithAppId:AppId appKey:AppKey];
    [WindAds startWithOptions:option];
    
    return YES;
}

- (void)initLogService {
    [DDLog addLogger:[DDTTYLogger sharedInstance] withLevel:DDLogLevelVerbose]; // TTY = Xcode console
    [DDLog addLogger:[DDASLLogger sharedInstance] withLevel:DDLogLevelVerbose]; // ASL = Apple System Logs
}

- (void)initTableApparance {
    [[UITableView appearance] setTableFooterView:[UIView new]];
    [[UITableView appearance] setSeparatorInset:UIEdgeInsetsZero];
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options  API_AVAILABLE(ios(13.0)){
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions API_AVAILABLE(ios(13.0)){
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
