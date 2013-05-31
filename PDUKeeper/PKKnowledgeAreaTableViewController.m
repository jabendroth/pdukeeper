//
//  PKKnowledgeAreaTableViewController.m
//  PDUKeeper
//
//  Created by James Abendroth on 3/20/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import "PKKnowledgeAreaTableViewController.h"
#import "PKCoreData.h"
#import "KnowledgeArea.h"
#import "PDU.h"

@implementation PKKnowledgeAreaTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        [[self navigationItem] setTitle:@"Knowledge Areas"];
        
        PKCoreData *data = [PKCoreData sharedStore];
        knowledgeAreas = [data allKnowledgeAreas];
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
    return [knowledgeAreas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KnowledgeArea *ka;
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    ka = [knowledgeAreas objectAtIndex:indexPath.row];
    [[cell textLabel] setText:[ka areaName]];
    
    // Select the cell if the process belongs to this PDU object.
    for (KnowledgeArea *k in [[self pdu] pduKnowledgeAreas]){
        if ([[k areaName] compare:[ka areaName]]==0){
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
    KnowledgeArea *ka = [knowledgeAreas objectAtIndex: indexPath.row];
    
    if ([cell accessoryType] == UITableViewCellAccessoryCheckmark){
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [[self pdu] removePduKnowledgeAreasObject:ka];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        [[self pdu] addPduKnowledgeAreasObject:ka];
    }
    [cell setSelected:NO];
}

@end
