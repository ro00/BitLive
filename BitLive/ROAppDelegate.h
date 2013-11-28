//
//  ROAppDelegate.h
//  BitLive
//
//  Created by iamro on 13-11-24.
//  Copyright (c) 2013年 iamro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ROAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (copy) void (^backgroundSessionCompletionHandler)();
@property(strong , nonatomic) NSTimer *backgroundTimer;

@end
