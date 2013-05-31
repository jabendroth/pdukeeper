//
//  PKDataExporter.h
//  PDUKeeper
//
//  Created by James Abendroth on 5/1/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

//#define TEMP_CSV @"temp.csv"

@interface PKDataExporter : NSObject
{
    //
}

-(NSData*)getPduCsv;

/*
-(BOOL)writeLineToFile:(NSString*)line;
-(NSString*)csvPath;
*/

@end
