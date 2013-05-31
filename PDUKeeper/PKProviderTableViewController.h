//
//  PKProviderTableViewController.h
//  PDUKeeper
//
//  Created by James Abendroth on 4/20/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKTableViewController.h"
#import "PKTableRefreshDelegate.h"

@class PDUProvider;

@interface PKProviderTableViewController : PKTableViewController <PKTableRefreshDelegate>
{
    NSArray *providers;
}

-(void)addNewItem;
-(void)refreshTable;

@end
