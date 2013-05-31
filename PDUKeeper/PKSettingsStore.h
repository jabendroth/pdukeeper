//
//  PKSettingsStore.h
//  PDUKeeper
//
//  Created by James Abendroth on 4/9/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PKSettings;

@interface PKSettingsStore : NSObject
{
    //
}

@property (atomic) PKSettings *settings;

+(PKSettingsStore*)sharedStore;
-(NSString*)itemArchivePath;
-(BOOL)saveChanges;

@end
