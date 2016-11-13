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

@interface DriverLogin : UIViewController<NSURLConnectionDataDelegate>
{
    NSMutableData *_responseData;
}
@property (strong, nonatomic) IBOutlet UITextField *driver_email;
@property (strong, nonatomic) IBOutlet UITextField *driver_password;
-(void) getContractList;
@property (nonatomic) int flagOfAjaxCall;
@property (nonatomic) bool flagOfKeyboard;
@end

