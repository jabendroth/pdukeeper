//
//  PKDatePicker.m
//  PDUKeeper
//
//  Created by James Abendroth on 4/12/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import "PKDatePicker.h"

@implementation PKDatePicker

@synthesize selectedDate;
@synthesize fromTabBar;
@synthesize delegate;

-(void)showDatePicker
{
    CGRect pickerFrame;
    UIToolbar *toolbar;
    
    sheet = [[UIActionSheet alloc] init];
    
    pickerFrame = CGRectMake(0, 0, 0, 0);
    picker = [[UIDatePicker alloc] initWithFrame:pickerFrame];
    [picker setDatePickerMode:UIDatePickerModeDate];
    
    if ([self selectedDate])
        [picker setDate:[self selectedDate]];
    
    [sheet addSubview:picker];
    
    toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, 320, 44)];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    
    UIBarButtonItem *filler = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle: @"Done" style: UIBarButtonItemStyleDone target: self action: @selector(datePickerDone)];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle: @"Cancel" style: UIBarButtonSystemItemCancel target: self action: @selector(datePickerCancel)];
    
    toolbar.items = [NSArray arrayWithObjects: cancelButton, filler, doneButton, nil];
    [sheet addSubview: toolbar];
    
    [sheet showFromTabBar:[self fromTabBar]];
    [sheet setBounds:CGRectMake(0, 0, 320, 415)];
    
}

-(void)datePickerCancel
{
    [sheet dismissWithClickedButtonIndex:1 animated:YES];
}

-(void)datePickerDone
{
    [self setSelectedDate:[picker date]];
    if ([self delegate])
        [[self delegate] dateSelected:[picker date]];
    [sheet dismissWithClickedButtonIndex:0 animated:YES];
}

@end
