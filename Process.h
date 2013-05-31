//
//  Process.h
//  PDUKeeper
//
//  Created by James Abendroth on 3/20/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PDU;

@interface Process : NSManagedObject

@property (nonatomic, retain) NSString * processName;
@property (nonatomic, retain) NSNumber * sortId;
@property (nonatomic, retain) PDU *pdu;

@end
