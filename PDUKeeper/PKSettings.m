//
//  PKArchiver.m
//  PDUKeeper
//
//  Created by James Abendroth on 4/9/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import "PKSettings.h"

@implementation PKSettings

@synthesize expirationDate;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self){
        expirationDate = [aDecoder decodeObjectForKey:@"expirationDate"];
        _enableReminderYearly = [aDecoder decodeBoolForKey:@"enableReminderYearly"];
        _enableReminderBiYearly = [aDecoder decodeBoolForKey:@"enableReminderBiYearly"];
        _enableReminderMonthly = [aDecoder decodeBoolForKey:@"enableReminderMonthly"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:expirationDate forKey:@"expirationDate"];
    [aCoder encodeBool:_enableReminderYearly forKey:@"enableReminderYearly"];
    [aCoder encodeBool:_enableReminderBiYearly forKey:@"enableReminderBiYearly"];
    [aCoder encodeBool:_enableReminderMonthly forKey:@"enableReminderMontly"];
}

-(NSDate*)expirationDate
{
    return expirationDate;
}

-(void)setExpirationDate:(NSDate *)date
{
    expirationDate = date;
    // Redo all of the reminders based on the new expiration date.
    [self setupNotifications];
}

-(void)setupNotifications
{
    NSDate *dt;
    UIApplication *app = [UIApplication sharedApplication];
    [app cancelAllLocalNotifications];
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    [notification setAlertBody:@"Your certification deadline is approaching"];
    [notification setAlertAction:@"view progress"];
    [notification setApplicationIconBadgeNumber:1];
    
    if ([self enableReminderMonthly]){
        
        for (int i=1 ; i<=(12*3) ; i++){
            
            if (!dt){
                dt = [expirationDate dateByAddingTimeInterval:-1*ONE_MONTH_NUM_SECONDS];
            } else {
                dt = [dt dateByAddingTimeInterval:-1*ONE_MONTH_NUM_SECONDS];
            }
            
            if ([dt compare:[NSDate date]] == NSOrderedAscending){
                NSLog(@"EM: %@ is older than now, not registering", dt);
                break;
            }

            dt = [self fixDate:dt];
            NSLog(@"EM: Registering %@", dt);
            
            [notification setFireDate:dt];
            [app scheduleLocalNotification:notification];
            
        }
        
    }
    
    dt = nil;

    // Six-month reminders will hit yearly reminders, so we'll do them next.
    if ([self enableReminderBiYearly] && ![self enableReminderMonthly]){
        
        for (int i=1 ; i<=6 ; i++){
            if (!dt){
                dt = [expirationDate dateByAddingTimeInterval:-1*SIX_MONTHS_NUM_SECONDS];
            } else {
                dt = [dt dateByAddingTimeInterval:-1*SIX_MONTHS_NUM_SECONDS];
            }
            
            if ([dt compare:[NSDate date]] == NSOrderedAscending){
                NSLog(@"6M: %@ is older than now, not registering", dt);
                break;
            }

            NSLog(@"6M: Registering %@", dt);
            dt = [self fixDate:dt];
            NSLog(@"6M: Registering %@", dt);
            
            [notification setFireDate:dt];
            [app scheduleLocalNotification:notification];
        }
        
    }
    
    dt = nil;
    
    // Only setup yearly reminders if six-month reminders are disabled.
    // Yearly reminders will be covered in the six-month reminders.
    if ([self enableReminderYearly] && ![self enableReminderBiYearly] && ![self enableReminderMonthly]){
        for (int i=1 ; i<=3 ; i++){
            if (!dt){
                dt = [expirationDate dateByAddingTimeInterval:-1*YEAR_NUM_SECONDS];
            } else {
                dt = [dt dateByAddingTimeInterval:-1*YEAR_NUM_SECONDS];
            }
            
            if ([dt compare:[NSDate date]] == NSOrderedAscending){
                NSLog(@"1Y: %@ is older than now, not registering", dt);
                break;
            }
            
            dt = [self fixDate:dt];
            NSLog(@"1Y: Registering %@", dt);
            
            [notification setFireDate:dt];
            [app scheduleLocalNotification:notification];
        }
    }
    
}

/*
 Fixes dates so that the reminder time is always at noon.
 (we don't want to wake people up at 2am)
*/
-(NSDate*)fixDate:(NSDate*)dt
{
    int hours;
    NSCalendar *sysCalendar;
    unsigned int unitFlags;
    
    sysCalendar = [NSCalendar currentCalendar];
    unitFlags = NSHourCalendarUnit;
    
    NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:dt];
    NSLog(@"components: %@", breakdownInfo);
    
    if ([breakdownInfo hour] < 12){
        hours = 12 - [breakdownInfo hour];
        dt = [dt dateByAddingTimeInterval:(([breakdownInfo hour]+hours)*SECONDS_PER_HOUR)];
    } else if ([breakdownInfo hour] > 12){
        hours = [breakdownInfo hour] - 12;
        dt = [dt dateByAddingTimeInterval:(([breakdownInfo hour]-hours)*SECONDS_PER_HOUR)];
    }
    return dt;
}

-(void)setEnableReminderBiYearly:(BOOL)enableReminderBiYearly
{
    _enableReminderBiYearly = enableReminderBiYearly;
    [self setupNotifications];
}

-(void)setEnableReminderYearly:(BOOL)enableReminderYearly
{
    _enableReminderYearly = enableReminderYearly;
    [self setupNotifications];
}

-(void)setEnableReminderMonthly:(BOOL)enableReminderMonthly
{
    _enableReminderMonthly = enableReminderMonthly;
    [self setupNotifications];
}

@end
