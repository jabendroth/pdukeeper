//
//  PKPDUNavViewController.m
//  PDUKeeper
//
//  Created by James Abendroth on 3/8/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import "PKPDUNavViewController.h"

@implementation PKPDUNavViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"PDUs"];
        
        UIImage *tabImage = [UIImage imageNamed:@"282-cards.png"];
        [tbi setImage:tabImage];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
