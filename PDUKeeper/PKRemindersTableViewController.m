//
//  PKRemindersTableViewController.m
//  PDUKeeper
//
//  Created by James Abendroth on 4/20/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import "PKRemindersTableViewController.h"
#import "PKSettingsStore.h"
#import "PKSettings.h"

@implementation PKRemindersTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [[self navigationItem] setTitle:@"Reminders"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self tableView] setScrollEnabled:NO];
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UISwitch *switchView;
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [[cell textLabel] setText:[self getTextLabel:indexPath.row]];
    [cell setSelectionStyle:UITableViewCellEditingStyleNone];
    
    switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
    [switchView addTarget:self action:[self getSwitchSelector:indexPath.row] forControlEvents:UIControlEventValueChanged];
    
    [switchView setOn:[self getSwitchEnabled:indexPath.row]];
    [cell setAccessoryView:switchView];
    
    [cell setSelectionStyle:UITableViewCellSeparatorStyleNone];
    return cell;
}

-(NSString*)getTextLabel:(int)row
{
    switch (row){
        case 0:
            return @"Every Year";
        case 1:
            return @"Every 6 Months";
        case 2:
            return @"Every Month";
        default:
            return @"";
    }
}

-(SEL)getSwitchSelector:(int)row
{
    switch (row){
        case 0:
            return @selector(yearlySwitchChanged:);
        case 1:
            return @selector(biyearlySwitchChanged:);
        case 2:
            return @selector(monthlySwitchChanged:);
        default:
            return nil;
    }
}

-(BOOL)getSwitchEnabled:(int)row
{
    PKSettingsStore *store = [PKSettingsStore sharedStore];
    
    switch (row){
        case 0:
            return [[store settings] enableReminderYearly];
        case 1:
            return [[store settings] enableReminderBiYearly];
        case 2:
            return [[store settings] enableReminderMonthly];
        default:
            return nil;
    }
    
}

-(void)yearlySwitchChanged:(id)sender
{
    UISwitch *switchView = (UISwitch*)sender;
    PKSettingsStore *store = [PKSettingsStore sharedStore];
    
    [[store settings] setEnableReminderYearly:[switchView isOn]];
    [store saveChanges];
}

-(void)biyearlySwitchChanged:(id)sender
{
    UISwitch *switchView = (UISwitch*)sender;
    PKSettingsStore *store = [PKSettingsStore sharedStore];
    
    [[store settings] setEnableReminderBiYearly:[switchView isOn]];
    [store saveChanges];
}

-(void)monthlySwitchChanged:(id)sender
{
    UISwitch *switchView = (UISwitch*)sender;
    PKSettingsStore *store = [PKSettingsStore sharedStore];
    
    [[store settings] setEnableReminderMonthly:[switchView isOn]];
    [store saveChanges];
}

@end
