//
//  ROAlertControlCell.m
//  BitLive
//
//  Created by iamro on 13-12-7.
//  Copyright (c) 2013年 iamro. All rights reserved.
//

#import "ROAlertControlCell.h"

@implementation ROAlertControlCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (IBAction)switchAlert:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:self.alertSwitch.on forKey:kSettingsAlertHighLowOn];
}
- (IBAction)higherThanEndEditing:(id)sender {
    [[NSUserDefaults standardUserDefaults] setInteger:[self.higherThanTextField.text intValue] forKey:kSettingsHigherThanPrice];
}
- (IBAction)lowerThanEndEditing:(id)sender {
    [[NSUserDefaults standardUserDefaults] setInteger:[self.lowerThanTextField.text intValue] forKey:kSettingsLowerThanPrice];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
