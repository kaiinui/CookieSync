//
//  KTRCookieSyncManager.h
//  CookieSync
//
//  Created by kaiinui on 2016/02/08.
//  Copyright © 2016年 kotori. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KTRCookieSyncManager : NSObject

+ (instancetype)sharedManager;

- (void)startWithURL:(NSURL *)URL withViewController:(UIViewController *)viewController;
- (BOOL)handleOpenURL:(NSURL *)URL cookieSyncBlock:(void(^)(NSString *token))cookieSyncBlock;

@end
