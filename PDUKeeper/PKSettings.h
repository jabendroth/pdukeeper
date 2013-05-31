//
//  PKArchiver.h
//  PDUKeeper
//
//  Created by James Abendroth on 4/9/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import <Foundation/Foundation.h>

#define YEAR_NUM_SECONDS (86400*(365))
#define SIX_MONTHS_NUM_SECONDS (86400*(365/2))
#define ONE_MONTH_NUM_SECONDS (86400*30)
#define SECONDS_PER_HOUR (60*60)

@interface PKSettings : NSObject <NSCoding>
{
    //
}

// PMP expiration date
@property (nonatomic, strong) NSDate *expirationDate;

// Time-sensitive reminders
@property (nonatomic) BOOL enableReminderYearly;
@property (nonatomic) BOOL enableReminderBiYearly;
@property (nonatomic) BOOL enableReminderMonthly;

-(void)setupNotifications;

@end
