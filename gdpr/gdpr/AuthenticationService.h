//
//  AuthenticationService.h
//  gdpr
//
//  Created by Kaleb Bataran on 4/9/18.
//  Copyright © 2018 localytics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthenticationResult.h"

@interface AuthenticationService : NSObject

+ (instancetype)shared;

- (AuthenticationResult *)authenticateUserWithEmail:(NSString *)email andPassword:(NSString *)password;

@end
