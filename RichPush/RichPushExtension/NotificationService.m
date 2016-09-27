//
//  NotificationService.m
//  RichPushExtension
//
//  Created by Michael Riegelhaupt on 8/11/16.
//  Copyright © 2016 Localytics. All rights reserved.
//

#import "NotificationService.h"

static NSString *const ATTACHMENT_IMAGE_KEY = @"ll_attachment_url";
static NSString *const ATTACHMENT_TYPE_KEY = @"ll_attachment_type";
static NSString *const ATTACHMENT_FILE_NAME = @"-attachment-image.";

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    NSString *imageURL = self.bestAttemptContent.userInfo[ATTACHMENT_IMAGE_KEY];
    NSString *imageType = self.bestAttemptContent.userInfo[ATTACHMENT_TYPE_KEY];
    if (!imageURL || !imageType) {
        self.contentHandler(self.bestAttemptContent);
        return;
    }
    NSURL *url = [NSURL URLWithString:imageURL];
    [[[NSURLSession sharedSession] downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable tempFile, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Failed to retrieve attachment with error: %@", [error localizedDescription]);
            self.contentHandler(self.bestAttemptContent);
            return;
        }
        if (!tempFile) {
            NSLog(@"No temporary file exists with downloaded content");
            self.contentHandler(self.bestAttemptContent);
            return;
        }
        NSArray *cache = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachesFolder = cache[0];
            
        NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString];
        NSString *fileName = [[guid stringByAppendingString:ATTACHMENT_FILE_NAME] stringByAppendingString:imageType];
        NSString *cacheFile = [cachesFolder stringByAppendingPathComponent:fileName];
        NSURL *attachmentURL = [NSURL fileURLWithPath:cacheFile isDirectory:NO];
        NSError *err = nil;
        [[NSFileManager defaultManager] moveItemAtURL:tempFile toURL:attachmentURL error:&err];
        if (err) {
            NSLog(@"Failed to save attachment on disk with error: %@", [err localizedDescription]);
            self.contentHandler(self.bestAttemptContent);
            return;
        }
        
        UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"" URL:attachmentURL options:nil error:&err];
        if (attachment) {
            self.bestAttemptContent.attachments = @[attachment];
        } else {
            NSLog(@"Failed to create attachment with error: %@", [err localizedDescription]);
        }
        self.contentHandler(self.bestAttemptContent);
        
    }] resume];
}

- (void)serviceExtensionTimeWillExpire {
    self.contentHandler(self.bestAttemptContent);
}

@end
