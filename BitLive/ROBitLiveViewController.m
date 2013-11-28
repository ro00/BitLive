//
//  ROBitLiveViewController.m
//  BitLive
//
//  Created by iamro on 13-11-24.
//  Copyright (c) 2013年 iamro. All rights reserved.
//

#import "ROBitLiveViewController.h"
#import "ROBitPricesManager.h"

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAll) name:kPricesChangedNotification object:nil];
    [[ROBitPricesManager sharedManager] testParse];
    //self.edgesForExtendedLayout = UIRectEdgeAll;
    //self.tableView.contentInset = UIEdgeInsetsMake(0., 0., 45, 0);
    //self.tableView.frame = CGRectMake(self.tableView.bounds.origin.x, self.tableView.bounds.origin.y, self.tableView.bounds.size.width, self.tableView.bounds.size.height-45);
    
}

-(void)updateAll{
    [[self tableView] reloadData];
}

#pragma table view
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"price_cell" forIndexPath:indexPath];
    if (cell) {
        cell.textLabel.text = @"Mt.Gox";
        cell.detailTextLabel.text = [ROBitPricesManager sharedManager].price;
    }
    return cell;
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
