//
//  PKPDUTableViewController.m
//  PDUKeeper
//
//  Created by James Abendroth on 3/8/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import "PKPDUTableViewController.h"
#import "PKPDUEntryTableViewController.h"
//#import "PKPDUTableViewCell.h"
#import "PKCoreData.h"
#import "PDUCategory.h"
#import "PDU.h"
#import "HeaderFooterLabel.h"

@implementation PKPDUTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [[self navigationItem] setTitle:@"PDUs"];
        
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        
        [[self navigationItem] setRightBarButtonItem:addButton];
        [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
        
        data = [PKCoreData sharedStore];
        [frc setDelegate:self];
        frc = [data getPDUFetchedResults :self];
        
    }
    return self;
}

-(IBAction)addNewItem:(id)sender
{
    PKPDUEntryTableViewController *evc = [[PKPDUEntryTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [[self navigationController] pushViewController:evc animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //UINib *nib = [UINib nibWithNibName:@"PKPDUTableViewCell" bundle:nil];
    //[[self tableView] registerNib:nib forCellReuseIdentifier:@"Cell"];
    
    data = [PKCoreData sharedStore];
    categories = [data allPduCategories];
    
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
    if ([[frc sections] count] == 0){
        
        footerView = [[UIView alloc] init];
        
        width = [[self view] bounds].size.width;
        height = 20;
        
        label = [[HeaderFooterLabel alloc] initWithFrame:CGRectMake(0, 15, width, height)];

        [label setFont:[UIFont systemFontOfSize:17]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setText:@"Click the + button to add your PDUs"];
        
        [footerView addSubview:label];
        
        [[self tableView] setTableFooterView:footerView];
    } else {
        [[self tableView] setTableFooterView:nil];
    }
    
    return [[frc sections] count];
}

/*
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[frc sections] objectAtIndex:section];
    PDU *p = [[sectionInfo objects] objectAtIndex:0];
    
    NSString *cn = [[p pduCategory] categoryName];
    
    if (cn != nil){
        return cn;
    } else {
        return @"Uncategorized";
    }
    
}
 */

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    //
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *cn;
    UIView *headerView;
    CGFloat x, y, width, height;
    UILabel *label, *subtitle;
    
    if ([[frc sections] count] == 0){
        return nil;
    }
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[frc sections] objectAtIndex:section];
    PDU *p = [[sectionInfo objects] objectAtIndex:0];
    cn = [[p pduCategory] categoryName];

    x = tableView.frame.origin.x+12.0;
    y = 5;
    width = tableView.frame.size.width-20.0;
    height = 20;
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    
    label = [[HeaderFooterLabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [label setText:cn];
    [label setFont:[UIFont boldSystemFontOfSize:17]];
    [headerView addSubview:label];
    
    subtitle = [[HeaderFooterLabel alloc] initWithFrame:CGRectMake(x, y+25, width-30, height)];
    
    [subtitle setBackgroundColor:[UIColor clearColor]];
    [subtitle setText:[[p pduCategory] categoryDescription]];
    [subtitle setFont:[UIFont systemFontOfSize:12]];
    [subtitle setAdjustsFontSizeToFitWidth:NO];
    [subtitle setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth];
    [headerView addSubview:subtitle];
    return headerView;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[frc sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

-(NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if ([[frc sections] count] == 0){
        //return @"TEST!";
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

-(void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    PDU *pdu;
    NSMutableString *detailStr;
    NSString *dateStr;
    NSDateFormatter *dateFormatter;
    
    [[cell detailTextLabel] setText:@""];
    [[cell textLabel] setText:@""];
    
    pdu = [frc objectAtIndexPath:indexPath];

    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];

    detailStr = [[NSMutableString alloc] init];
    [detailStr appendString:[NSString stringWithFormat:@"%.2f PDU", [[pdu pduHours] doubleValue]]];

    if([[pdu pduHours] doubleValue] > 1 || [[pdu pduHours] doubleValue] == 0) {
        [detailStr appendString:@"s"];
    }
    [detailStr appendString:@" earned"];
    if ([pdu dateCompleted] != nil){
        dateStr = [dateFormatter stringFromDate:[pdu dateCompleted]];
        [detailStr appendString:[NSString stringWithFormat:@" on %@", dateStr]];
    }

    if ([pdu pduTitle] == nil){
        [[cell textLabel] setText:@"[Title Not Set]"];
    } else {
        [[cell textLabel] setText:[pdu pduTitle]];
    }
    [[cell detailTextLabel] setText:detailStr];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    PDU *p = [frc objectAtIndexPath:indexPath];
    
    PKPDUEntryTableViewController *evc = [[PKPDUEntryTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [evc setPdu:p];
    [[self navigationController] pushViewController:evc animated:YES];
    
    cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        PDU *p = [frc objectAtIndexPath:indexPath];
        [[frc managedObjectContext] deleteObject:p];
        [data saveContext];
    }
}

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [[self tableView] beginUpdates];
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [[self tableView] endUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[[self tableView] cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
    
}

-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [[self tableView] insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [[self tableView] deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }

}

@end
