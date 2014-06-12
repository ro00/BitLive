//
//  ROBitSource.m
//  BitLive
//
//  Created by iamro on 13-11-28.
//  Copyright (c) 2013年 iamro. All rights reserved.
//

#import "ROBitSource.h"
#import <AFNetworking/AFNetworking.h>

@implementation ROBitSource

-(id)initWithName:(NSString*)name{
    self = [super init];
    if (self) {
        self.sourceName = name;
        self.prices = [[NSMutableArray alloc] init];
    }
    return self;
}


-(void)loadPriceWithCurrency:(NSString*)c{
    
    ROBitPrice *price = [self getCurrencyPriceObject:c];
    if(!price){
        price = [[ROBitPrice alloc] initWithSourceName:self.sourceName currencyName:c];
        [self.prices addObject:price];
    }
    NSString *url = [ROBitPricesManager getAPI_UrlBySourceName:self.sourceName Currency:c];
    BOOL htmlRespone = NO;
    if([self.sourceName isEqualToString:kSourceName_BTCE]) htmlRespone = YES;
    if(url){
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        if(htmlRespone)manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(htmlRespone)responseObject =[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            price.originalData = responseObject;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //ERROR
        }];
    }
}

-(void)loadPricesWithAllCurrencies{
    for (NSString *n in kCurrencies) {
        [self loadPriceWithCurrency:n];
    }
}

-(ROBitPrice*)getCurrencyPriceObject:(NSString*)c{
    ROBitPrice *price;
    for (ROBitPrice *p in self.prices) {
        if([p.currency isEqualToString:c]){
            price = p;
        }
    }
    return price;
}
@end
