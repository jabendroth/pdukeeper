//
//  MyGuideCoreData.h
//  myGuide
//
//  Created by James Abendroth on 3/1/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PDU, PDUProvider;

@interface PKCoreData : NSObject
{
    NSMutableArray *pdus;
    NSMutableArray *pduCategories;
    NSMutableArray *processes;
    NSMutableArray *knowledgeAreas;
    NSMutableArray *industries;
    NSMutableArray *providers;
}

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(void)saveContext;
-(NSURL *)applicationDocumentsDirectory;
+(PKCoreData*)sharedStore;

-(NSArray*)allPduCategories;
-(NSArray*)allProcesses;
-(NSArray*)allKnowledgeAreas;
-(NSArray*)allIndustries;
-(NSArray*)allProviders;

-(NSNumber*)totalHoursEarned;

-(NSFetchedResultsController*)getPDUFetchedResults :(id)delegate;

// Data Object accessors
-(PDU*)newPDU;
-(PDUProvider*)newProvider;

-(void)deletePdu:(PDU*)p doSaveContext:(BOOL)saveContext;
-(void)deleteManagedObject:(NSManagedObject*)obj doSaveContext:(BOOL)saveContext;

@end
