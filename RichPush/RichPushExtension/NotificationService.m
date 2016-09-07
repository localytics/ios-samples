//
//  NotificationService.m
//  RichPushExtension
//
//  Created by Michael Riegelhaupt on 8/11/16.
//  Copyright © 2016 Localytics. All rights reserved.
//

#import "NotificationService.h"

static NSString *const ATTACHMENT_IMAGE_KEY = @"image_url";
static NSString *const ATTACHMENT_TYPE_KEY = @"image_type";
static NSString *const ATTACHMENT_FILE_NAME = @"attachment-image.";

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    // Modify the notification content here...
    NSString *imageURL = self.bestAttemptContent.userInfo[ATTACHMENT_IMAGE_KEY];
    NSString *imageType = self.bestAttemptContent.userInfo[ATTACHMENT_TYPE_KEY];
    if (!imageURL || !imageType) {
        self.contentHandler(self.bestAttemptContent);
        return;
    }
    NSURL *url = [NSURL URLWithString:imageURL];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Error fetching attachment, displaying content unaltered: %@", [error localizedDescription]);
            self.contentHandler(self.bestAttemptContent);
            return;
        }
        
        NSArray *cache = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachesFolder = cache[0];
        
        NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString];
        NSString *fileName = [[guid stringByAppendingString:ATTACHMENT_FILE_NAME] stringByAppendingString:imageType];
        NSString *cacheFile = [cachesFolder stringByAppendingPathComponent:fileName];
        
        NSError *err = nil;
        if (![data writeToFile:cacheFile options:NSDataWritingAtomic error:&err]) {
            NSLog(@"Failed to save attachment on disk with error: %@", [err localizedDescription]);
            self.contentHandler(self.bestAttemptContent);
            return;
        }
        
        NSURL *attachmentURL = [NSURL fileURLWithPath:cacheFile isDirectory:NO];
        UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"" URL:attachmentURL options:nil error:&err];
        if (attachment) {
            self.bestAttemptContent.attachments = @[attachment];
        } else {
            NSLog(@"Failed to create attachment with error: %@", [err localizedDescription]);
        }
        self.contentHandler(self.bestAttemptContent);
    }];
    [task resume];
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
