//
//  ROAlertControlCell.h
//  BitLive
//
//  Created by iamro on 13-12-7.
//  Copyright (c) 2013年 iamro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ROAlertControlCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *alertSwitch;
@property (weak, nonatomic) IBOutlet UITextField *higherThanTextField;
@property (weak, nonatomic) IBOutlet UITextField *lowerThanTextField;

@end
