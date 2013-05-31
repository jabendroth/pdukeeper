//
//  PKSettingsTableViewController.m
//  PDUKeeper
//
//  Created by James Abendroth on 4/12/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "PKSettingsTableViewController.h"
#import "PKSettingsStore.h"
#import "PKSettings.h"
#import "PKDatePicker.h"
#import "PKRemindersTableViewController.h"
#import "PKProviderTableViewController.h"
#import "HeaderFooterLabel.h"

#import "PKDataExporter.h"

@implementation PKSettingsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"Settings"];
        
        UIImage *tabImage = [UIImage imageNamed:@"20-gear-2.png"];
        [tbi setImage:tabImage];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[self navigationItem] setTitle:@"Settings"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    switch (section){
        case 0: // Expiration Date
            return 1;
        case 1: // Reminders
            return 1;
        case 2: // Providers
            return 1;
        case 3: // Reset and Export
            //return 2;
            return 1;
        default:
            return 0;
    }
    
}

/*
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section){
        case 0:
            return @"PMP Expiration Date";
        default:
            return @"";
    }
}
*/
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView;
    HeaderFooterLabel *label;
    CGFloat x, y, width, height;
    
    if (section == 0){
        headerView = [[UIView alloc] init];
        x = tableView.frame.origin.x+12.0;
        y = 5;
        width = tableView.frame.size.width-20.0;
        height = 20;
    
        label = [[HeaderFooterLabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [label setFont:[UIFont boldSystemFontOfSize:17]];
        [label setText:@"Certification Expiration Date"];
    
        [headerView addSubview:label];
        return headerView;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0){
        return 30;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    switch (indexPath.section){
        case 0:
            [self setupExpirationCell:cell];
            break;
        case 1:
            [[cell textLabel] setText:@"Reminders"];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            break;
        case 2:
            [[cell textLabel] setText:@"Providers"];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            break;
        case 3:
            switch (indexPath.row){
                case 0:
                    [[cell textLabel] setText:@"Export PDU Data"];
                    break;
                case 1:
                    [[cell textLabel] setText:@"Reset PDU Data"];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    return cell;
}

-(void)setupExpirationCell:(UITableViewCell*)cell
{
    NSDate *expirationDate;
    PKSettingsStore *store = [PKSettingsStore sharedStore];
    
    expirationDate = [[store settings] expirationDate];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM d yyyy"];
    
    [[cell textLabel] setText:[dateFormatter stringFromDate:expirationDate]];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PKRemindersTableViewController *rvc;
    PKProviderTableViewController *pvc;
    PKSettingsStore *store = [PKSettingsStore sharedStore];
    
    switch (indexPath.section){
        case 0:
            if (!dp){
                dp = [[PKDatePicker alloc] init];
                [dp setFromTabBar:[[self tabBarController] tabBar]];
                [dp setDelegate:self];
            }
    
            [dp setSelectedDate:[[store settings] expirationDate]];
            [dp showDatePicker];
            
            break;
        case 1:
            rvc = [[PKRemindersTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [[self navigationController] pushViewController:rvc animated:YES];
            break;
        case 2:
            pvc = [[PKProviderTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [[self navigationController] pushViewController:pvc animated:YES];
            break;
        case 3:
            switch (indexPath.row){
                case 0:
                    [self showMailExportDialog];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
    
}

-(void)dateSelected:(NSDate *)date
{
    PKSettingsStore *store = [PKSettingsStore sharedStore];
    [[store settings] setExpirationDate:date];
    [store saveChanges];
    
    NSIndexPath *path = [NSIndexPath indexPathForItem:0 inSection:0];
    UITableViewCell *cell = [[self tableView] cellForRowAtIndexPath:path];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM d yyyy"];
    
    [[cell textLabel] setText:[dateFormatter stringFromDate:date]];
    
}

-(void)showMailExportDialog
{
    PKDataExporter *de;
    NSData *pduData;
    
    if (!mc){
        mc = [[MFMailComposeViewController alloc] init];
    }
    
    if (![MFMailComposeViewController canSendMail]){
        UIAlertView *noMailMessage = [[UIAlertView alloc] initWithTitle:@"No Mail Accounts" message:@"Please configure an email account from which data can be sent." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [noMailMessage show];
        return;
    }
    
    de = [[PKDataExporter alloc] init];
    pduData = [de getPduCsv];
    
    if ([pduData length] == 0){
        UIAlertView *noMailMessage = [[UIAlertView alloc] initWithTitle:@"No PDU Data" message:@"You have not added any PDUs." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [noMailMessage show];
        return;
    }
    
    [mc setMailComposeDelegate:self];
    [mc setSubject:@"PDU Data from PDU Keeper"];
    [mc setMessageBody:@"Your PDU data from PDU Keeper is attached." isHTML:NO];
    
    [mc addAttachmentData:pduData mimeType:@"text/csv" fileName:@"PDUs.csv"];
    
    [[self tabBarController] presentViewController:mc animated:YES completion:nil];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [mc dismissViewControllerAnimated:YES completion:nil];
    mc = nil;
}

@end
