//
//  ROBitLiveViewController.h
//  BitLive
//
//  Created by iamro on 13-11-24.
//  Copyright (c) 2013年 iamro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ROBitLiveViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    UITextField *latestResponder;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
