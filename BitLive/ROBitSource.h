//
//  ROBitSource.h
//  BitLive
//
//  Created by iamro on 13-11-28.
//  Copyright (c) 2013年 iamro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ROBitPrice.h"

@interface ROBitSource : NSObject

@property(nonatomic,strong) NSString *sourceName;
@property(nonatomic,strong) NSMutableArray *prices;

-(id)initWithName:(NSString*)name;

-(void)loadPricesWithAllCurrencies;
-(void)loadPriceWithCurrency:(NSString*)c;
-(ROBitPrice*)getCurrencyPriceObject:(NSString*)c;

@end
