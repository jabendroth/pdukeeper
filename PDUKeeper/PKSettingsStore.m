//
//  PKSettingsStore.m
//  PDUKeeper
//
//  Created by James Abendroth on 4/9/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import "PKSettingsStore.h"
#import "PKSettings.h"

@implementation PKSettingsStore

-(id)init
{
    self = [super init];
    if (self){
        NSString *path = [self itemArchivePath];
        _settings = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        if (!_settings){
            NSLog(@"Initializing settings");
            _settings = [[PKSettings alloc] init];
        }
        
    }
    return self;
}

+(PKSettingsStore*)sharedStore
{
    static PKSettingsStore *store;
    
    if (!store){
        store = [[super allocWithZone:nil] init];
    }
    
    return store;
}

+(id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

-(NSString*)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
}

-(BOOL)saveChanges
{
    NSString *path = [self itemArchivePath];
    return [NSKeyedArchiver archiveRootObject:_settings toFile:path];
}

@end
