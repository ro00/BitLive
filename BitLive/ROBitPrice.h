//
//  ROBitPrice.h
//  BitLive
//
//  Created by iamro on 13-11-28.
//  Copyright (c) 2013年 iamro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ROBitPrice : NSObject

@property(nonatomic,strong) NSString* highPrice;
@property(nonatomic,strong) NSString* lowPrice;
@property(nonatomic,strong) NSString* latestPrice;
@property(nonatomic,strong) NSString* bidPrice;
@property(nonatomic,strong) NSString* askPrice;
@property(nonatomic,strong) NSString* previousPrice;

@property(nonatomic,strong) NSDictionary *originalData;
@property(nonatomic,strong) NSString *sourceName;
@property(nonatomic,strong) NSString *currencySymbol;
@property(nonatomic,strong) NSString *currency;
@property(nonatomic,strong) NSDate *updateTime;

@property(nonatomic,assign) BOOL calculatePriceByExchangeRate;
@property(nonatomic,strong) NSString *baseCurrency;

-(id)initWithSourceName:(NSString*)name currencyName:(NSString*)currencyName;

@end
