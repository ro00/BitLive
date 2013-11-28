//
//  ROBitPrice.h
//  BitLive
//
//  Created by iamro on 13-11-28.
//  Copyright (c) 2013年 iamro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ROBitPrice : NSObject

@property(nonatomic,assign) float price;
@property(nonatomic,strong) NSString *currencySymbol;
@property(nonatomic,strong) NSString *currency;

@end
