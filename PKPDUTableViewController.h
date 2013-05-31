//
//  PKPDUTableViewController.h
//  PDUKeeper
//
//  Created by James Abendroth on 3/8/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKTableViewController.h"

@class PKCoreData;

@interface PKPDUTableViewController : PKTableViewController <NSFetchedResultsControllerDelegate>
{
    PKCoreData *data;
    NSArray *categories;
    NSFetchedResultsController *frc;
}

-(IBAction)addNewItem:(id)sender;
-(void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath;

@end
