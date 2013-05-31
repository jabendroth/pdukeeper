//
//  PKSetupViewController.m
//  PDUKeeper
//
//  Created by James Abendroth on 4/9/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import "PKSetupViewController.h"
#import "PKSettings.h"
#import "PKSettingsStore.h"

@implementation PKSetupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIToolbar *toolbar;
        
        toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, [[self view] bounds].size.width, 44)];
        toolbar.barStyle = UIBarStyleDefault;
        
        UIBarButtonItem *filler = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle: @"Done" style: UIBarButtonItemStyleDone target: self action: @selector(setupDone)];
        
        toolbar.items = [NSArray arrayWithObjects: filler, doneButton, nil];
        [toolbar setBarStyle:UIBarStyleBlack];
        [[self view] addSubview:toolbar];
        
        [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"table_bg.png"]]];
        
    }
    return self;
}

-(void)setupDone
{
    PKSettingsStore *store = [PKSettingsStore sharedStore];
    
    [[store settings] setExpirationDate:[[self expirationDatePicker] date]];
    [store saveChanges];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
