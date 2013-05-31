//
//  PKPDUEntryTableViewController.m
//  PDUKeeper
//
//  Created by James Abendroth on 3/11/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import "PKPDUEntryTableViewController.h"
#import "PKProcessSelectTableViewController.h"
#import "PKCategorySelectTableViewController.h"
#import "PKKnowledgeAreaTableViewController.h"
#import "PKIndustrySelectTableViewController.h"
#import "PKProviderSelectTableViewController.h"
#import "HeaderFooterLabel.h"
#import "PKDatePicker.h"

#import "PKCoreData.h"
#import "PDU.h"
#import "PDUCategory.h"
#import "Industry.h"
#import "PDUProvider.h"

@implementation PKPDUEntryTableViewController

@synthesize pdu;

- (id)initWithStyle:(UITableViewStyle)style
{
    
    self = [super initWithStyle:style];
    if (self) {
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(doCancel:)];
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doAddPDU:)];
        
        [[self navigationItem] setLeftBarButtonItem:cancelButton];
        [[self navigationItem] setRightBarButtonItem:doneButton];
        
        // Setup table instance variables
        tableSections = [[NSArray alloc] initWithObjects:@"Program Information", @"Program Dates", @"Other PDU Information", nil];

        programInfoSubtitles = [[NSMutableArray alloc] initWithObjects:@"Program Title/Description", @"Hours Completed", @"Category", @"Component ID", nil];
        dateIndex = -1;
        
    }
    return self;
}

-(void)setupProgramInfoLabels
{
    NSString *hoursLabel;
    hoursLabel = [[NSString alloc] initWithFormat:@"%.2f", [[pdu pduHours] floatValue]];
    
    if (programInfoTableItems == nil){
        programInfoTableItems = [[NSMutableArray alloc] initWithObjects:NOT_SET_STR,
                                 hoursLabel,
                                 NOT_SET_STR,
                                 NOT_SET_STR,
                                 nil];
    }
    
    // Set the PDU title.
    if ([pdu pduTitle] == nil){
        [programInfoTableItems setObject:NOT_SET_STR atIndexedSubscript:0];
    } else {
        [programInfoTableItems setObject:[pdu pduTitle] atIndexedSubscript:0];
    }
    
    // Set the PDU category.
    if ([[pdu pduCategory] categoryName] == nil){
        [programInfoTableItems setObject:NOT_SET_STR atIndexedSubscript:2];
    } else {
        [programInfoTableItems setObject:[[pdu pduCategory] categoryName] atIndexedSubscript:2];
    }
    
    if ([pdu componentId] == nil){
        [programInfoTableItems setObject:NOT_SET_STR atIndexedSubscript:3];
    } else {
        [programInfoTableItems setObject:[pdu componentId] atIndexedSubscript:3];
    }
}

-(NSString*)getProcessString
{
    return [NSString stringWithFormat:@"Processes (%d)", [[pdu pduProcesses] count]];
}

-(NSString*)getKnowledgeAreasString
{
    return [NSString stringWithFormat:@"KnowledgeAreas (%d)", [[pdu pduKnowledgeAreas] count]];
}

-(IBAction)doCancel:(id)sender
{
    if (adding){
        PKCoreData *data = [PKCoreData sharedStore];
        [data deletePdu:[self pdu] doSaveContext:NO];
    }
    [[self navigationController] popViewControllerAnimated:YES];
}

