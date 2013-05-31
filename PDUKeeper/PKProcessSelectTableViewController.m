//
//  PKProcessSelectTableViewController.m
//  PDUKeeper
//
//  Created by James Abendroth on 3/13/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import "PKProcessSelectTableViewController.h"
#import "PKCoreData.h"
#import "Process.h"
#import "PDU.h"

@implementation PKProcessSelectTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        [[self navigationItem] setTitle:@"Processes"];
        
        PKCoreData *data = [PKCoreData sharedStore];
        processes = [data allProcesses];
        
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [processes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Process *proc;
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    proc = [processes objectAtIndex:indexPath.row];
    [[cell textLabel] setText:[proc processName]];
    
    // Select the cell if the process belongs to this PDU object.
    for (Process *p in [[self pdu] pduProcesses]){
        if ([[p processName] compare:[proc processName]]==0){
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            break;
        }
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[self tableView] cellForRowAtIndexPath:indexPath];
    Process *p = [processes objectAtIndex: indexPath.row];
    
    if ([cell accessoryType] == UITableViewCellAccessoryCheckmark){
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [[self pdu] removePduProcessesObject:p];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        [[self pdu] addPduProcessesObject:p];
    }
    [cell setSelected:NO];
}

@end
