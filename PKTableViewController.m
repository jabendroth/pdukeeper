//
//  PKTableViewController.m
//  PDUKeeper
//
//  Created by James Abendroth on 4/25/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import "PKTableViewController.h"

@implementation PKTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        UIView *v = [[UIView alloc] init];
        [v setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"table_bg.png"]]];
        [[self tableView] setBackgroundView:v];
        
    }
    return self; 
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
