//
//  Industry.h
//  PDUKeeper
//
//  Created by James Abendroth on 3/29/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PDU;

@interface Industry : NSManagedObject

@property (nonatomic, retain) NSString * industryName;
@property (nonatomic, retain) PDU *pdu;

@end
