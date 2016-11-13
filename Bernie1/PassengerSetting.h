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

@interface PassengerSetting : UIViewController<NSURLConnectionDataDelegate>
{
    NSMutableData *_responseData;
}

@property (strong, nonatomic) IBOutlet UITextField *passenger_name;
@property (strong, nonatomic) IBOutlet UITextField *passenger_email;
@property (strong, nonatomic) IBOutlet UITextField *passenger_phonenumber;
@property (strong, nonatomic) IBOutlet UITextField *passenger_address;

@property (strong, nonatomic) IBOutlet UITextField *ns_password;
@property (strong, nonatomic) IBOutlet UITextField *verify_pasword;

@property (nonatomic) int flagOfService;
@property (nonatomic) bool flagOfKeyboard;
@end

