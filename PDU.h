//
//  PDU.h
//  PDUKeeper
//
//  Created by James Abendroth on 5/16/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Industry, KnowledgeArea, PDUCategory, PDUProvider, Process;

@interface PDU : NSManagedObject

@property (nonatomic, retain) NSDate * dateCompleted;
@property (nonatomic, retain) NSDate * dateEntered;
@property (nonatomic, retain) NSDate * dateStarted;
@property (nonatomic, retain) NSNumber * pduHours;
@property (nonatomic, retain) NSString * pduTitle;
@property (nonatomic, retain) NSString * componentId;
@property (nonatomic, retain) PDUCategory *pduCategory;
@property (nonatomic, retain) Industry *pduIndustry;
@property (nonatomic, retain) NSSet *pduKnowledgeAreas;
@property (nonatomic, retain) NSSet *pduProcesses;
@property (nonatomic, retain) PDUProvider *pduProvider;
@end

@interface PDU (CoreDataGeneratedAccessors)

- (void)addPduKnowledgeAreasObject:(KnowledgeArea *)value;
- (void)removePduKnowledgeAreasObject:(KnowledgeArea *)value;
- (void)addPduKnowledgeAreas:(NSSet *)values;
- (void)removePduKnowledgeAreas:(NSSet *)values;

- (void)addPduProcessesObject:(Process *)value;
- (void)removePduProcessesObject:(Process *)value;
- (void)addPduProcesses:(NSSet *)values;
- (void)removePduProcesses:(NSSet *)values;

@end
