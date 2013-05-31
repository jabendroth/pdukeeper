//
//  PKProcessSelectTableViewController.h
//  PDUKeeper
//
//  Created by James Abendroth on 3/13/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKTableViewController.h"

@class PDU;

@interface PKProcessSelectTableViewController : PKTableViewController
{
    NSArray *processes;
}

@property (weak, atomic) PDU *pdu;

@end
