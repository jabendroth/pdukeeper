//
//  PKDatePicker.h
//  PDUKeeper
//
//  Created by James Abendroth on 4/12/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PKDatePickerDelegate.h"

@interface PKDatePicker : NSObject
{
    UIDatePicker *picker;
    UIActionSheet *sheet;
}

@property (atomic) NSDate* selectedDate;
@property (atomic) UITabBar *fromTabBar;
@property (atomic) id<PKDatePickerDelegate> delegate;

-(void)showDatePicker;
-(void)datePickerCancel;
-(void)datePickerDone;

@end
