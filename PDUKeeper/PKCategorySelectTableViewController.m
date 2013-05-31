//
//  PKCategorySelectTableViewController.m
//  PDUKeeper
//
//  Created by James Abendroth on 3/15/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import "PKCategorySelectTableViewController.h"
#import "PKCoreData.h"
#import "PDUCategory.h"
#import "PDU.h"

@implementation PKCategorySelectTableViewController

@synthesize pdu;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        PKCoreData *data = [PKCoreData sharedStore];
        categories = [data allPduCategories];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [categories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PDUCategory *cat;
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cat = [categories objectAtIndex:indexPath.row];
    [[cell textLabel] setText:[cat categoryName]];
    [[cell detailTextLabel] setText:[cat categoryDescription]];
    
    if ([[self pdu] pduCategory]){
        if ([[[[self pdu] pduCategory] categoryName] compare:[cat categoryName]] == 0){
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            selectedCell = cell;
        }
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    // De-select the currently selected cell (if there is one);
    if (selectedCell){
        [selectedCell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    [cell setSelected:NO];
    
    [[self pdu] setPduCategory:[categories objectAtIndex:indexPath.row]];
    selectedCell = cell;
}

@end
