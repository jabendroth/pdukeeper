//
//  PKProviderEntryViewController.h
//  PDUKeeper
//
//  Created by James Abendroth on 4/24/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKTableViewController.h"
#import "PKTableRefreshDelegate.h"
#import "PKStatePickerDelegate.h"
#import "PKStatePicker.h"

@class PDUProvider, PKProviderTableViewController;

@interface PKProviderEntryViewController : PKTableViewController <UIAlertViewDelegate, PKStatePickerDelegate>
{
    NSArray *fieldNames;
    NSIndexPath *currentPath;
    PKStatePicker *statePicker;
}

@property (nonatomic) PDUProvider *provider;
@property (nonatomic) id<PKTableRefreshDelegate> parent;

-(void)showFieldPrompt;
-(void)cancelButtonPressed;
-(void)doneButtonPressed;

@end
