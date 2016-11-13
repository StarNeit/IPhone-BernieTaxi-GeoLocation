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

@interface PassengerLogin : UIViewController<NSURLConnectionDataDelegate>
{
    NSMutableData *_responseData;
}

@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIButton *loginbut;

@property (nonatomic) int flagOfAjaxCall;
@property (nonatomic) bool flagOfKeyboard;
@end

