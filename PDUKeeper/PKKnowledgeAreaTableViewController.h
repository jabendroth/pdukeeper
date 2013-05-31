//
//  PKKnowledgeAreaTableViewController.h
//  PDUKeeper
//
//  Created by James Abendroth on 3/20/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKTableViewController.h"

@class PDU;

@interface PKKnowledgeAreaTableViewController : PKTableViewController
{
    NSArray *knowledgeAreas;
}

@property (weak, atomic) PDU *pdu;

@end
