//
//  AuthenticationResult.m
//  gdpr
//
//  Created by Kaleb Bataran on 4/6/18.
//  Copyright © 2018 localytics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthenticationResult.h"

@implementation AuthenticationResult : NSObject

- (id)initWithSuccess:(BOOL)success andCustomerId:(NSString *)customerId andOptedOut:(BOOL)optedOut {
    
    self = [super init];
    if (self) {
        _success = success;
        _customerId = customerId;
        _optedOut = optedOut;
    }
    
    return self;
}

+ (instancetype)resultWithSuccess:(BOOL)success andCustomerId:(NSString *)customerId andOptedOut:(BOOL)optedOut {
    return [[[self class] alloc] initWithSuccess:success andCustomerId:customerId andOptedOut:optedOut];
}

@end

