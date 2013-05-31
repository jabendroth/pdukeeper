//
//  PKSettingsTableViewController.h
//  PDUKeeper
//
//  Created by James Abendroth on 4/12/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "PKDatePickerDelegate.h"
#import "PKTableViewController.h"

@class PKDatePicker;

@interface PKSettingsTableViewController : PKTableViewController <PKDatePickerDelegate, MFMailComposeViewControllerDelegate>
{
    PKDatePicker *dp;
    MFMailComposeViewController *mc;
}

-(void)setupExpirationCell:(UITableViewCell*)cell;
-(void)dateSelected:(NSDate *)date;

@end
