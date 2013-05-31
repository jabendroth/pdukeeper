//
//  PKProviderSelectTableViewController.m
//  PDUKeeper
//
//  Created by James Abendroth on 4/25/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import "PKProviderSelectTableViewController.h"
#import "PKCoreData.h"
#import "PDUProvider.h"
#import "PDU.h"
#import "PKProviderEntryViewController.h"
#import "HeaderFooterLabel.h"

@implementation PKProviderSelectTableViewController

@synthesize pdu;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        PKCoreData *data = [PKCoreData sharedStore];
        providers = [data allProviders];
        
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem)];
        
        [[self navigationItem] setRightBarButtonItem:addButton];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationItem] setTitle:@"Provider"];
}

-(void)addNewItem
{
    PKProviderEntryViewController *vc = [[PKProviderEntryViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [vc setParent:self];
    [[self navigationController] pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int width, height;
    UIView *footerView;
    HeaderFooterLabel *label;
    
    // Add a footer view with a message if we don't have any PDU entries.
    if ([providers count] == 0){
        
        footerView = [[UIView alloc] init];
        
        width = [[self view] bounds].size.width;
        height = 20;
        
        label = [[HeaderFooterLabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        
        [label setFont:[UIFont systemFontOfSize:17]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setText:@"Click the + button to add providers"];
        
        [footerView addSubview:label];
        
        [[self tableView] setTableFooterView:footerView];
    } else {
        [[self tableView] setTableFooterView:nil];
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [providers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PDUProvider *pp;
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    pp = [providers objectAtIndex:indexPath.row];
    [[cell textLabel] setText:[pp providerName]];
    
    if ([[self pdu] pduProvider]){
        if ([[pp providerName] compare:[[[self pdu] pduProvider] providerName]] == 0){
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
    
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    [cell setSelected:NO];
    
    // De-select the currently selected cell (if there is one);
    if (selectedCell){
        [selectedCell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    [[self pdu] setPduProvider:[providers objectAtIndex:indexPath.row]];
    selectedCell = cell;
    
}

-(void)refreshTable
{
    PKCoreData *data = [PKCoreData sharedStore];
    providers = [data allProviders];
    [[self tableView] reloadData];
}

@end
