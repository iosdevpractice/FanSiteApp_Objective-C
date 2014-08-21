//
//  AppDelegate.m
//  SiteFan
//
//  Created by Wiley Wimberly on 8/18/14.
//  Copyright (c) 2014 Warm Fuzzy Apps, LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "FeedViewController.h"
#import "TweetsViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
            

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    FeedViewController *feedViewController = [[FeedViewController alloc] init];
    UINavigationController *feedNavigationController = [[UINavigationController alloc] initWithRootViewController:feedViewController];
    feedNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Feed" image:[UIImage imageNamed:@"RSS"] tag:0];
    
    TweetsViewController *tweetsViewController = [[TweetsViewController alloc] init];
    UINavigationController *tweetsNavigationController = [[UINavigationController alloc] initWithRootViewController:tweetsViewController];
    tweetsNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Tweets" image:[UIImage imageNamed:@"Twitter"] tag:1];
    
    tabBarController.viewControllers = @[feedNavigationController, tweetsNavigationController];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = tabBarController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
