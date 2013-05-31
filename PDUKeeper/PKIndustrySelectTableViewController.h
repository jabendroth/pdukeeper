//
//  PKIndustrySelectTableViewController.h
//  PDUKeeper
//
//  Created by James Abendroth on 3/29/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKTableViewController.h"

@class PDU;

@interface PKIndustrySelectTableViewController : PKTableViewController
{
    NSArray *industries;
    UITableViewCell *selectedCell;
}

@property (weak, atomic) PDU *pdu;

@end
