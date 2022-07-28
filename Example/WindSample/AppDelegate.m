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
    [self setNavigationBackItem];
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

- (void)setNavigationBackItem {
    [[UINavigationBar appearance] setTranslucent:NO];
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *app = [[UINavigationBarAppearance alloc] init];
        [app configureWithOpaqueBackground];
        app.backgroundColor = [UIColor colorWithRed:242/255.0 green:105/255.0 blue:11/255.0 alpha:1];
        app.titleTextAttributes = @{
            NSForegroundColorAttributeName: UIColor.whiteColor
        };
        [[UINavigationBar appearance] setScrollEdgeAppearance:app];
        [[UINavigationBar appearance] setStandardAppearance:app];
    }else {
        //设置导航栏左右按钮的着色
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        //设置导航栏背景颜色
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:242/255.0 green:105/255.0 blue:11/255.0 alpha:1]];
        //左右item的颜色】
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        //title
        [[UINavigationBar appearance] setTitleTextAttributes:@{
            NSForegroundColorAttributeName: UIColor.whiteColor
        }];
    }
}
@end
