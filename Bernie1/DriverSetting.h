//
//  SecondView.h
//  example5
//
//  Created by PLEASE on 03/01/16.
//  Copyright © 2016 zaltan nyhether. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "global.h"
#import "NSString+MD5.h"

@interface DriverSetting : UIViewController<NSURLConnectionDataDelegate>
{
    NSMutableData *_responseData;
}

@property (strong, nonatomic) IBOutlet UITextField *driver_name;
@property (strong, nonatomic) IBOutlet UITextField *driver_email;
@property (strong, nonatomic) IBOutlet UITextField *driver_phone;
@property (strong, nonatomic) IBOutlet UITextField *driver_license_card_number;

@property (strong, nonatomic) IBOutlet UITextField *driver_nspassword;
@property (strong, nonatomic) IBOutlet UITextField *driver_verifypassword;

@property (nonatomic) int flagOfService;
@property (nonatomic) bool flagOfKeyboard;
@end

