//
//  PKSetupViewController.h
//  PDUKeeper
//
//  Created by James Abendroth on 4/9/13.
//  Copyright (c) 2013 JamesAbendroth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderFooterLabel.h"

@interface PKSetupViewController : UIViewController
{
}

@property (weak, nonatomic) IBOutlet UIDatePicker *expirationDatePicker;

-(void)setupDone;

@end
