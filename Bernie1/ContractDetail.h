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

@interface ContractDetail : UIViewController<NSURLConnectionDataDelegate>
{
    NSMutableData *_responseData;
}


@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UITextField *pickAddress;

@property (strong, nonatomic) IBOutlet UITextField *pickTime;

@property (nonatomic) double selected_trip_lat;
@property (nonatomic) double selected_trip_lon;
@property (nonatomic) NSString* selected_trip_promise_time;
@property (nonatomic) NSString* selected_trip_address;

@property (nonatomic) int flagOfAjaxCall;
@property (nonatomic) bool flagOfKeyboard;
@end

	