-(IBAction)doAddPDU:(id)sender
{
    PKCoreData *data = [PKCoreData sharedStore];
    
    if ([[self pdu] pduCategory] != nil){
        [data saveContext];
        [[self navigationController] popViewControllerAnimated:YES];
    } else {
        // Force the user to add a category.
        UIAlertView *saveMessage = [[UIAlertView alloc] initWithTitle:@"Missing Category" message:@"Please provide a category for this PDU entry" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [saveMessage show];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    PKCoreData *data = [PKCoreData sharedStore];
    [super viewWillAppear:animated];
    
    if ([self pdu] == nil){
        [self setPdu:[data newPDU]];
        [[self navigationItem] setTitle:@"New PDU Entry"];
        adding = YES;
    } else {
        [[self navigationItem] setTitle:@"Edit PDU Entry"];
        adding = NO;
    }
    [self setupProgramInfoLabels];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"appeared");
    
    otherTableItems = [[NSMutableArray alloc] initWithObjects:[self getProcessString], [self getKnowledgeAreasString], @"Industry", @"Provider", nil];
    
    //TODO: Don't just reload the whole table.
    [[self tableView] reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [tableSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    switch (section) {
        case 0:
            return 4;
        case 1:
            return 2;
        case 2:
            return [otherTableItems count];
        default:
            return 0;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView;
    HeaderFooterLabel *label;
    NSString *labelText = [tableSections objectAtIndex:section];
    CGFloat x, y, width, height;
    
    headerView = [[UIView alloc] init];
    x = tableView.frame.origin.x+12.0;
    y = 5;
    width = tableView.frame.size.width-20.0;
    height = 20;
    
    label = [[HeaderFooterLabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [label setFont:[UIFont boldSystemFontOfSize:17]];
    [label setText:labelText];
    
    [headerView addSubview:label];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    NSString *label;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    } else {
        [[cell detailTextLabel] setText:@""];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }

    switch (indexPath.section) {
        
        // General info table
        case 0:
        {
            [self setupProgramInfoLabels];
            label = [programInfoTableItems objectAtIndex:indexPath.row];
            if (indexPath.row == 2){
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            }
            [[cell detailTextLabel] setText:[programInfoSubtitles objectAtIndex:indexPath.row]];
            break;
        }
        // Dates table
        case 1:
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MMMM d yyyy"];

            switch (indexPath.row){
                case 0:
                    [[cell detailTextLabel] setText:@"Start Date"];
                    if ([pdu dateStarted] != nil){
                        label = [dateFormatter stringFromDate:[pdu dateStarted]];
                    } else {
                        label = NOT_SET_STR;
                    }
                    break;
                case 1:
                    [[cell detailTextLabel] setText:@"End Date"];
                    if ([pdu dateCompleted] != nil){
                        label = [dateFormatter stringFromDate:[pdu dateCompleted]];
                    } else {
                        label = NOT_SET_STR;
                    }
                    break;
                default:
                    break;
            }
            
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            
            break;
        }
        // Additional info table
        case 2:
        {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            
            if (indexPath.row == 2){
                [[cell detailTextLabel] setText:@"Industry"];
                if ([pdu pduIndustry]){
                    label = [[pdu pduIndustry] industryName];
                } else {
                    label = NOT_SET_STR;
                }
            } else if (indexPath.row == 3){
                [[cell detailTextLabel] setText:@"Provider"];
                if ([pdu pduProvider]){
                    label = [[pdu pduProvider] providerName];
                } else {
                    label = NOT_SET_STR;
                }
            } else {
                label = [otherTableItems objectAtIndex:indexPath.row];
            }
            
            break;
        }
        default:
            label = @"";
            break;
    }
    
    [[cell textLabel] setText:label];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            [self programInformationTableSelect:indexPath.row];
            break;
        }
        case 1:
        {
            dateIndex = indexPath.row;
            [self showDatePicker];
            break;
        }
        case 2:
        {
            [self otherInformationTableSelect:indexPath.row];
            break;
        }
        default:
            break;
    }
    
    // Clear the selection.
    UITableViewCell *cell = [[self tableView] cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
    
}

-(void)otherInformationTableSelect:(int)row
{
    switch (row){
        // Processes
        case 0:
        {
            PKProcessSelectTableViewController *vc = [[PKProcessSelectTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [vc setPdu:pdu];
            [[self navigationController] pushViewController:vc animated:YES];
            
            break;
        }
        // Knowledge Areas
        case 1:
        {
            PKKnowledgeAreaTableViewController *vc = [[PKKnowledgeAreaTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [vc setPdu:pdu];
            [[self navigationController] pushViewController:vc animated:YES];
            
            break;
        }
        // Industry
        case 2:
        {
            PKIndustrySelectTableViewController *vc = [[PKIndustrySelectTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [vc setPdu:pdu];
            [[self navigationController] pushViewController:vc animated:YES];
            break;
        }
        // Provider
        case 3:
        {
            PKProviderSelectTableViewController *pvc = [[PKProviderSelectTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [pvc setPdu:pdu];
            [[self navigationController] pushViewController:pvc animated:YES];
            break;
        }
        default:
            break;
    }
}

-(void)showDatePicker
{
    if (!dp){
        dp = [[PKDatePicker alloc] init];
        [dp setFromTabBar:[[self tabBarController] tabBar]];
        [dp setDelegate:self];
    }
    
    if (dateIndex == 0 && [pdu dateStarted] != nil){
        [dp setSelectedDate:[pdu dateStarted]];
    } else if (dateIndex == 1 && [pdu dateCompleted] != nil){
        [dp setSelectedDate:[pdu dateCompleted]];
    }
    
    [dp showDatePicker];

}

-(void)dateSelected:(NSDate *)date
{
    if (dateIndex == 0){
        [pdu setDateStarted:date];
    } else {
        [pdu setDateCompleted:date];
    }
    dateIndex = -1;
    
    NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:1];
    [[self tableView] reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
}

-(void)programInformationTableSelect:(int)row
{
    switch (row) {
        case 0:
            [self showTitlePrompt];
            break;
        case 1:
            [self showHoursPrompt];
            break;
        case 2:
        {
            PKCategorySelectTableViewController *vc = [[PKCategorySelectTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [vc setPdu:pdu];
            [[self navigationController] pushViewController:vc animated:YES];
            
            break;
        }
        case 3:
        {
            [self showComponentIdPrompt];
            break;
        }
        default:
            break;
    }
}

-(void)showComponentIdPrompt
{
    UIAlertView *newItemPrompt = [[UIAlertView alloc] initWithTitle:@"Component ID" message:@"Enter Program Component ID" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    newItemPrompt.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    if ([[pdu componentId] compare:@"Not set"]){
        UITextField *tf = [newItemPrompt textFieldAtIndex:0];
        [tf setText:[pdu componentId]];
    }
    
    [newItemPrompt show];
}

-(void)showTitlePrompt
{
    UIAlertView *newItemPrompt = [[UIAlertView alloc] initWithTitle:@"Program Title" message:@"Enter Program Title or Description" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    newItemPrompt.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    if ([[pdu pduTitle] compare:@"Not set"]){
        UITextField *tf = [newItemPrompt textFieldAtIndex:0];
        [tf setText:[pdu pduTitle]];
    }
    
    [newItemPrompt show];
}

-(void)showHoursPrompt
{
    UIAlertView *newItemPrompt = [[UIAlertView alloc] initWithTitle:@"Program Hours" message:@"Enter the number of program hours" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    newItemPrompt.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    UITextField *tf = [newItemPrompt textFieldAtIndex:0];
    [tf setKeyboardType:UIKeyboardTypeDecimalPad];
    
    if ([[pdu pduHours] floatValue] != 0.0f){
        UITextField *tf = [newItemPrompt textFieldAtIndex:0];
        [tf setText:[NSString stringWithFormat:@"%.2f", [[pdu pduHours] floatValue]]];
    }
    
    [newItemPrompt show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0)
        return;
    
    UITextField *tf = [alertView textFieldAtIndex:0];
    
    if ([[alertView title] compare:@"Program Title"] == 0){
        [pdu setPduTitle:[tf text]];
        [programInfoTableItems replaceObjectAtIndex:0 withObject:[pdu pduTitle]];
    } else if ([[alertView title] compare:@"Program Hours"] == 0){
        [pdu setPduHours:[NSNumber numberWithFloat:[[tf text] floatValue]]];
        [programInfoTableItems replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%.2f", [[pdu pduHours] floatValue]]];
    } else if ([[alertView title] compare:@"Component ID"] == 0){
        [pdu setComponentId:[tf text]];
        [programInfoTableItems replaceObjectAtIndex:3 withObject:[pdu componentId]];
    }
    
    [[self tableView] reloadData];

}

-(void)setStartDate:(NSDate *)sd
{
    [pdu setDateStarted:sd];
    [[self tableView] reloadData];
}

-(void)setEndDate:(NSDate *)ed
{
    [pdu setDateCompleted:ed];
    [[self tableView] reloadData];
}

@end
