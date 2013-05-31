//
//  MyGuideCoreData.m
//  myGuide
//
//  Created by James Abendroth on 3/1/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import "PKCoreData.h"

#import "PDUCategory.h"
#import "Process.h"
#import "PDU.h"
#import "KnowledgeArea.h"
#import "Industry.h"

@implementation PKCoreData

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+(PKCoreData*)sharedStore
{
    static PKCoreData *store;
    
    if (!store){
        store = [[super allocWithZone:nil] init];
    }
    
    return store;
}

+(id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PDUKeeper" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"pduKeeper.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        
        if ([error code] == NSPersistentStoreIncompatibleVersionHashError){
            //[[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        }
        
        abort();
    }
    
    return _persistentStoreCoordinator;
}

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(PDU*)newPDU
{
    PDU *pdu;
    pdu = [NSEntityDescription insertNewObjectForEntityForName:@"PDU"
                                        inManagedObjectContext:_managedObjectContext];
    return pdu;
}

-(PDUProvider*)newProvider
{
    PDUProvider *provider;
    provider = [NSEntityDescription insertNewObjectForEntityForName:@"PDUProvider"
                                             inManagedObjectContext:_managedObjectContext];
    return provider;
}

-(void)deleteManagedObject:(NSManagedObject*)obj doSaveContext:(BOOL)saveContext
{
    [[self managedObjectContext] deleteObject:obj];
    
    if (saveContext){
        [self saveContext];
    }
}

-(void)deletePdu:(PDU*)p doSaveContext:(BOOL)saveContext
{
    [self deleteManagedObject:p doSaveContext:saveContext];
}

-(NSFetchedResultsController*)getPDUFetchedResults :(id)delegate
{
    NSFetchRequest *request;
    NSFetchedResultsController *frc;
    NSSortDescriptor *sd;
    NSEntityDescription *ed;
    NSArray *sortDescriptors;
    NSError *error;
    
    request = [[NSFetchRequest alloc] init];
    [request setRelationshipKeyPathsForPrefetching:[NSArray arrayWithObject:@"categoryName"]];
    
    ed = [[[self managedObjectModel] entitiesByName] objectForKey:@"PDU"];
    [request setEntity:ed];
    
    sd = [[NSSortDescriptor alloc] initWithKey:@"pduCategory.categoryName" ascending:YES];
    sortDescriptors = [[NSArray alloc] initWithObjects:sd, nil];
        
    [request setSortDescriptors:sortDescriptors];
        
    frc = [[NSFetchedResultsController alloc]
                                                  initWithFetchRequest:request
                                                  managedObjectContext:[self managedObjectContext]
                                                  sectionNameKeyPath:@"pduCategory.categoryName"
                                                  cacheName:nil];
        
        
    //BOOL success = [frc performFetch:&error];
    [frc setDelegate:delegate];
    [frc performFetch:&error];
    return frc;
    
}

-(NSArray *)allPduCategories
{
    PDUCategory *category;
    NSFetchRequest *request;
    NSEntityDescription *ed;
    NSSortDescriptor *sd;
    NSError *error;
    int sortId = 1;
    
    if (!pduCategories) {
        
        request = [[NSFetchRequest alloc] init];
        ed = [[[self managedObjectModel] entitiesByName] objectForKey:@"PDUCategory"];
        [request setEntity:ed];
        
        sd = [NSSortDescriptor sortDescriptorWithKey:@"sortId" ascending:YES];
        [request setSortDescriptors:[NSArray arrayWithObject:sd]];
        
        NSArray *result = [[self managedObjectContext] executeFetchRequest:request error:&error];
        
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        pduCategories = [result mutableCopy];
    }
    
    // Add the categories to the DB if this is the first run.
    if ([pduCategories count] == 0) {
        NSLog(@"Adding categories for the first time.");
        
        NSArray *categories = [[NSArray alloc] initWithObjects:@"Category A",
                               @"Category B",
                               @"Category C",
                               @"Category D",
                               @"Category E",
                               @"Category F", nil];
        
        NSArray *descriptions = [[NSArray alloc] initWithObjects:@"Courses offered by PMI's R.E.P.s or Chapters and Communities",
                                 @"Continuing Education",
                                 @"Self-Directed Learning",
                                 @"Creating New Project Management Knowledge",
                                 @"Volunteer Service",
                                 @"Work as a Practitioner", nil];

        for (int i=0 ; i<[categories count] ; i++){
            category = [NSEntityDescription insertNewObjectForEntityForName:@"PDUCategory" inManagedObjectContext:[self managedObjectContext]];
            
            [category setCategoryName:[categories objectAtIndex:i]];
            [category setCategoryDescription:[descriptions objectAtIndex:i]];
            
            [category setSortId:[[NSNumber alloc] initWithInt:sortId]];
            [pduCategories addObject:category];
            sortId++;
        }
        [self saveContext];
        
    }
    
    return pduCategories;
}

