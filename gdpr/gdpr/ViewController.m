//
//  ViewController.m
//  gdpr
//
//  Created by Kaleb Bataran on 4/3/18.
//  Copyright © 2018 localytics. All rights reserved.
//

#import "ViewController.h"

@import Localytics;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)signInTapped:(id)sender {
    
    NSString *email = [_emailFld text];
    NSString *password = [_passwordFld text];
    if (email != nil && password != nil) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            sleep(2);
            AuthenticationResult *result = [self authenticateUserWithEmail:email andPassword:password];
            if ([result success]) {
                
                BOOL optedOut = [result optedOut];
                [Localytics setCustomerId:[result customerId] privacyOptedOut:optedOut];
                [Localytics pauseDataUploading:false];
                [Localytics setLocationMonitoringEnabled:!optedOut];
            } else {
                //authentication failed
            }
        });
    }
}

//TODO: turn this into a service/task
- (AuthenticationResult *)authenticateUserWithEmail:(NSString *)email andPassword:(NSString *)password {
    
    BOOL success = YES;
    NSString *customerId = @"id123";
    BOOL optedOut = YES;
    AuthenticationResult *result = [AuthenticationResult resultWithSuccess:success andCustomerId:customerId andOptedOut:optedOut];
    return result;
}

@end
