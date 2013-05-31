//
//  PKIndustrySelectTableViewController.m
//  PDUKeeper
//
//  Created by James Abendroth on 3/29/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import "PKIndustrySelectTableViewController.h"
#import "PKCoreData.h"
#import "Industry.h"
#import "PDU.h"

@implementation PKIndustrySelectTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        [[self navigationItem] setTitle:@"Industry"];
        
        PKCoreData *data = [PKCoreData sharedStore];
        industries = [data allIndustries];
        
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
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [industries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Industry *i;
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    i = [industries objectAtIndex:indexPath.row];
    [[cell textLabel] setText:[i industryName]];
    
    if ([[self pdu] pduIndustry]){
        if ([[[self pdu] pduIndustry] isEqual:i]){
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            selectedCell = cell;
        }
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Industry *i;
    
    if (selectedCell){
        [selectedCell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    i = [industries objectAtIndex:indexPath.row];
    [[self pdu] setPduIndustry:i];
    
    selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    [selectedCell setAccessoryType:UITableViewCellAccessoryCheckmark];
    [selectedCell setSelected:NO];
    
}

@end
