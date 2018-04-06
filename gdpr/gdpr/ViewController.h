//
//  ViewController.h
//  gdpr
//
//  Created by Kaleb Bataran on 4/3/18.
//  Copyright © 2018 localytics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthenticationResult.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *emailFld;
@property (weak, nonatomic) IBOutlet UITextField *passwordFld;

- (AuthenticationResult *)authenticateUserWithEmail:(NSString *)email andPassword:(NSString *)password;

@end

