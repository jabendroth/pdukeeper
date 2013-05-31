//
//  GDTView.m
//  GraphDrawTest
//
//  Created by James Abendroth on 3/4/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import "GraphView.h"
#import "PKCoreData.h"
#import "globals.h"
#import "PKSettingsStore.h"
#import "PKSettings.h"
#import "HeaderFooterLabel.h"

@implementation GDTView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"drawing-2-1.png"]]];
        data = [PKCoreData sharedStore];
    }
    return self;
}

-(NSString*)getTimeString:(float)hours
{
    float todo;
    NSDate *expirationDate;
    PKSettingsStore *store = [PKSettingsStore sharedStore];
    
    if (hours >= MAX_PDUS_PER_PERIOD){
        return @"Congratulations! You have earned the required PDUs for this period.";
    } else {
        expirationDate = [[store settings] expirationDate];
        
        NSTimeInterval expInterval = [expirationDate timeIntervalSinceNow];
        
        NSCalendar *sysCalendar = [NSCalendar currentCalendar];

        NSDate *date1 = [[NSDate alloc] init];
        NSDate *date2 = [[NSDate alloc] initWithTimeInterval:expInterval sinceDate:date1];
        
        // Get conversion to months, days, hours, minutes
        unsigned int unitFlags = NSYearCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit;
        
        NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:date1  toDate:date2  options:0];

        todo = MAX_PDUS_PER_PERIOD - hours;
        if ([breakdownInfo year] > 0){
            return [NSString stringWithFormat:@"You have %d year%@, %d month%@, and %d day%@ to complete %.2f PDUs",
                    [breakdownInfo year], (([breakdownInfo year] != 1) ? @"s" : @""),
                    [breakdownInfo month], (([breakdownInfo month] != 1) ? @"s" : @""),
                    [breakdownInfo day], (([breakdownInfo day] != 1) ? @"s" : @""),
                    todo];
        } else if ([breakdownInfo year] <=0 && [breakdownInfo month] > 0){
            return [NSString stringWithFormat:@"You have %d month%@ and %d day%@ to complete %.2f PDUs",
                    [breakdownInfo month], (([breakdownInfo month] != 1) ? @"s" : @""),
                    [breakdownInfo day], (([breakdownInfo day] != 1) ? @"s" : @""),
                    todo];
        } else {
            return [NSString stringWithFormat:@"You have %d day%@ to complete %.2f PDUs",
                    ([breakdownInfo day] < 0) ? 0 : [breakdownInfo day],
                    (([breakdownInfo day] != 1) ? @"s" : @""),
                    todo];
        }
        
    }
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    int width;
    float hours;
    NSString *message_line1;
    NSString *message_line2;
    CGRect labelFrame;
    
    width = self.bounds.size.width;
    
    hours = [[data totalHoursEarned] floatValue];
    
    NSLog(@"Draw Rect");
    [self drawGraphAxes];
    [self drawGraphTicksX];
    [self drawGraphTicksY];
    [self drawGraph:hours];
    
    if (!statusLabel){
        labelFrame = CGRectMake(20, 210, width-40, 130);
        statusLabel = [[HeaderFooterLabel alloc] initWithFrame:labelFrame];
        
        [statusLabel setNumberOfLines:0];
        [statusLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [statusLabel setTextAlignment:NSTextAlignmentCenter];
        
        [self addSubview:statusLabel];
    }
    
    if (!yearLabel){
        labelFrame = CGRectMake(20, 180, width-40, 20);
        yearLabel = [[UILabel alloc] initWithFrame:labelFrame];

        [yearLabel setText:@"YEAR"];
        [yearLabel setTextAlignment:NSTextAlignmentCenter];
        [yearLabel setBackgroundColor:[UIColor clearColor]];
        [yearLabel setFont:[UIFont systemFontOfSize:12]];
        [yearLabel setShadowColor:[UIColor grayColor]];
        [yearLabel setShadowOffset:CGSizeMake(0, 1)];
        
        [self addSubview:yearLabel];
    }
    
    if (!pduLabel){
        labelFrame = CGRectMake(10, 2, 40, 20);
        pduLabel = [[UILabel alloc] initWithFrame:labelFrame];
        
        [pduLabel setText:@"PDUs"];
        [pduLabel setBackgroundColor:[UIColor clearColor]];
        [pduLabel setFont:[UIFont systemFontOfSize:11]];
        [pduLabel setShadowColor:[UIColor grayColor]];
        [pduLabel setShadowOffset:CGSizeMake(0, 1)];
        
        [self addSubview:pduLabel];
        
    }
    
    if (!goalLabel){
        labelFrame = CGRectMake(width-40, 2, 40, 20);
        goalLabel = [[UILabel alloc] initWithFrame:labelFrame];
        
        [goalLabel setText:@"GOAL"];
        [goalLabel setBackgroundColor:[UIColor clearColor]];
        [goalLabel setFont:[UIFont systemFontOfSize:11]];
        [goalLabel setShadowColor:[UIColor grayColor]];
        [goalLabel setShadowOffset:CGSizeMake(0, 1)];
        
        [self addSubview:goalLabel];
    }
        
    message_line1 = [NSString stringWithFormat:@"You have earned %.2f of the %.0f required PDUs", hours, MAX_PDUS_PER_PERIOD];
    message_line2 = [self getTimeString:hours];
    
    [statusLabel setText:[NSString stringWithFormat:@"%@\n\n%@", message_line1, message_line2]];
    
}

