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

@interface RegisterDriverAccount : UIViewController<NSURLConnectionDataDelegate>
{
    NSMutableData *_responseData;
}

@property (strong, nonatomic) IBOutlet UITextField *driver_name;
@property (strong, nonatomic) IBOutlet UITextField *driver_email;
@property (strong, nonatomic) IBOutlet UITextField *driver_password;
@property (strong, nonatomic) IBOutlet UITextField *driver_verifypassword;
@property (strong, nonatomic) IBOutlet UITextField *driver_license_card;
@property (strong, nonatomic) IBOutlet UITextField *driver_phone_number;

-(void) getContractList;
@property (strong, nonatomic) IBOutlet UIButton *mButton;
@property (strong, nonatomic) IBOutlet UIScrollView *uiScrollView;

@property (nonatomic) int flagOfAjaxCall;
@property (nonatomic) bool flagOfKeyboard;
@end

