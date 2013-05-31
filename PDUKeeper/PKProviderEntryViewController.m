//
//  PKProviderEntryViewController.m
//  PDUKeeper
//
//  Created by James Abendroth on 4/24/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import "PKProviderEntryViewController.h"
#import "PKCoreData.h"
#import "PDUProvider.h"
#import "PKProviderTableViewController.h"
#import "PKStatePickerDelegate.h"

@implementation PKProviderEntryViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        fieldNames = [[NSArray alloc] initWithObjects:@"Provider Name",
                      @"Address Line 1",
                      @"Address Line 2",
                      @"City",
                      @"State",
                      @"Zip",
                      nil];
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonPressed)];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPressed)];
        
        [[self navigationItem] setRightBarButtonItem:doneButton];
        [[self navigationItem] setLeftBarButtonItem:cancelButton];
        
    }
    return self;
}

-(void)cancelButtonPressed
{
    [[self navigationController] popViewControllerAnimated:YES];
}

-(void)doneButtonPressed
{
    PKCoreData *data = [PKCoreData sharedStore];
    
    if ([[[self provider] providerName] compare:@""]==0){
        // Force the user to add a category.
        UIAlertView *saveMessage = [[UIAlertView alloc] initWithTitle:@"Missing Provider Name" message:@"Please provide a name for this provider" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [saveMessage show];
        return;
    }
    
    [data saveContext];
    
    if ([self parent]){
        [[self parent] refreshTable];
    }
    
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    PKCoreData *data = [PKCoreData sharedStore];
    
    if ([self provider]){
        [[self navigationItem] setTitle:@"Edit Provider"];
    } else {
        [[self navigationItem] setTitle:@"New Provider"];
        [self setProvider:[data newProvider]];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [[cell detailTextLabel] setText:[fieldNames objectAtIndex:indexPath.row]];
    
    switch (indexPath.row){
        case 0:
            [[cell textLabel] setText:[[self provider] providerName]];
            break;
        case 1:
            [[cell textLabel] setText:[[self provider] providerAddress1]];
            break;
        case 2:
            [[cell textLabel] setText:[[self provider] providerAddress2]];
            break;
        case 3:
            [[cell textLabel] setText:[[self provider] providerCity]];
            break;
        case 4:
            [[cell textLabel] setText:[[self provider] providerState]];
            break;
        case 5:
            [[cell textLabel] setText:[[self provider] providerZip]];
            break;
        default:
            break;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
    currentPath = indexPath;
    
    if (indexPath.row == 4){
        
        if (!statePicker){
            statePicker = [[PKStatePicker alloc] init];
            [statePicker setDelegate:self];
            [statePicker setFromTabBar:[[self tabBarController] tabBar]];
        }
        [statePicker setSelectedState:[[self provider] providerState]];
        [statePicker showStatePicker];
        
    } else {
        [self showFieldPrompt];
    }
}

-(void)showFieldPrompt
{
    UIAlertView *fieldPrompt = [[UIAlertView alloc] initWithTitle:[fieldNames objectAtIndex:currentPath.row]
                                                    message:@"" delegate:self cancelButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"Ok", nil];
    fieldPrompt.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    if (currentPath.row == 5){
        UITextField *tf = [fieldPrompt textFieldAtIndex:0];
        [tf setKeyboardType:UIKeyboardTypeDecimalPad];
    }
    
    fieldPrompt.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [fieldPrompt show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
        return;
    
    UITextField *tf = [alertView textFieldAtIndex:0];
    switch (currentPath.row){
        case 0:
            [[self provider] setProviderName:[tf text]];
            break;
        case 1:
            [[self provider] setProviderAddress1:[tf text]];
            break;
        case 2:
            [[self provider] setProviderAddress2:[tf text]];
            break;
        case 3:
            [[self provider] setProviderCity:[tf text]];
            break;
        case 4:
            [[self provider] setProviderState:[tf text]];
            break;
        case 5:
            [[self provider] setProviderZip:[tf text]];
            break;
        default:
            break;
    }
    
    [[self tableView] reloadData];
    currentPath = nil;
}

-(void)stateSelected:(NSString *)stateCode
{
    NSLog(@"%@", stateCode);
    [[self provider] setProviderState:stateCode];
    [[self tableView] reloadData];
}

@end
