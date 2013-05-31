//
//  PKStatePicker.h
//  PDUKeeper
//
//  Created by James Abendroth on 5/21/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PKStatePickerDelegate.h"

@interface PKStatePicker : NSObject <UIPickerViewDelegate>
{
    UIActionSheet *sheet;
    UIPickerView *picker;
    NSMutableArray *states;
}

@property (atomic) NSString* selectedState;
@property (atomic) UITabBar *fromTabBar;
@property (atomic) id<PKStatePickerDelegate> delegate;

-(void)showStatePicker;
-(void)statePickerCancel;
-(void)statePickerDone;

@end
