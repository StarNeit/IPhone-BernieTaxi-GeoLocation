//
//  SecondView.m
//  example5
//
//  Created by PLEASE on 03/01/16.
//  Copyright © 2016 zaltan nyhether. All rights reserved.
//
#import "PickupContract.h"

@interface PickupContract ()
@property (strong, nonatomic) IBOutlet UITextField *second;

@end

@implementation PickupContract

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.pickup_address.text = trip_address;
    self.pickup_phone.text = user_phone;
    self.promise_time.text = trip_promise_time;
    
    self.flagOfAjaxCall = 0;
    
    self.mapView.delegate = self;
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation = YES;
    
    //----show driver's location on map
    [self.mapView removeAnnotations:self.mapView.annotations];
    MKPointAnnotation *annot = [[MKPointAnnotation alloc] init];
    annot.title = @"Driver location";
    annot.subtitle = @"This is driver location";
    CLLocationCoordinate2D touchMapCoordinate;
    touchMapCoordinate = CLLocationCoordinate2DMake(driver_lat, driver_lon);
    
    annot.coordinate = touchMapCoordinate;
    [self.mapView addAnnotation:annot];
    
    //-------
    MKPointAnnotation *annot2 = [[MKPointAnnotation alloc] init];
    annot2.title = @"Trip location";
    annot2.subtitle = @"This is trip location";
    CLLocationCoordinate2D touchMapCoordinate2;
    touchMapCoordinate2 = CLLocationCoordinate2DMake(trip_lat, trip_lon);
    
    annot2.coordinate = touchMapCoordinate2;
    [self.mapView addAnnotation:annot2];
    
    //-------
    MKPointAnnotation *annot3 = [[MKPointAnnotation alloc] init];
    annot3.title = @"User location";
    annot3.subtitle = @"This is passenger location";
    CLLocationCoordinate2D touchMapCoordinate3;
    touchMapCoordinate3 = CLLocationCoordinate2DMake(user_lat, user_lon);
    
    annot3.coordinate = touchMapCoordinate3;
    [self.mapView addAnnotation:annot3];

}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if (compareString(annotation.title, @"Trip location"))
    {
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                        reuseIdentifier:nil];
        UIImage *flagImage = [UIImage imageNamed:@"annotation1.png"];
        // You may need to resize the image here.
        annotationView.image = flagImage;
        
        return annotationView;
    }else if (compareString(annotation.title, @"User location")){
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                        reuseIdentifier:nil];
        UIImage *flagImage = [UIImage imageNamed:@"annotation2.png"];
        // You may need to resize the image here.
        annotationView.image = flagImage;
        return annotationView;
    }else if (compareString(annotation.title, @"Driver location"))
    {
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                        reuseIdentifier:nil];
        UIImage *flagImage = [UIImage imageNamed:@"annotation3.png"];
        // You may need to resize the image here.
        annotationView.image = flagImage;
        return annotationView;
    }
    return nil;
}


-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    //self.searchButton.hidden = NO;
}
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    [self.mapView setCenterCoordinate:userLocation.coordinate animated:YES];
}
- (IBAction)showDriverLoc:(id)sender {
    float spanX = 0.00725;
    float spanY = 0.00725;
    MKCoordinateRegion region;
    region.center.latitude = g_curLatitude;//self.mapView.userLocation.coordinate.latitude;
    region.center.longitude = g_curLongitude;//self.mapView.userLocation.coordinate.longitude;
    
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    //self.searchButton.hidden = YES;
    @try {
        [self.mapView setRegion:region animated:YES];
    }
    @catch (NSException *exception) {
        
    }
}
- (IBAction)showTripLoc:(id)sender {
    float spanX = 0.00725;
    float spanY = 0.00725;
    MKCoordinateRegion region;
    region.center.latitude = trip_lat;//self.mapView.userLocation.coordinate.latitude;
    region.center.longitude = trip_lon;//self.mapView.userLocation.coordinate.longitude;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    //self.searchButton.hidden = YES;
    @try {
        [self.mapView setRegion:region animated:YES];
    }
    @catch (NSException *exception) {
        
    }
}
- (IBAction)showUserLoc:(id)sender {
    float spanX = 0.00725;
    float spanY = 0.00725;
    MKCoordinateRegion region;
    region.center.latitude = g_curLatitude;//self.mapView.userLocation.coordinate.latitude;
    region.center.longitude = g_curLongitude;//self.mapView.userLocation.coordinate.longitude;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    //self.searchButton.hidden = YES;
    @try {
    [self.mapView setRegion:region animated:YES];
}
@catch (NSException *exception) {
}
    
}
- (IBAction)do_callpassenger:(id)sender {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",
                                                                      self.pickup_phone.text]]];
    //showAlertMessage(self.pickup_phone.text);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)do_cancel_contract:(id)sender
{
    if (self.flagOfAjaxCall == 0)
    {
        NSString *url1 = [NSString stringWithFormat:@"http://bernietaxi.com/service/Driver/DriverCancelContract?user_id=%d&trip_id=%d&driver_id=%d&paid=%d",user_id, trip_id, driver_id, g_driverType];
        //showAlertMessage(url1);
        NSURL *fileURL = [NSURL URLWithString:url1];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:fileURL cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:30.0];
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        self.flagOfAjaxCall = 1;
    }
}
- (IBAction)do_complete_contract:(id)sender
{
    if (self.flagOfAjaxCall == 0)
    {
        NSString *url1 = [NSString stringWithFormat:@"http://bernietaxi.com/service/Driver/DriverCompleteContract?user_id=%d&trip_id=%d&driver_id=%d&paid=%d",user_id, trip_id, driver_id, g_driverType];
        NSURL *fileURL = [NSURL URLWithString:url1];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:fileURL cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:30.0];
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        self.flagOfAjaxCall = 2;
    }
}

