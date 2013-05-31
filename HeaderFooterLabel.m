//
//  HeaderFooterLabel.m
//  PDUKeeper
//
//  Created by James Abendroth on 4/22/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import "HeaderFooterLabel.h"

@implementation HeaderFooterLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        /* iPhone Standard Header
        
        [self setTextColor:[UIColor colorWithRed:0.298 green:0.337 blue:0.423 alpha:1]];
        [self setBackgroundColor:[UIColor clearColor]];
        
        [self setShadowColor:[UIColor whiteColor]];
        [self setShadowOffset:CGSizeMake(0, 1)];
        */
        
        [self setTextColor:[UIColor whiteColor]];
        [self setBackgroundColor:[UIColor clearColor]];
        
        [self setShadowColor:[UIColor grayColor]];
        [self setShadowOffset:CGSizeMake(0, 1)];
        
    }
    return self;
}

@end
