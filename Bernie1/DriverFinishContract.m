//
//  SecondView.m
//  example5
//
//  Created by PLEASE on 03/01/16.
//  Copyright © 2016 zaltan nyhether. All rights reserved.
//
#import "DriverFinishContract.h"

@interface DriverFinishContract ()
@property (strong, nonatomic) IBOutlet UITextField *second;

@end

@implementation DriverFinishContract

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(trip_status == 4 && trip_premium == 0)
    {
        self.finishAlert.text = @"Thank You for your Dedication to getting Bernie Sanders Elected President";
    }else if (trip_status == 5 && trip_premium == 1)
    {
        self.finishAlert.text = @"Thank You for your Dedication to getting Bernie Sanders Elected President";
    }else
    {
        self.finishAlert.text = @"Please wait for passenger to complete contract";
        
    }
}
- (IBAction)go_settings:(id)sender {
    driverSettingPrevPage = @"drivercontractfinish";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
