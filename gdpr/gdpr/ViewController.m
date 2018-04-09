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
            AuthenticationResult *result = [[AuthenticationService shared] authenticateUserWithEmail:email andPassword:password];
            if ([result success]) {
                
                BOOL optedOut = [result optedOut];
                [Localytics setCustomerId:[result customerId] privacyOptedOut:optedOut];
                
                //you've set the opted out flag to the proper value, you can now safely turn on uploads
                [Localytics pauseDataUploading:false];
                
                //ensure you're not sending Places notifications to users who have opted out of tracking
                [Localytics setLocationMonitoringEnabled:!optedOut];
            } else {
                //authentication failed
            }
        });
    }
}

@end
