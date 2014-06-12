//
//  ROBitPricesManager.h
//  BitLive
//
//  Created by iamro on 13-11-24.
//  Copyright (c) 2013年 iamro. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ROBitPricesManager : NSObject<NSURLSessionDelegate,NSURLSessionTaskDelegate,NSURLSessionDownloadDelegate>{
    NSTimer *updateTimer;
}

@property(nonatomic,strong,readonly) NSMutableArray *sourcesPrices;
@property(nonatomic,strong) NSString *price;
@property(nonatomic,strong) NSString *backgroundPrice;

+(ROBitPricesManager*)sharedManager;

-(void)testParse;
-(void)startDownload;

+(NSDictionary*)readPriceInfo:(NSDictionary*)original bySourceName:(NSString*)sourceName currency:(NSString*)curr;
+(NSString*)getAPI_UrlBySourceName:(NSString*)sourceName Currency:(NSString*)c;

@end
