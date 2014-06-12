//
//  ROBitPrice.m
//  BitLive
//
//  Created by iamro on 13-11-28.
//  Copyright (c) 2013年 iamro. All rights reserved.
//

#import "ROBitPrice.h"

@implementation ROBitPrice

@synthesize originalData=_originalData;


-(id)initWithSourceName:(NSString*)name currencyName:(NSString*)currencyName{
    self = [super init];
    if (self) {
        self.sourceName = name;
        self.currency = currencyName;
    }
    return self;
}

-(void)loadInfos{
    self.previousPrice=self.latestPrice;
    
    NSDictionary *dict = [ROBitPricesManager readPriceInfo:self.originalData bySourceName:self.sourceName currency:self.currency];
    if([self.sourceName isEqualToString:kDefaultAlertMarket]&&[self.currency isEqualToString:kDefaultAlertCurrency]){
        [ROBitPricesManager sharedManager].price = dict[@"latestPrice"];
    }
    
    self.latestPrice = dict[@"latestPrice"];
    self.highPrice = dict[@"highPrice"];
    self.lowPrice = dict[@"lowPrice"];
    self.bidPrice = dict[@"bidPrice"];
    self.askPrice = dict[@"askPrice"];
    
    self.updateTime = [NSDate date];
    if(self.latestPrice>0)[[NSNotificationCenter defaultCenter] postNotificationName:kNotification_PriceLoaded object:nil];
}

-(void)setOriginalData:(NSDictionary *)originalData{
    _originalData = originalData;
    [self loadInfos];
}

@end