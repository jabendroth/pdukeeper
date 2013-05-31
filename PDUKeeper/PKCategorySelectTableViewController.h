//
//  PKCategorySelectTableViewController.h
//  PDUKeeper
//
//  Created by James Abendroth on 3/15/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKTableViewController.h"

@class PDU;

@interface PKCategorySelectTableViewController : PKTableViewController
{
    NSArray *categories;
    UITableViewCell *selectedCell;
}

@property (weak, atomic) PDU *pdu;

@end
