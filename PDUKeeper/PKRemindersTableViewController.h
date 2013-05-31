//
//  PKRemindersTableViewController.h
//  PDUKeeper
//
//  Created by James Abendroth on 4/20/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKTableViewController.h"

@interface PKRemindersTableViewController : PKTableViewController
{
    //
}

-(void)yearlySwitchChanged:(id)sender;
-(void)biyearlySwitchChanged:(id)sender;
-(void)monthlySwitchChanged:(id)sender;

-(NSString*)getTextLabel:(int)row;

@end
