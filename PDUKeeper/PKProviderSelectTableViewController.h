//
//  PKProviderSelectTableViewController.h
//  PDUKeeper
//
//  Created by James Abendroth on 4/25/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKTableViewController.h"
#import "PKTableRefreshDelegate.h"

@class PDUProvider, PDU;

@interface PKProviderSelectTableViewController : PKTableViewController <PKTableRefreshDelegate>
{
    NSArray *providers;
    UITableViewCell *selectedCell;
}

@property (nonatomic) PDU *pdu;

-(void)addNewItem;

@end
