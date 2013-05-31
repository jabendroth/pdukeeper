//
//  PKDatePickerDelegate.h
//  PDUKeeper
//
//  Created by James Abendroth on 4/13/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PKDatePickerDelegate <NSObject>
-(void)dateSelected:(NSDate*)date;
@end
