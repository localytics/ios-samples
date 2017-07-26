//
//  AppDelegate.m
//  RichPush
//
//  Created by Michael Riegelhaupt on 8/11/16.
//  Copyright © 2016 Localytics. All rights reserved.
//

#import "AppDelegate.h"
#import <UIKit/UIKit.h>
@import Localytics;

@implementation AppDelegate

static NSString *const LIKE_CATEGORY_IDENTIFIER = @"like";
static NSString *const SHARE_CATEGORY_IDENTIFIER = @"share";
static NSString *const BUY_CATEGORY_IDENTIFIER = @"buy";


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Localytics setLoggingEnabled:YES];
    [Localytics autoIntegrate:@"LOCALYTICS_APP_KEY" launchOptions:launchOptions];
    [self setNotificationSettingsAndRegisterRemoteNotifications];
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    
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

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    const char *data = [deviceToken bytes];
    NSMutableString *token = [NSMutableString string];
    
    for (int i = 0; i < [deviceToken length]; i++) {
        [token appendFormat:@"%02.2hhX", data[i]];
    }
    
    NSLog(@"%@", [[token copy] lowercaseString]);
}

-(void) userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    if (completionHandler) {
        completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound);
    }
}

-(void) userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    [Localytics didReceiveNotificationResponse:response.notification.request.content.userInfo andActionIdentifier: response.actionIdentifier];

    if ([LIKE_CATEGORY_IDENTIFIER isEqualToString:response.actionIdentifier]) {
        //handle behavior for like button
    } else if ([SHARE_CATEGORY_IDENTIFIER isEqualToString:response.actionIdentifier]) {
        //handle behavior for share button
    } else if ([BUY_CATEGORY_IDENTIFIER isEqualToString:response.actionIdentifier]) {
        //handle behavior for buy button
    } else if ([UNNotificationDefaultActionIdentifier isEqualToString:response.actionIdentifier]) {
        //handle open behavior
    } else if([UNNotificationDismissActionIdentifier isEqualToString:response.actionIdentifier]) {
        //handle dismiss behavior
    }
    if (completionHandler) {
        completionHandler();
    }
}

-(void) setNotificationSettingsAndRegisterRemoteNotifications {
    UNNotificationAction *like = [UNNotificationAction actionWithIdentifier:LIKE_CATEGORY_IDENTIFIER title:@"Like" options:UNNotificationActionOptionForeground];
    UNNotificationAction *share = [UNNotificationAction actionWithIdentifier:SHARE_CATEGORY_IDENTIFIER title:@"Share" options:UNNotificationActionOptionForeground];
    UNNotificationCategory *social = [UNNotificationCategory categoryWithIdentifier:@"social" actions:@[like, share] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
    
    UNNotificationAction *buy = [UNNotificationAction actionWithIdentifier:BUY_CATEGORY_IDENTIFIER title:@"Buy" options:UNNotificationActionOptionNone];
    UNNotificationCategory *product = [UNNotificationCategory categoryWithIdentifier:@"product" actions:@[buy] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
    
    NSSet *categories = [NSSet setWithArray:@[social, product]];
    NSInteger authorizationOptions = (UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge);
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authorizationOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
        [Localytics didRequestUserNotificationAuthorizationWithOptions:authorizationOptions granted:granted];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }];
    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:categories];
}

@end
