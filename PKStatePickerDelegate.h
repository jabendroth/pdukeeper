//
//  PKStatePickerDelegate.h
//  PDUKeeper
//
//  Created by James Abendroth on 5/21/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PKStatePickerDelegate <NSObject>
-(void)stateSelected:(NSString*)stateCode;
@end
