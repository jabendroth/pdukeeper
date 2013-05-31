//
//  PDUCategory.h
//  PDUKeeper
//
//  Created by James Abendroth on 4/7/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PDU;

@interface PDUCategory : NSManagedObject

@property (nonatomic, retain) NSString * categoryDescription;
@property (nonatomic, retain) NSNumber * categoryMax;
@property (nonatomic, retain) NSString * categoryName;
@property (nonatomic, retain) NSNumber * sortId;
@property (nonatomic, retain) NSSet *pdu;
@end

@interface PDUCategory (CoreDataGeneratedAccessors)

- (void)addPduObject:(PDU *)value;
- (void)removePduObject:(PDU *)value;
- (void)addPdu:(NSSet *)values;
- (void)removePdu:(NSSet *)values;

@end
