//
//  ROBitPricesManager.m
//  BitLive
//
//  Created by iamro on 13-11-24.
//  Copyright (c) 2013年 iamro. All rights reserved.
//

#import "ROBitPricesManager.h"
#import <AFNetworking/AFNetworking.h>
#import "ROAppDelegate.h"

#define kPrice_API_Urls @[]

@implementation ROBitPricesManager

@synthesize prices = _prices;

static ROBitPricesManager *sharedSingleton;

+(ROBitPricesManager*)sharedManager{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        sharedSingleton = [[ROBitPricesManager alloc] init];
        
    }
    return sharedSingleton;
}

-(id)init{
    self = [super init];
    if(self){
        _prices = [[NSMutableArray alloc] init];
        updateTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(testParse) userInfo:nil repeats:YES];
        self.session = [self backgroundSession];
    }
    return self;
}

#pragma internet handlers

-(NSURLSession*)backgroundSession{
    static NSURLSession *session = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfiguration:@"ro.entertainment-BitLive.BackgroundSession"];
    configuration.sessionSendsLaunchEvents = YES;
        session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
//    });
    return session;
}

-(void)startDownload{
    if([[UIApplication sharedApplication] backgroundTimeRemaining]<3){
        ROAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [[appDelegate backgroundTimer] invalidate];
        //[appDelegate backgroundTimer] = nil;
    }
    NSLog(@"remaining time %d",[[UIApplication sharedApplication] backgroundTimeRemaining]);
//    NSURL *url = [NSURL URLWithString:@"http://data.mtgox.com/api/1/BTCUSD/ticker"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    self.downloadTask = [self.session downloadTaskWithRequest:request];
//    [self.downloadTask resume];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://data.mtgox.com/api/1/BTCUSD/ticker" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSError *error;
        //NSDictionary *dict = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:&error];
        NSString *s = responseObject[@"return"][@"last"][@"value"];
        self.backgroundPrice = s;
        NSLog(@"Price:%@", responseObject[@"return"][@"last"][@"value"]);
        
        int price = [[ROBitPricesManager sharedManager].backgroundPrice intValue];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:price];
        
        ROAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        appDelegate.backgroundSessionCompletionHandler(UIBackgroundFetchResultNewData);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        ROAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        appDelegate.backgroundSessionCompletionHandler(UIBackgroundFetchResultFailed);
    }];
}

-(void)testParse{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://data.mtgox.com/api/1/BTCUSD/ticker" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSError *error;
        //NSDictionary *dict = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:&error];
        NSString *s = responseObject[@"return"][@"last"][@"value"];
        self.price = s;
        NSLog(@"Price:%@", responseObject[@"return"][@"last"][@"value"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:kPricesChangedNotification object:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma delegates

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    if (downloadTask==self.downloadTask) {
        double progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        NSLog(@"DownloadTask: %@ progress: %lf", downloadTask, progress);
    }
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSArray *URLs = [fileManager URLsForDirectory:NSDocumentationDirectory inDomains:NSUserDomainMask];
//    NSURL *documentDirectory = URLs[0];
//    NSURL *originalURL = [[downloadTask originalRequest] URL];
//    NSURL *destinationURL = [documentDirectory URLByAppendingPathComponent:[originalURL lastPathComponent]];
//    NSError *errorCopy;
//    [fileManager removeItemAtURL:destinationURL error:NULL];
//    BOOL success = [fileManager copyItemAtURL:location toURL:destinationURL error:&errorCopy];
    NSData *databyte = [NSData dataWithContentsOfURL:location];
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:databyte options:0 error:NULL];
    NSString *s = data[@"return"][@"last"][@"value"];
    self.backgroundPrice = s;
    int price = [[ROBitPricesManager sharedManager].backgroundPrice intValue];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:price];
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes{
    
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    if (error == nil) {
        NSLog(@"Task: %@ completed successfully", task);
    } else {
        NSLog(@"Task: %@ completed with error: %@", task, [error localizedDescription]);
    }
    ROAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.downloadTask = nil;
    appDelegate.backgroundSessionCompletionHandler(UIBackgroundFetchResultNewData);
}

-(void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session{
    ROAppDelegate *appDelegate =[[UIApplication sharedApplication] delegate];
    if (appDelegate.backgroundSessionCompletionHandler) {
        void (^completionHandler)() = appDelegate.backgroundSessionCompletionHandler;
        appDelegate.backgroundSessionCompletionHandler = nil;
        completionHandler();
    }
}



@end
