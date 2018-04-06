//
//  AppDelegate.m
//  gdpr
//
//  Created by Kaleb Bataran on 4/3/18.
//  Copyright © 2018 localytics. All rights reserved.
//

#import "AppDelegate.h"
@import Localytics;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [Localytics pauseDataUploading:YES];
    //"YOUR-LOCALYTICS-APP-KEY"
    [Localytics autoIntegrate:@"977e844f5a33e2d198849bb-091fca20-aeaf-11e3-1c46-004a77f8b47f"
        withLocalyticsOptions:@{
                                LOCALYTICS_WIFI_UPLOAD_INTERVAL_SECONDS: @5,
                                LOCALYTICS_GREAT_NETWORK_UPLOAD_INTERVAL_SECONDS: @10,
                                LOCALYTICS_DECENT_NETWORK_UPLOAD_INTERVAL_SECONDS: @30,
                                LOCALYTICS_BAD_NETWORK_UPLOAD_INTERVAL_SECONDS: @90
                                }
                launchOptions:launchOptions];
    
    return YES;
}


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
