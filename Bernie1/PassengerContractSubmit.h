//
//  SecondView.h
//  example5
//
//  Created by PLEASE on 03/01/16.
//  Copyright © 2016 zaltan nyhether. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "global.h"

@interface PassengerContractSubmit : UIViewController<NSURLConnectionDataDelegate>
{
    NSMutableData *_responseData;
}


@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UITextField *address;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic) double pdblLatitude;
@property (nonatomic) double pdblLongitude;
@property (nonatomic) int flagOfAjaxCall;
@property (nonatomic) bool flagOfKeyboard;

@end

