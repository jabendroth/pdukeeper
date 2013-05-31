//
//  PKDataExporter.m
//  PDUKeeper
//
//  Created by James Abendroth on 5/1/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import "PKDataExporter.h"
#import <MessageUI/MessageUI.h>
#import "PKCoreData.h"

#import "PDU.h"
#import "Industry.h"
#import "KnowledgeArea.h"
#import "Process.h"
#import "PDUProvider.h"

@implementation PKDataExporter

-(NSData*)getPduCsv
{
    NSMutableString *csvStr;
    NSString *formatStr;
    PKCoreData *data = [PKCoreData sharedStore];
    NSFetchedResultsController *frc = [data getPDUFetchedResults:nil];
    id <NSFetchedResultsSectionInfo> sectionInfo;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM d yyyy"];
    
    csvStr = [[NSMutableString alloc] init];
    formatStr = @"\"\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\"\n";
    
    // Add the header
    [csvStr appendFormat:@"\"Category Name\",\"Program Title/Description\",\"PDU Hours\",\"Start Date\",\"End Date\",\"Processes\",\"Knowledge Areas\",\"Industry\",\"Provider Name\",\"Address Line 1\",\"Address Line 2\",\"City\",\"State\",\"Zip\"\n"];
    
    // Loop through each category and add the PDUs for each category.
    for (int i=0 ; i<[[frc sections] count] ; i++){
        sectionInfo = [[frc sections] objectAtIndex:i];
        
        [csvStr appendFormat:@"%@\n", [sectionInfo name]];
        
        // Loop throug the PDUs for the current category.
        for (int j=0 ; j<[[sectionInfo objects] count] ; j++){
            
            PDU *p = [[sectionInfo objects] objectAtIndex:j];
            
            // Build a knowledge area string.
            NSMutableString *kaStr = nil;
            for (KnowledgeArea *ka in [p pduKnowledgeAreas]) {
                if (!kaStr){
                    kaStr = [[NSMutableString alloc] init];
                    [kaStr appendString:[ka areaName]];
                } else {
                    [kaStr appendFormat:@"/%@", [ka areaName]];
                }
            }
            
            // Build a processes string
            NSMutableString *procStr = nil;
            for (Process *proc in [p pduProcesses]) {
                if (!procStr){
                    procStr = [[NSMutableString alloc] init];
                    [procStr appendString:[proc processName]];
                } else {
                    [procStr appendFormat:@"/%@", [proc processName]];
                }
            }
            
            PDUProvider *provider = [p pduProvider];
            
            [csvStr appendFormat:formatStr,
             [p pduTitle],
             [p pduHours],
             ([p dateStarted] != nil) ? [dateFormatter stringFromDate:[p dateStarted]] : @"",
             ([p dateCompleted] != nil) ? [dateFormatter stringFromDate:[p dateCompleted]] : @"",
             (procStr != nil) ? procStr : @"",
             (kaStr != nil) ? kaStr : @"",
             ([[p pduIndustry] industryName]!= nil) ? [[p pduIndustry] industryName] : @"",
             ([provider providerName] != nil) ? [provider providerName] : @"",
             ([provider providerAddress1] != nil) ? [provider providerAddress1] : @"",
             ([provider providerAddress2] != nil) ? [provider providerAddress2] : @"",
             ([provider providerCity] != nil) ? [provider providerCity] : @"",
             ([provider providerState] != nil) ? [provider providerState] : @"",
             ([provider providerZip] != nil) ? [provider providerZip] : @""
             ];
        }
    
    }
    
    return [csvStr dataUsingEncoding:NSUTF8StringEncoding];
}

/*
-(NSString*)csvPath
{
    return [NSTemporaryDirectory() stringByAppendingPathComponent:TEMP_CSV];
}

-(BOOL)writeLineToFile:(NSString*)line
{
    NSError *error;
    NSString *path = [self csvPath];

    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    if (!fileExists){
        BOOL success = [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
        NSLog(@"success: %@", (success ? @"YES" : @"NO"));
    } else {
        //[line writeToFile:path atomically:YES
        //    encoding:NSUTF8StringEncoding error:&error];
        
        NSFileHandle *fh = [NSFileHandle fileHandleForWritingAtPath:path];
        
        NSLog(@"Unresolved error %@", error);
        [fh writeData:[line dataUsingEncoding:NSUTF8StringEncoding]];
        [fh closeFile];
    }
    
    return YES;
}
*/
 
@end
