//
//  PKProviderTableViewController.m
//  PDUKeeper
//
//  Created by James Abendroth on 4/20/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import "PKProviderTableViewController.h"
#import "HeaderFooterLabel.h"
#import "PDUProvider.h"
#import "PKCoreData.h"
#import "PKProviderEntryViewController.h"

@implementation PKProviderTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem)];
        
        [[self navigationItem] setRightBarButtonItems:[NSArray arrayWithObjects:addButton, self.editButtonItem, nil]];
        
        PKCoreData *data = [PKCoreData sharedStore];
        providers = [data allProviders];
        
    }
    return self;
}

-(void)addNewItem
{
    PKProviderEntryViewController *vc = [[PKProviderEntryViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [vc setParent:self];
    [[self navigationController] pushViewController:vc animated:YES];
}

- (void)viewDidLoad
{
    NSLog(@"loaded");
    [super viewDidLoad];
    [[self navigationItem] setTitle:@"Providers"];
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"Appeared");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    pp = [providers objectAtIndex:indexPath.row];
    [[cell textLabel] setText:[pp providerName]];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PDUProvider *pp;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    pp = [providers objectAtIndex:indexPath.row];
    PKProviderEntryViewController *vc = [[PKProviderEntryViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [vc setProvider:pp];
    [vc setParent:self];
    [[self navigationController] pushViewController:vc animated:YES];
    
    [cell setSelected:NO];
}

-(void)refreshTable
{
    PKCoreData *data = [PKCoreData sharedStore];
    providers = [data allProviders];
    [[self tableView] reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    PDUProvider *pp;
    PKCoreData *data = [PKCoreData sharedStore];
    
    pp = [providers objectAtIndex:indexPath.row];
    [data deleteManagedObject:pp doSaveContext:YES];
    
    [self refreshTable];
}

@end
