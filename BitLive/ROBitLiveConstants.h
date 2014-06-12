//
//  ROBitLiveConstants.h
//  BitLive
//
//  Created by iamro on 13-11-28.
//  Copyright (c) 2013年 iamro. All rights reserved.
//

#ifndef BitLive_ROBitLiveConstants_h
#define BitLive_ROBitLiveConstants_h

#define kPricesChangedNotification @"kPricesChangedNotification"
#define kNotification_PriceLoaded @"kNotification_PriceLoaded"

#define kCurrencies @[@"USD",@"EUR",@"JPY",@"CAD",@"GBP",@"CHF",@"RUB",@"AUD",@"SEK",@"DKK",@"HKD",@"PLN",@"CNY",@"SGD",@"THB",@"NZD",@"NOK"]

#define kAPI_MtGox @"http://data.mtgox.com/api/1/BTC%@/ticker"
#define kAPI_BITSTAMP @"https://www.bitstamp.net/api/ticker/"
#define kAPI_BTCE @"https://btc-e.com/api/2/btc_usd/ticker/"
#define kAPI_BLOCKCHAIN @"https://blockchain.info/zh-cn/ticker"
#define kAPI_BTCCHINA @"https://data.btcchina.com/data/ticker"

#define kSourceName_MTGOX @"MTGOX"
#define kSourceName_BITSTAMP @"BITSTAMP"
#define kSourceName_BTCE @"BTCE"
#define kSourceName_BLOCKCHAIN @"BLOCKCHAIN"
#define kSourceName_BTCCHINA @"BTCCHINA"

#define kDefaultAlertMarket @"BTCCHINA"
#define kDefaultAlertCurrency @"CNY"

#define kSettingsAlertHighLowOn @"kSettingsAlertHighLowOn"
#define kSettingsHigherThanPrice @"kSettingsHigherThanPrice"
#define kSettingsLowerThanPrice @"kSettingsLowerThanPrice"

#define kSources @{kSourceName_MTGOX:kAPI_MtGox,kSourceName_BITSTAMP:kAPI_BITSTAMP,kSourceName_BTCE:kAPI_BTCE,kSourceName_BLOCKCHAIN:kAPI_BLOCKCHAIN,kSourceName_BTCCHINA:kAPI_BTCCHINA}

#define kFormatCurrencyToSymbol @{@"USD":@"$",@"CNY":@"¥"}

#endif
