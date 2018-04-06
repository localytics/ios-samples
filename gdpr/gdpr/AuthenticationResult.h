//
//  AuthenticationResult.h
//  gdpr
//
//  Created by Kaleb Bataran on 4/6/18.
//  Copyright © 2018 localytics. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthenticationResult : NSObject

@property (readonly) BOOL success;
@property (nullable, readonly) NSString *customerId;
@property (readonly) BOOL optedOut;

- (id)initWithSuccess:(BOOL)success andCustomerId:(NSString *)customerId andOptedOut:(BOOL)optedOut;

+ (instancetype)resultWithSuccess:(BOOL)success andCustomerId:(NSString *)customerId andOptedOut:(BOOL)optedOut;

@end