-(void)drawGraphAxes
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    int x_start = [self bounds].origin.x + GRAPH_MARGIN;
    int y_start = [self bounds].size.height - GRAPH_MARGIN;
    
    int x_finish = [self bounds].size.width - GRAPH_MARGIN;
    int y_finish = [self bounds].origin.y + (GRAPH_HEIGHT-GRAPH_MARGIN);
    
    CGContextSetLineWidth(ctx, 2);
    CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 1.0);
    
    // X-axis
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, x_start, y_start);
    
    CGContextAddLineToPoint(ctx, x_finish, y_finish);
    CGContextStrokePath(ctx);
    
    // Y-axis
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, x_start, y_start);
    
    CGContextAddLineToPoint(ctx, x_start, GRAPH_MARGIN);
    CGContextStrokePath(ctx);
}

-(void)drawGraphTicksX
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIFont *font;
    CGRect textRect;
    int y_finish = [self bounds].origin.y+([self bounds].size.height-GRAPH_MARGIN);
    int num_x_marks = 3;
    double mark, graph_width;
    CGFloat dashes[] = { 3, 2 };
    
    graph_width = [self bounds].size.width-(GRAPH_PADDING*2);
    font = [UIFont boldSystemFontOfSize:12];
    
    CGContextSetLineWidth(ctx, 2);
    
    for (int i=0 ; i<=num_x_marks ; i++){
        
        mark = ((graph_width*i)/num_x_marks)+GRAPH_PADDING;
        CGContextSetLineDash(ctx, 0, nil, 0);
        
        // Draw each tick mark
        CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 1.0);
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, (int)mark, y_finish+TICK_LENGTH);
        
        CGContextAddLineToPoint(ctx, (int)mark, y_finish-TICK_LENGTH);
        CGContextStrokePath(ctx);
        
        // Draw the year number on each tick mark.
        NSString *yearString = [NSString stringWithFormat:@"%d", i];
        textRect.size = [yearString sizeWithFont:font];
        
        textRect.origin.x = (int)mark-(textRect.size.width/2);
        textRect.origin.y = y_finish+5;
        
        [yearString drawInRect:textRect withFont:font];
        
        // Draw some dashed lines above the ticks.
        if (i==0)
            continue;
        
        CGContextSetRGBStrokeColor(ctx, 0.8, 0.8, 0.8, 1.0);
        CGContextMoveToPoint(ctx, (int)mark, y_finish-TICK_LENGTH);
        CGContextSetLineDash(ctx, 2, dashes, 2);
        CGContextAddLineToPoint(ctx, (int)mark, GRAPH_MARGIN);
        CGContextStrokePath(ctx);
    }
}

