//
//  KTRCookieSyncManager.m
//  CookieSync
//
//  Created by kaiinui on 2016/02/08.
//  Copyright © 2016年 kotori. All rights reserved.
//

#import "KTRCookieSyncManager.h"
@import SafariServices;
@import UIKit;

static NSString *KTRGetParamFromURL(NSString *paramKey, NSURL *URL) {
    NSArray *keyValues = [URL.query componentsSeparatedByString:@"&"];
    for (NSString *keyValue in keyValues) {
        NSArray *pair = [keyValue componentsSeparatedByString:@"="];
        if (pair.count != 2) { continue; }
        NSString *key = pair[0];
        NSString *val = pair[1];
        
        if ([paramKey isEqualToString:key]) {
            return val;
        }
    }
    
    return nil;
}

static NSString *KTRMakeRandomSecret() {
    NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
    NSMutableString *s = [NSMutableString stringWithCapacity:32];
    for (NSUInteger i = 0U; i < 32; i++) {
        u_int32_t r = arc4random() % [alphabet length];
        unichar c = [alphabet characterAtIndex:r];
        [s appendFormat:@"%C", c];
    }
    return s.copy;
}

@interface KTRCookieSyncManager ()

@property BOOL isWaitingForCookieSyncProcess;
@property NSString *secretKeyForCurrentCookieSyncProcess;

@property (strong) SFSafariViewController *safari;
@property (strong) UIViewController *parentViewController;

@end

@implementation KTRCookieSyncManager

+ (instancetype)sharedManager {
    static KTRCookieSyncManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[KTRCookieSyncManager alloc] init];
    });
    return _instance;
}

- (void)startWithURL:(NSURL *)URL withViewController:(UIViewController *)viewController {
    self.secretKeyForCurrentCookieSyncProcess = KTRMakeRandomSecret();
    
    NSURL *urlWithSecretKey = [NSURL URLWithString:[NSString stringWithFormat:@"%@#%@", URL.absoluteString, self.secretKeyForCurrentCookieSyncProcess]];
    
    self.safari = [[SFSafariViewController alloc] initWithURL:urlWithSecretKey entersReaderIfAvailable:NO];
    self.safari.modalPresentationStyle = UIModalPresentationOverFullScreen;
    // Transparent safari view allows us to complete cookie sync without showing a web view.
    self.safari.view.alpha = 0.0f;
    
    self.isWaitingForCookieSyncProcess = YES;
    self.parentViewController = viewController;
    [self.parentViewController presentViewController:self.safari animated:NO completion:NULL];
}

- (BOOL)handleOpenURL:(NSURL *)URL cookieSyncBlock:(void (^)(NSString *))cookieSyncBlock {
    // any_scheme://sync?token={token}&secret={secret}
    
    if ([URL.host isEqualToString:@"sync"] == NO) {
        return NO;
    }
    
    if (self.isWaitingForCookieSyncProcess == NO || self.secretKeyForCurrentCookieSyncProcess == nil) {
        return NO;
    }
    
    // You should dismiss SFSafariViewController since the transparent safari view blocks user interactions.
    [self.parentViewController dismissViewControllerAnimated:NO completion:NULL];
    self.parentViewController = nil;
    self.safari = nil;
    
    NSString *secret = KTRGetParamFromURL(@"secret", URL);
    if ([self.secretKeyForCurrentCookieSyncProcess isEqualToString:secret] == NO) {
        // Secret is wrong!
        return NO;
    }
    
    NSString *token = KTRGetParamFromURL(@"token", URL);
    if (cookieSyncBlock != nil) {
        cookieSyncBlock(token);
    }
    
    return YES;
}

@end
