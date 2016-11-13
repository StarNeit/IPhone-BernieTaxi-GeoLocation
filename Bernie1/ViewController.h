//
//  ViewController.h
//  Bernie1
//
//  Created by PLEASE on 03/01/16.
//  Copyright © 2016 zaltan nyhether. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Foundation;
#import "global.h"
#import "NSString+MD5.h"
#import <CoreLocation/CoreLocation.h>


@interface ViewController : UIViewController<NSURLConnectionDataDelegate , UIAlertViewDelegate, CLLocationManagerDelegate>
{
    NSMutableData *_responseData;
}

@property (strong, nonatomic) IBOutlet UIButton *volunteer_driver;
@property (strong, nonatomic) IBOutlet UIButton *getride_but;
@property (nonatomic) int flagOfLogin;
@property (nonatomic) bool gpsFlag;
@end