-(void)drawGraphTicksY
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    int y_start = [self bounds].size.height-(GRAPH_MARGIN);
    int x_start = GRAPH_MARGIN;
    int num_y_marks = 4; // 0, 20, 40, 60
    double mark;
    UIFont *font;
    CGRect textRect;
    
    font = [UIFont boldSystemFontOfSize:12];
    
    CGContextSetLineWidth(ctx, 2);
    CGContextSetRGBStrokeColor(ctx, 1.0, 0, 0, 1.0);
    CGContextSetLineDash(ctx, 0, nil, 0);
    
    mark = (([self bounds].size.height-(GRAPH_PADDING*2))/(num_y_marks-1));
    
    // Start at 1 so as not to draw the first tick (we already have a 0)
    for (int i=1 ; i<num_y_marks ; i++){
        
        CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 1.0);
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, x_start, y_start-(mark*i));
        
        CGContextAddLineToPoint(ctx, x_start-5, y_start-(mark*i));
        CGContextStrokePath(ctx);
        
        NSString *pduString = [NSString stringWithFormat:@"%d", (i*20)];
        textRect.size = [pduString sizeWithFont:font];
        
        textRect.origin.x = 5;
        textRect.origin.y = y_start-(mark*i)-(textRect.size.height/2);
        
        [pduString drawInRect:textRect withFont:font];
    }
    
}

-(void)drawGraph:(float)hours
{
    
    if (hours == 0){
        return;
    }
    
    hours = (hours > MAX_PDUS_PER_PERIOD) ? MAX_PDUS_PER_PERIOD : hours;
    
    int graph_height = [self bounds].size.height - (GRAPH_MARGIN*2);
    
    int x_start = [self bounds].origin.x+GRAPH_MARGIN+LINE_PADDING;
    int y_start = [self bounds].origin.y+(graph_height+GRAPH_MARGIN)-LINE_PADDING;
    
    int x_end = x_start+[self getYearLineX];
    int y_end = y_start - (graph_height*(hours/MAX_PDUS_PER_PERIOD)) + LINE_PADDING;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat red, green, blue;
    
    float slope = (float)abs(y_end-y_start)/(float)abs(x_end-x_start);
    
    //NSLog(@"Slope: %.5f", slope);
    
    // TODO: line color with 20 PDUs/year?
    // return (int)(graph_width*(1-pct))-LINE_PADDING;
    
    if (slope >= 0.5){
        red = 0.3;
        green = 0.8;
        blue = 0.3;
    } else if (slope < 0.5 && slope > 0.3){
        red = 1;
        green = 1;
        blue = 0.3;
    } else {
        red = 0.8;
        green = 0.1;
        blue = 0.1;
    }
    
    CGContextSetLineWidth(ctx, 6);
    CGContextSetRGBStrokeColor(ctx, red, green, blue, 1.0);
    CGContextSetRGBFillColor(ctx, red, green, blue, 1.0);
    CGContextSetLineDash(ctx, 0, nil, 0);
    
    // Draw the line
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, x_start, y_start);
    
    CGContextAddLineToPoint(ctx, x_end, y_end);
    CGContextStrokePath(ctx);
    
    // Draw a circle at the beginning
    CGContextAddArc(ctx, x_start, y_start, 2.7, 0.0, M_PI * 2.0, YES);
    CGContextStrokePath(ctx);
    
    // Draw a circle at the end
    CGContextAddArc(ctx, x_end, y_end, 2.7, 0.0, M_PI * 2.0, YES);
    CGContextStrokePath(ctx);
    
}

-(int)getYearLineX
{
    // Start date is three years prior to expiration date.
    NSDate *expirationDate, *startDate;
    PKSettingsStore *store = [PKSettingsStore sharedStore];
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    NSDateComponents *comps;
    double seconds_3_years = (365*3*24*60*60);
    double graph_width;
    
    graph_width = [self bounds].size.width-(GRAPH_PADDING*2);
    
    expirationDate = [[store settings] expirationDate];
    comps = [sysCalendar components:(NSWeekdayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit) fromDate:expirationDate];
    [comps setYear: [comps year]-3];
    
    startDate = [sysCalendar dateFromComponents:comps];
    
    /*
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    NSLog(@"Date: %@", [dateFormatter stringFromDate:startDate]);
    */
    
    NSTimeInterval diff = [expirationDate timeIntervalSinceNow] - [[NSDate date] timeIntervalSinceNow];
    
    NSLog(@"diff: %f", diff);
    
    float pct = diff/seconds_3_years;
    
    NSLog(@"diff %f", pct);
    pct = (pct<0) ? 0 : pct;
    return (int)(graph_width*(1-pct))-LINE_PADDING;
}

@end
