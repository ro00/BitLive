//
//  ROBitPricesManager.h
//  BitLive
//
//  Created by iamro on 13-11-24.
//  Copyright (c) 2013年 iamro. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kPricesChangedNotification @"kPricesChangedNotification"

@interface ROBitPricesManager : NSObject<NSURLSessionDelegate,NSURLSessionTaskDelegate,NSURLSessionDownloadDelegate>{
    NSMutableArray *prices;
    NSTimer *updateTimer;
}

@property(nonatomic,strong,readonly) NSMutableArray *prices;
@property(nonatomic,strong) NSString *price;
@property(nonatomic,strong) NSString *backgroundPrice;

@property(nonatomic,strong) NSURLSession *session;
@property(nonatomic,strong) NSURLSessionDownloadTask *downloadTask;

+(ROBitPricesManager*)sharedManager;

-(void)testParse;
-(void)startDownload;

@end