- (IBAction)go_settings:(id)sender {
    driverSettingPrevPage = @"DriverContractShowActivity";
}

-(void) getContractList
{
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://bernietaxi.com/service/Driver/GetContractList"]];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    
    if (error == nil)
    {
        // Parse data here
        NSString *tmp = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:[tmp dataUsingEncoding:NSUTF8StringEncoding]
                                                              options:0 error:NULL];
        NSArray *resultCode = [jsonObject valueForKey:@"resultCode"];
        
        if (!compareString(resultCode,@"") && !compareString(resultCode, @"fail"))
        {
            NSString* str1 = @"";
            if (compareString(resultCode, @"ok"))
            {
                NSArray *tripArr = [jsonObject valueForKey:@"trip"];
                pContractCnt = tripArr.count;
                for (int i = 0 ; i < tripArr.count; i ++)
                {
                    pContractNameList[i] = [tripArr[i] valueForKey:@"trip_address"];
                }
                //pContractNameList[tripArr.count] = nil;
            }
        }
    }
}
- (IBAction)zoomin:(id)sender {
    float delta = 0.5;
    MKCoordinateRegion region = self.mapView.region;
    MKCoordinateSpan span = self.mapView.region.span;
    span.latitudeDelta*=delta;
    span.longitudeDelta*=delta;
    region.span=span;
    @try {
        [self.mapView setRegion:region animated:YES];
    }
    @catch (NSException *exception) {
        
    }
}
- (IBAction)zoomout:(id)sender {
    float delta = 1.4;
    MKCoordinateRegion region = self.mapView.region;
    MKCoordinateSpan span = self.mapView.region.span;
    span.latitudeDelta*=delta;
    span.longitudeDelta*=delta;
    region.span=span;
    @try {
        [self.mapView setRegion:region animated:YES];
    }
    @catch (NSException *exception) {
        
    }
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {  _responseData = [[NSMutableData alloc] init]; }

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data { [_responseData appendData:data];}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse {  return nil;}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *tmp = [[NSString alloc] initWithData:_responseData encoding:NSASCIIStringEncoding];
    
    NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:[tmp dataUsingEncoding:NSUTF8StringEncoding]
                                                          options:0 error:NULL];
    NSArray *resultCode = [jsonObject valueForKey:@"resultCode"];
 
    if (self.flagOfAjaxCall == 2)
    {
        if (compareString(resultCode, @"fail"))
        {
            showAlertMessage(@"Error, Check your Internet");
            self.flagOfAjaxCall = 0;
            return;
        }
        if (compareString(resultCode, @"ok"))
        {
            trip_status = jsonIntValidate([jsonObject valueForKey:@"trip_status"]);
            //-----------redirecting
            UIStoryboard *mainStorynboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *documetController = [mainStorynboard instantiateViewControllerWithIdentifier:@"drivercontractfinish"];
            [self.navigationController pushViewController:documetController animated:YES];
        }
        self.flagOfAjaxCall = 0;
    }
    if (self.flagOfAjaxCall == 1)
    {
        if (compareString(resultCode, @"fail"))
        {
            showAlertMessage(@"Error, Check your Internet");
            self.flagOfAjaxCall = 0;
            return;
        }
        if (compareString(resultCode, @"ok"))
        {
            set_default_trip();
            [self getContractList];
            //-----------redirecting
            UIStoryboard *mainStorynboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *documetController = [mainStorynboard instantiateViewControllerWithIdentifier:@"driverpickcontract"];
            [self.navigationController pushViewController:documetController animated:YES];
        }
        self.flagOfAjaxCall = 0;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    showAlertMessage(@"Failed.Try agin");
}
@end
