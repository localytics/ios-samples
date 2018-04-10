//
//  HomeVC.m
//  gdpr
//
//  Created by Kaleb Bataran on 4/10/18.
//  Copyright © 2018 localytics. All rights reserved.
//

#import "HomeVC.h"

@import Localytics;

@interface HomeVC ()

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)optInTapped:(id)sender {
    [Localytics setPrivacyOptedOut:NO];
    // TODO Make a call to your servers to update the status of data collection opt out for this user.
}

- (IBAction)optOutTapped:(id)sender {
    [Localytics setPrivacyOptedOut:YES];
    // TODO Make a call to your servers to update the status of data collection opt out for this user.
}

- (IBAction)signOutTapped:(id)sender {
    [Localytics setCustomerId:nil privacyOptedOut:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
