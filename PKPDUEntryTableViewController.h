//
//  PKPDUEntryTableViewController.h
//  PDUKeeper
//
//  Created by James Abendroth on 3/11/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKTableViewController.h"
#import "PKDatePicker.h"

#define NOT_SET_STR @"Not Set"

@class PDUCategory, PDU;

@interface PKPDUEntryTableViewController : PKTableViewController <UIAlertViewDelegate, PKDatePickerDelegate>
{
    int dateIndex;
    BOOL adding;
    
    PKDatePicker *dp;
    UIActionSheet *sheet;
    
    NSArray *tableSections;
    
    NSMutableArray *programInfoTableItems;
    NSMutableArray *programInfoSubtitles;
    
    NSMutableArray *otherTableItems;
}

@property (atomic) PDU *pdu;
//@property (atomic) BOOL adding;

-(IBAction)doCancel:(id)sender;
-(IBAction)doAddPDU:(id)sender;

-(void)programInformationTableSelect:(int)row;
-(void)otherInformationTableSelect:(int)row;

-(void)showComponentIdPrompt;
-(void)showTitlePrompt;
-(void)showHoursPrompt;

-(void)setStartDate:(NSDate*)sd;
-(void)setEndDate:(NSDate*)ed;

-(void)showDatePicker;

-(NSString*)getProcessString;
-(NSString*)getKnowledgeAreasString;

-(void)setupProgramInfoLabels;

@end
