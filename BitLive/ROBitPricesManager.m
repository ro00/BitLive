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
#import "ROBitPrice.h"
#import "ROBitSource.h"

#define kPrice_API_Urls @[]

@implementation ROBitPricesManager

@synthesize sourcesPrices = _sourcesPrices;

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
        _sourcesPrices = [[NSMutableArray alloc] init];
        updateTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(fetchPrices) userInfo:nil repeats:YES];
        
        //init sources
        //MT.GOX
        ROBitSource *source = [[ROBitSource alloc] initWithName:kSourceName_MTGOX];
        [_sourcesPrices addObject:source];
        ROBitSource *source2 = [[ROBitSource alloc] initWithName:kSourceName_BITSTAMP];
        [_sourcesPrices addObject:source2];
        ROBitSource *source3 = [[ROBitSource alloc] initWithName:kSourceName_BTCE];
        [_sourcesPrices addObject:source3];
        ROBitSource *source4 = [[ROBitSource alloc] initWithName:kSourceName_BLOCKCHAIN];
        [_sourcesPrices addObject:source4];
        ROBitSource *source5 = [[ROBitSource alloc] initWithName:kSourceName_BTCCHINA];
        [_sourcesPrices addObject:source5];
    }
    return self;
}

-(ROBitSource*)sourceByName:(NSString*)n{
    ROBitSource *source;
    for (ROBitSource *s in self.sourcesPrices) {
        if([s.sourceName isEqualToString:n]){
            source = s;
        }
    }
    return source;
}

//array 1 [@""]

#pragma internet handlers

-(void)fetchPrices{
    [[self sourceByName:kSourceName_MTGOX] loadPriceWithCurrency:@"USD"];
    [[self sourceByName:kSourceName_MTGOX] loadPriceWithCurrency:@"CNY"];
    [[self sourceByName:kSourceName_BITSTAMP] loadPriceWithCurrency:@"USD"];
    [[self sourceByName:kSourceName_BTCE] loadPriceWithCurrency:@"USD"];
    [[self sourceByName:kSourceName_BLOCKCHAIN] loadPriceWithCurrency:@"USD"];
    [[self sourceByName:kSourceName_BTCCHINA] loadPriceWithCurrency:@"CNY"];
}


-(void)startDownload{
    if([[UIApplication sharedApplication] backgroundTimeRemaining]<3){
        ROAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [[appDelegate backgroundTimer] invalidate];
        //[appDelegate backgroundTimer] = nil;
    }
    NSString *sourceName = kSourceName_BTCCHINA;
    NSString *currency = @"CNY";
    
    NSString *url = [ROBitPricesManager getAPI_UrlBySourceName:sourceName Currency:currency];
    BOOL htmlRespone = NO;
    if([sourceName isEqualToString:kSourceName_BTCE]) htmlRespone = YES;
    if(url){
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        if(htmlRespone)manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(htmlRespone)responseObject =[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            NSDictionary *infos = [ROBitPricesManager readPriceInfo:responseObject bySourceName:sourceName currency:currency];
            
            self.backgroundPrice = infos[@"latestPrice"];
            
            int price = [[ROBitPricesManager sharedManager].backgroundPrice intValue];
            if (price>[[NSUserDefaults standardUserDefaults] integerForKey:kSettingsHigherThanPrice]) {
                [ROBitPricesManager alertWithMessage:[NSString stringWithFormat:@"Price is now:%d.Higher than:%ld",price,(long)[[NSUserDefaults standardUserDefaults] integerForKey:kSettingsHigherThanPrice]]];
            }else if (price<[[NSUserDefaults standardUserDefaults] integerForKey:kSettingsLowerThanPrice]) {
                [ROBitPricesManager alertWithMessage:[NSString stringWithFormat:@"Price is now:%d.Lower than:%ld",price,(long)[[NSUserDefaults standardUserDefaults] integerForKey:kSettingsLowerThanPrice]]];
            }
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:price];
            
            ROAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
            appDelegate.backgroundSessionCompletionHandler(UIBackgroundFetchResultNewData);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //ERROR
            ROAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
            appDelegate.backgroundSessionCompletionHandler(UIBackgroundFetchResultFailed);
        }];
    }
}



#pragma helpers

+(void)alertWithMessage:(NSString*)m{
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = m;
    localNotification.alertAction = m;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}

+(NSString*)getAPI_UrlBySourceName:(NSString*)sourceName Currency:(NSString*)c{
    NSString *n;
    if([sourceName isEqualToString:kSourceName_MTGOX]){
        n =[NSString stringWithFormat:kAPI_MtGox,c];
    }else if([sourceName isEqualToString:kSourceName_BITSTAMP]){
        if([c isEqualToString:@"USD"]){
            n = kAPI_BITSTAMP;
        }
    }else if([sourceName isEqualToString:kSourceName_BTCE]){
        if([c isEqualToString:@"USD"]){
            n = kAPI_BTCE;
        }
    }else if([sourceName isEqualToString:kSourceName_BLOCKCHAIN]){
        n = kAPI_BLOCKCHAIN;
    }else if([sourceName isEqualToString:kSourceName_BTCCHINA]){
        if([c isEqualToString:@"CNY"]){
            n = kAPI_BTCCHINA;
        }
    }
    return n;
}

+(NSDictionary*)readPriceInfo:(NSDictionary*)original bySourceName:(NSString*)sourceName currency:(NSString*)curr{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if(!original)return nil;
    if([sourceName isEqualToString:kSourceName_MTGOX]){
        dict[@"latestPrice"] = original[@"return"][@"last"][@"value"];
        dict[@"highPrice"] = original[@"return"][@"high"][@"value"];
        dict[@"lowPrice"] = original[@"return"][@"low"][@"value"];
        dict[@"bidPrice"] = original[@"return"][@"buy"][@"value"];
        dict[@"askPrice"] = original[@"return"][@"sell"][@"value"];
    }else if([sourceName isEqualToString:kSourceName_BITSTAMP]){
        dict[@"latestPrice"] = original[@"last"] ;
        dict[@"highPrice"] = original[@"high"];
        dict[@"lowPrice"] = original[@"low"];
        dict[@"bidPrice"] = original[@"bid"];
        dict[@"askPrice"] = original[@"ask"];
    }else if([sourceName isEqualToString:kSourceName_BTCE]){
        dict[@"latestPrice"] = original[@"ticker"][@"last"];
        dict[@"highPrice"] = original[@"ticker"][@"high"];
        dict[@"lowPrice"] = original[@"ticker"][@"low"];
        dict[@"bidPrice"] = original[@"ticker"][@"buy"];
        dict[@"askPrice"] = original[@"ticker"][@"sell"];
    }else if([sourceName isEqualToString:kSourceName_BLOCKCHAIN]){
        dict[@"latestPrice"] = original[curr][@"last"];
        dict[@"bidPrice"] = original[curr][@"buy"];
        dict[@"askPrice"] = original[curr][@"sell"];
    }else if([sourceName isEqualToString:kSourceName_BTCCHINA]){
        dict[@"latestPrice"] = original[@"ticker"][@"last"];
        dict[@"highPrice"] = original[@"ticker"][@"high"];
        dict[@"lowPrice"] = original[@"ticker"][@"low"];
        dict[@"bidPrice"] = original[@"ticker"][@"buy"];
        dict[@"askPrice"] = original[@"ticker"][@"sell"];
    }
    return dict;
}


@end
