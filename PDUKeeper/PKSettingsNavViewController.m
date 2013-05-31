//
//  PKSettingsNavViewController.m
//  PDUKeeper
//
//  Created by James Abendroth on 4/20/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import "PKSettingsNavViewController.h"

@interface PKSettingsNavViewController ()

@end

@implementation PKSettingsNavViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"Settings"];
        
        UIImage *tabImage = [UIImage imageNamed:@"20-gear-2.png"];
        [tbi setImage:tabImage];
        
    }
    return self;
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

@end
