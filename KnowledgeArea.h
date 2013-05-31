//
//  KnowledgeArea.h
//  PDUKeeper
//
//  Created by James Abendroth on 3/20/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PDU;

@interface KnowledgeArea : NSManagedObject

@property (nonatomic, retain) NSString * areaName;
@property (nonatomic, retain) PDU *pdu;

@end
