//
//  SecondView.h
//  example5
//
//  Created by PLEASE on 03/01/16.
//  Copyright © 2016 zaltan nyhether. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "global.h"

@interface RegisterDonatingInfo : UIViewController<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *firstnm;
@property (strong, nonatomic) IBOutlet UITextField *lastnm;
@property (strong, nonatomic) IBOutlet UITextField *email;

@property (strong, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic) IBOutlet UIButton *backbut;
@property (nonatomic) bool flagOfKeyboard;
@end

