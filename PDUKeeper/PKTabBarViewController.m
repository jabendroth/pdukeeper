//
//  PKTabBarViewController.m
//  PDUKeeper
//
//  Created by James Abendroth on 4/9/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import "PKTabBarViewController.h"
#import "PKSettingsStore.h"
#import "PKSettings.h"
#import "PKSetupViewController.h"

@implementation PKTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    PKSettingsStore *store = [PKSettingsStore sharedStore];
    
    if (![[store settings] expirationDate]){
        PKSetupViewController *vc = [[PKSetupViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
