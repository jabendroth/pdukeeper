//
//  PKStatePicker.m
//  PDUKeeper
//
//  Created by James Abendroth on 5/21/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import "PKStatePicker.h"

@implementation PKStatePicker

-(id)init
{
    self = [super init];
    if (self){
        states = [[NSMutableArray alloc] initWithObjects:@"AL",
                  @"AK",
                  @"AZ",
                  @"AR",
                  @"CA",
                  @"CO",
                  @"CT",
                  @"DE",
                  @"DC",
                  @"FL",
                  @"GA",
                  @"HI",
                  @"ID",
                  @"IL",
                  @"IN",
                  @"IA",
                  @"KS",
                  @"KY",
                  @"LA",
                  @"ME",
                  @"MT",
                  @"NE",
                  @"NV",
                  @"NH",
                  @"NJ",
                  @"NM",
                  @"NY",
                  @"NC",
                  @"ND",
                  @"OH",
                  @"OK",
                  @"OR",
                  @"MD",
                  @"MA",
                  @"MI",
                  @"MN",
                  @"MS",
                  @"MO",
                  @"PA",
                  @"RI",
                  @"SC",
                  @"SD",
                  @"TN",
                  @"TX",
                  @"UT",
                  @"VT",
                  @"VA",
                  @"WA",
                  @"WV",
                  @"WI",
                  @"WY",
                  nil];
    }
    return self;
}

-(void)showStatePicker
{
    CGRect pickerFrame;
    UIToolbar *toolbar;
    int i;
    
    sheet = [[UIActionSheet alloc] init];
    
    pickerFrame = CGRectMake(0, 0, 0, 0);
    picker = [[UIPickerView alloc] initWithFrame:pickerFrame];
    [picker setDelegate:self];
    [picker setShowsSelectionIndicator:YES];
    
    if ([self selectedState]){
        
        for (i=0 ; i<[states count] ; i++){
            NSString *state = [states objectAtIndex:i];
            if ([state compare:[self selectedState]]==0){
                [picker selectRow:i inComponent:0 animated:YES];
                break;
            }
        }
    }
    
    [sheet addSubview:picker];
    
    toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, 320, 44)];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    
    UIBarButtonItem *filler = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle: @"Done" style: UIBarButtonItemStyleDone target: self action: @selector(statePickerDone)];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle: @"Cancel" style: UIBarButtonSystemItemCancel target: self action: @selector(statePickerCancel)];
    
    toolbar.items = [NSArray arrayWithObjects: cancelButton, filler, doneButton, nil];
    [sheet addSubview: toolbar];
    
    [sheet showFromTabBar:[self fromTabBar]];
    [sheet setBounds:CGRectMake(0, 0, 320, 415)];
}

-(void)statePickerCancel
{
    [sheet dismissWithClickedButtonIndex:1 animated:YES];
}

-(void)statePickerDone
{
    if ([self delegate])
        [[self delegate] stateSelected:[self selectedState]];
    
    [sheet dismissWithClickedButtonIndex:0 animated:YES];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [states count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [states objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component
{
    // Handle the selection
    [self setSelectedState:[states objectAtIndex:row]];
}

@end
