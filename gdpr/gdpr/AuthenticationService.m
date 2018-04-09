//
//  AuthenticationService.m
//  gdpr
//
//  Created by Kaleb Bataran on 4/9/18.
//  Copyright © 2018 localytics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthenticationService.h"

@implementation AuthenticationService : NSObject

+ (instancetype)shared {
    static AuthenticationService *shared = nil;
    @synchronized(self) {
        if (shared == nil) {
            shared = [[self alloc] init];
        }
    }
    return shared;
}

- (AuthenticationResult *)authenticateUserWithEmail:(NSString *)email andPassword:(NSString *)password {
    
    sleep(3); //mocking a server call
    
    BOOL success = YES;
    NSString *customerId = @"id123";
    BOOL optedOut = YES;
    
    AuthenticationResult *result = [AuthenticationResult resultWithSuccess:success andCustomerId:customerId andOptedOut:optedOut];
    return result;
}

@end
