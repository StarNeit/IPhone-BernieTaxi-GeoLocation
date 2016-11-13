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

@interface PickupContract : UIViewController<NSURLConnectionDataDelegate>
{
    NSMutableData *_responseData;
}
@property (strong, nonatomic) IBOutlet UILabel *promise_time;
@property (strong, nonatomic) IBOutlet UILabel *pickup_address;
@property (strong, nonatomic) IBOutlet UILabel *pickup_phone;
@property (nonatomic) int flagOfAjaxCall;
-(void) getContractList;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) bool flagOfKeyboard;
@end

