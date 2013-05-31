//
//  GDTView.h
//  GraphDrawTest
//
//  Created by James Abendroth on 3/4/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PKCoreData, HeaderFooterLabel;

#define GRAPH_HEIGHT    200
#define GRAPH_PADDING   25
#define GRAPH_MARGIN    25
#define TICK_LENGTH     5
#define LINE_PADDING    10

@interface GDTView : UIView
{
    PKCoreData *data;
    HeaderFooterLabel *statusLabel;
    UILabel *yearLabel;
    UILabel *pduLabel;
    UILabel *goalLabel;
}

-(void)drawGraphAxes;
-(void)drawGraphTicksX;
-(void)drawGraphTicksY;
-(void)drawGraph:(float)hours;

-(NSString*)getTimeString:(float)hours;
-(int)getYearLineX;

@end
