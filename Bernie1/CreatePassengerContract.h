//
//  SecondView.h
//  example5
//
//  Created by PLEASE on 03/01/16.
//  Copyright © 2016 zaltan nyhether. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "global.h"
#import <MapKit/MapKit.h>

@interface CreatePassengerContract : UIViewController<NSURLConnectionDataDelegate>
{
    NSMutableData *_responseData;
    
}

@property (strong, nonatomic) IBOutlet UITextField *contract_driver_nm;
@property (strong, nonatomic) IBOutlet UITextField *contract_driver_phonenumber;
@property (nonatomic) int message;
@property (strong, nonatomic) IBOutlet UIButton *driverIcon;

@property (nonatomic) int flagOfAjaxCall;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) int stateOfContract;
@property (nonatomic) bool flagOfKeyboard;
@end