-(NSArray*)allProviders
{
    NSFetchRequest *request;
    NSEntityDescription *ed;
    //NSSortDescriptor *sd;
    NSError *error;
    
    request = [[NSFetchRequest alloc] init];
    ed = [[[self managedObjectModel] entitiesByName] objectForKey:@"PDUProvider"];
    [request setEntity:ed];
    
    NSArray *result = [[self managedObjectContext] executeFetchRequest:request error:&error];
    
    if (!result) {
        [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
    }
    
    providers = [result mutableCopy];
    
    return providers;
}

-(NSArray *)allProcesses
{
    Process *process;
    NSFetchRequest *request;
    NSEntityDescription *ed;
    NSSortDescriptor *sd;
    NSError *error;
    int sortId = 1;
    
    if (!processes) {
        request = [[NSFetchRequest alloc] init];
        ed = [[[self managedObjectModel] entitiesByName] objectForKey:@"Process"];
        [request setEntity:ed];
        
        sd = [NSSortDescriptor sortDescriptorWithKey:@"sortId" ascending:YES];
        [request setSortDescriptors:[NSArray arrayWithObject:sd]];
        
        NSArray *result = [[self managedObjectContext] executeFetchRequest:request error:&error];
        
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        processes = [result mutableCopy];
    }
    
    // Add the processes to the DB if this is the first run.
    if ([processes count] == 0) {
        NSLog(@"Adding processes for the first time.");
        
        NSArray *processLabels = [[NSArray alloc] initWithObjects:@"Initiating", @"Planning", @"Executing", @"Controlling", @"Closing", nil];
        
        for (NSString *proc in processLabels){
            process = [NSEntityDescription insertNewObjectForEntityForName:@"Process" inManagedObjectContext:[self managedObjectContext]];
            [process setProcessName:proc];
            [process setSortId:[[NSNumber alloc] initWithInt:sortId]];
            [processes addObject:process];
            sortId++;
        }
        [self saveContext];
    }
    
    return processes;
    
}

-(NSArray *)allKnowledgeAreas
{
    KnowledgeArea *area;
    NSFetchRequest *request;
    NSEntityDescription *ed;
    NSSortDescriptor *sd;
    NSError *error;
    
    if (!knowledgeAreas) {
        
        request = [[NSFetchRequest alloc] init];
        ed = [[[self managedObjectModel] entitiesByName] objectForKey:@"KnowledgeArea"];
        [request setEntity:ed];
        
        sd = [NSSortDescriptor sortDescriptorWithKey:@"areaName" ascending:YES];
        [request setSortDescriptors:[NSArray arrayWithObject:sd]];
        
        NSArray *result = [[self managedObjectContext] executeFetchRequest:request error:&error];
        
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        knowledgeAreas = [result mutableCopy];
    }
    
    // Add the categories to the DB if this is the first run.
    if ([knowledgeAreas count] == 0) {
        NSLog(@"Adding knowledge areas for the first time.");
        
        NSArray *areas = [[NSArray alloc] initWithObjects:@"Project Communications Management",
                          @"Project Human Resources Management",
                          @"Project Procurement Management",
                          @"Project Risk Management",
                          @"Project Time Management",
                          @"Project Cost Management",
                          @"Project Integrations Management",
                          @"Project Quality Management",
                          @"Project Scope Management",
                          nil];
        
        for (NSString *a_str in areas){
            area = [NSEntityDescription insertNewObjectForEntityForName:@"KnowledgeArea" inManagedObjectContext:[self managedObjectContext]];
            [area setAreaName:a_str];
            [knowledgeAreas addObject:area];
        }
        [self saveContext];
    }
    
    return knowledgeAreas;
}

-(NSArray*)allIndustries
{
    Industry *is;
    NSFetchRequest *request;
    NSEntityDescription *ed;
    NSSortDescriptor *sd;
    NSError *error;
    
    if (!industries){
        
        request = [[NSFetchRequest alloc] init];
        ed = [[[self managedObjectModel] entitiesByName] objectForKey:@"Industry"];
        [request setEntity:ed];
        
        sd = [NSSortDescriptor sortDescriptorWithKey:@"industryName" ascending:YES];
        [request setSortDescriptors:[NSArray arrayWithObject:sd]];
        
        NSArray *result = [[self managedObjectContext] executeFetchRequest:request error:&error];
        
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        industries = [result mutableCopy];
        
    }
    
    // Add industries on first run.
    if ([industries count] == 0){
        NSLog(@"Adding industries for the first time.");
        
        NSArray *industry_names = [[NSArray alloc] initWithObjects:@"Aerospace & Defense",
                                   @"Communications",
                                   @"Design-Procurement-Construction",
                                   @"E-Business",
                                   @"Environmental Mgmt",
                                   @"Government",
                                   @"Human Resources",
                                   @"International Development",
                                   @"Manufacturing",
                                   @"Metrics",
                                   @"Oil, Gas, Petrochemical",
                                   @"Pharmaceutical",
                                   @"Quality In Project Mgmt",
                                   @"Risk Mgmt",
                                   @"Service & Outsourcing",
                                   @"Troubled Projects",
                                   @"Women in Project Mgmt",
                                   @"Automation Systems",
                                   @"Consulting",
                                   @"Diversity",
                                   @"Education & Training",
                                   @"Financial Services",
                                   @"Healthcare",
                                   @"Information Systems",
                                   @"IT & Telecom",
                                   @"Marketing & Sales",
                                   @"New Product Development",
                                   @"Performance Mgnt",
                                   @"PMO",
                                   @"Retail",
                                   @"Scheduling",
                                   @"Students of PM",
                                   @"Utility",
                       nil];
        
        for (NSString *i in industry_names){
            is = [NSEntityDescription insertNewObjectForEntityForName:@"Industry" inManagedObjectContext:[self managedObjectContext]];
            
            [is setIndustryName:i];
            [industries addObject:is];
        }
        [self saveContext];
    }

    return industries;
}

-(NSNumber*)totalHoursEarned
{
    NSFetchRequest *request;
    NSEntityDescription *ed;
    NSError *error;
    NSMutableArray *pdus_temp;
    NSNumber *total;
    float f = 0.0;
    
    request = [[NSFetchRequest alloc] init];
    ed = [[[self managedObjectModel] entitiesByName] objectForKey:@"PDU"];
    [request setEntity:ed];
    
    NSArray *result = [[self managedObjectContext] executeFetchRequest:request error:&error];
    
    if (!result) {
        [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
    }
    
    pdus_temp = [result mutableCopy];
    
    if (pdus_temp){
        
        for (PDU *p in pdus_temp) {
            f += [[p pduHours] floatValue];
        }
    
    }
    
    total = [NSNumber numberWithFloat:f];
    
    return total;
}

@end
