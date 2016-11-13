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

@interface RegisterPassengerAccount : UIViewController<NSURLConnectionDataDelegate>
{
    NSMutableData *_responseData;
}

@property (strong, nonatomic) IBOutlet UITextField *firstnm;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UITextField *passwordverify;
@property (strong, nonatomic) IBOutlet UITextField *phonenumber;
@property (strong, nonatomic) IBOutlet UITextField *address;
@property (strong, nonatomic) IBOutlet UIButton *signupbut;
- (NSString *) md5:(NSString *) input;
@property (nonatomic) int flagOfAjaxCall;
@property (nonatomic) bool flagOfKeyboard;
@property (strong, nonatomic) IBOutlet UIButton *mButton;
@property (strong, nonatomic) IBOutlet UIScrollView *uiScrollView;

@end

