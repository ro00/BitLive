//
//  ROBitLiveViewController.m
//  BitLive
//
//  Created by iamro on 13-11-24.
//  Copyright (c) 2013年 iamro. All rights reserved.
//

#import "ROBitLiveViewController.h"
#import "ROBitPricesManager.h"
#import "ROBitPrice.h"
#import "ROBitSource.h"
#import "ROBitTablePriceCell.h"
#import "ROAlertControlCell.h"

@interface ROBitLiveViewController ()

@end

@implementation ROBitLiveViewController

#pragma interface stuff

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.tabBarController.tabBar.translucent = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAll) name:kNotification_PriceLoaded object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardUp:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDown:) name:UIKeyboardWillHideNotification object:nil];
    
    self.navigationController.navigationBarHidden = YES;
    //[self.tabBarController.tabBar setHidden:YES];
    
    //[[ROBitPricesManager sharedManager] testParse];
    //self.edgesForExtendedLayout = UIRectEdgeAll;
    //self.tableView.contentInset = UIEdgeInsetsMake(0., 0., 45, 0);
    //self.tableView.frame = CGRectMake(self.tableView.bounds.origin.x, self.tableView.bounds.origin.y, self.tableView.bounds.size.width, self.tableView.bounds.size.height-45);
    
}

-(void)updateAll{
    //[[self tableView] reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [[ROBitPricesManager sharedManager].sourcesPrices count]-1) ] withRowAnimation:UITableViewRowAnimationNone];
    [[self tableView] reloadData];
}

#pragma table view
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    int i = [[ROBitPricesManager sharedManager].sourcesPrices count];
    return i+1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == [ROBitPricesManager sharedManager].sourcesPrices.count) return @"SETTINGS";
    ROBitSource *source = [ROBitPricesManager sharedManager].sourcesPrices[section];
    return @"";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == [ROBitPricesManager sharedManager].sourcesPrices.count) return 1;
    ROBitSource *source = [ROBitPricesManager sharedManager].sourcesPrices[section];
    return source.prices.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *mCell;
    if(indexPath.section == [ROBitPricesManager sharedManager].sourcesPrices.count){
        ROAlertControlCell *cell = [tableView dequeueReusableCellWithIdentifier:@"alert_cell" forIndexPath:indexPath];
        BOOL on = [[NSUserDefaults standardUserDefaults] boolForKey:kSettingsAlertHighLowOn];
        if(on)[cell.alertSwitch setOn:YES];
        else [cell.alertSwitch setOn:NO];
        cell.higherThanTextField.text=[NSString stringWithFormat:@"%d",[[NSUserDefaults standardUserDefaults] integerForKey:kSettingsHigherThanPrice]];
        cell.lowerThanTextField.text=[NSString stringWithFormat:@"%d",[[NSUserDefaults standardUserDefaults] integerForKey:kSettingsLowerThanPrice]];
        mCell = cell;
    }else{
        ROBitTablePriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"price_cell" forIndexPath:indexPath];
        if (cell) {
            ROBitSource *source = [ROBitPricesManager sharedManager].sourcesPrices[indexPath.section];
            ROBitPrice *p = source.prices[indexPath.row];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH:mm:ss"];
            NSString *destDateString = [dateFormatter stringFromDate:p.updateTime];
            
            //cell.textLabel.text = destDateString;
            cell.sourceNameLabel.text = p.sourceName;
            cell.currencyLabel.text = p.currency;
            cell.currencyLabel.hidden = YES;
            float value = [p.latestPrice floatValue];
            if(value>0){
                cell.priceLabel.text = [NSString stringWithFormat:@"%@%.2f",kFormatCurrencyToSymbol[p.currency],value];
            }else{
                cell.priceLabel.text = NSLocalizedString(@"Connecting", nil);
            }
            if ([p.latestPrice floatValue]>0&&[p.previousPrice floatValue]>0) {
                if([p.latestPrice floatValue]>[p.previousPrice floatValue]){
                    cell.sourceNameLabel.backgroundColor = [UIColor greenColor];
                }else if ([p.latestPrice floatValue]<[p.previousPrice floatValue]){
                    cell.sourceNameLabel.backgroundColor = [UIColor redColor];
                }
            }
        }
        mCell = cell;
    }
    return mCell;
}

- (void)keyboardUp:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotification_PriceLoaded object:nil];
    
    NSDictionary *info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    UIEdgeInsets contentInset = self.tableView.contentInset;
    contentInset.bottom = keyboardRect.size.height;
    self.tableView.contentInset = contentInset;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    self.view.userInteractionEnabled =YES;
    [self.view addGestureRecognizer:tap];
}

-(void)hideKeyboard:(UITapGestureRecognizer*)tapg{
    [tapg.view removeGestureRecognizer:tapg];
    [self.view endEditing:YES];
}

- (void)keyboardDown:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAll) name:kNotification_PriceLoaded object:nil];
    NSDictionary *info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    UIEdgeInsets contentInset = self.tableView.contentInset;
    contentInset.bottom = 0;
    self.tableView.contentInset = contentInset;
}


#pragma momery manage

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    
}

@end
