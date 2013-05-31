//
//  PKAppDelegate.m
//  PDUKeeper
//
//  Created by James Abendroth on 3/5/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import "PKAppDelegate.h"
#import "PKGraphViewController.h"
#import "PKPDUTableViewController.h"
#import "PKPDUNavViewController.h"
#import "PKSettingsTableViewController.h"
#import "PKSettingsNavViewController.h"
#import "PKTabBarViewController.h"

@implementation PKAppDelegate

-(id)init
{
    self = [super init];
    if (self){
        hasFocus = NO;
    }
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    PKTabBarViewController *tbc = [[PKTabBarViewController alloc] init];
    
    // Set up each view controller.
    PKGraphViewController *vc_graph = [[PKGraphViewController alloc] init];
    
    PKPDUTableViewController *tvc_pdus = [[PKPDUTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    PKPDUNavViewController *nvc_pdus = [[PKPDUNavViewController alloc] initWithRootViewController:tvc_pdus];
    [[nvc_pdus navigationBar] setBarStyle:UIBarStyleBlack];

    PKSettingsTableViewController *tvc_settings = [[PKSettingsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    PKSettingsNavViewController *nvc_settings = [[PKSettingsNavViewController alloc] initWithRootViewController:tvc_settings];
    [[nvc_settings navigationBar] setBarStyle:UIBarStyleBlack];
    
    [tbc setViewControllers:[NSArray arrayWithObjects:vc_graph, nvc_pdus, nvc_settings, nil]];
    
    [[self window] setRootViewController:tbc];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
    
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    PKTabBarViewController *tbc;
    
    // Select the graph tab.
    if (!hasFocus){
        tbc = (PKTabBarViewController*)[[self window] rootViewController];
        [tbc setSelectedIndex:0];
    }

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    hasFocus = NO;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    hasFocus = YES;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    //[self saveContext];
}

@end
