//
//  PKGraphViewController.m
//  PDUKeeper
//
//  Created by James Abendroth on 3/5/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import "PKGraphViewController.h"
#import "GraphView.h"
#import <QuartzCore/QuartzCore.h>
#import "HeaderFooterLabel.h"

@implementation PKGraphViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    CGRect graphViewRect;
    CGRect titleFrame;
    HeaderFooterLabel *titleLabel;
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"Progress"];
        
        UIImage *tabImage = [UIImage imageNamed:@"250-stats.png"];
        [tbi setImage:tabImage];
        
        GDTView *graphView = [[GDTView alloc] init];
        
        graphViewRect.size.width = [[self view] bounds].size.width;
        graphViewRect.size.height = 202;
        
        graphViewRect.origin.x = 0;
        graphViewRect.origin.y = 35;
        
        [graphView setFrame:graphViewRect];
        
        [[self view] addSubview:graphView];
        
        // Add the title label
        titleFrame = CGRectMake(0, 0, [[self view] bounds].size.width, 30);
        titleLabel = [[HeaderFooterLabel alloc] initWithFrame:titleFrame];
        
        [titleLabel setText:@"Progress"];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:25]];
        
        [[self view] addSubview:titleLabel];
        [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"table_bg.png"]]];
        
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    // TODO: Fix this so it doesn't load twice on start.
    [[[[self view] subviews] objectAtIndex:0] setNeedsDisplay];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSLog(@"Graph Rotated");
}

@end
