//
//  NotificationService.m
//  RichPushExtension
//
//  Created by Michael Riegelhaupt on 8/11/16.
//  Copyright © 2016 Localytics. All rights reserved.
//

#import "NotificationService.h"

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    // Modify the notification content here...
    NSString *imageURL = self.bestAttemptContent.userInfo[@"attachment-image"];
    if (imageURL) {
        NSURL *url = [NSURL URLWithString:imageURL];
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            NSURL *groupStorageURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.localytics.richPush"];
            NSURL *dataFileUrl = [groupStorageURL URLByAppendingPathComponent:@"attachment-image.jpg"];
            [data writeToURL:dataFileUrl atomically:YES];
            UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"rich-push-identifier" URL:dataFileUrl options:nil error:nil];
            if (attachment) {
                self.bestAttemptContent.attachments = @[attachment];
            }
            self.contentHandler(self.bestAttemptContent);
        }];
        [task resume];
    } else {
        self.contentHandler(self.bestAttemptContent);
    }
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
