//
//  PDUProvider.h
//  PDUKeeper
//
//  Created by James Abendroth on 4/20/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PDU;

@interface PDUProvider : NSManagedObject

@property (nonatomic, retain) NSString * providerAddress1;
@property (nonatomic, retain) NSString * providerAddress2;
@property (nonatomic, retain) NSString * providerCity;
@property (nonatomic, retain) NSString * providerName;
@property (nonatomic, retain) NSString * providerState;
@property (nonatomic, retain) NSString * providerZip;
@property (nonatomic, retain) NSSet *pdu;
@end

@interface PDUProvider (CoreDataGeneratedAccessors)

- (void)addPduObject:(PDU *)value;
- (void)removePduObject:(PDU *)value;
- (void)addPdu:(NSSet *)values;
- (void)removePdu:(NSSet *)values;

@end
