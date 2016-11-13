//
//  SecondView.h
//  example5
//
//  Created by PLEASE on 03/01/16.
//  Copyright © 2016 zaltan nyhether. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "global.h"

@interface DriverContactUS : UIViewController<NSURLConnectionDataDelegate>
{
    NSMutableData *_responseData;
}

@property (strong, nonatomic) IBOutlet UITextField *driver_contact_title;
@property (strong, nonatomic) IBOutlet UITextView *driver_contact_content;

@property (nonatomic) int flagOfAjaxCall;
@property (strong, nonatomic) IBOutlet UIButton *mButton;
@property (nonatomic) bool flagOfKeyboard;
@property (strong, nonatomic) IBOutlet UIScrollView *uiScrollView;
@end

