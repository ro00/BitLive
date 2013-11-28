//
//  ROAppDelegate.m
//  BitLive
//
//  Created by iamro on 13-11-24.
//  Copyright (c) 2013年 iamro. All rights reserved.
//

#import "ROAppDelegate.h"
#import "ROBitPricesManager.h"

@implementation ROAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [ROBitPricesManager sharedManager];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[[ROBitPricesManager sharedManager].price intValue]];
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:60];
    //self.backgroundTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:[ROBitPricesManager sharedManager] selector:@selector(startDownload) userInfo:nil repeats:YES];
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;
    if(self.backgroundTimer){
        [self.backgroundTimer invalidate];
        self.backgroundTimer = nil;
    }
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    self.backgroundTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:[ROBitPricesManager sharedManager] selector:@selector(startDownload) userInfo:nil repeats:YES];
    [[ROBitPricesManager sharedManager] startDownload];
    self.backgroundSessionCompletionHandler = completionHandler;
    //completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier
  completionHandler:(void (^)())completionHandler {
    //self.backgroundSessionCompletionHandler = completionHandler;
    //add notification
}

-(void)presentNotification{
//    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    int price = [[ROBitPricesManager sharedManager].backgroundPrice intValue];
      [[UIApplication sharedApplication] setApplicationIconBadgeNumber:price];
//    localNotification.alertBody = [NSString stringWithFormat:@"Price now is %@",[ROBitPricesManager sharedManager].backgroundPrice];
//    localNotification.alertAction = @"Background Transfer Download!";
//    //On sound
//    localNotification.soundName = UILocalNotificationDefaultSoundName;
//    //increase the badge number of application plus 1
//    localNotification.applicationIconBadgeNumber = price;
//    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}

@end
