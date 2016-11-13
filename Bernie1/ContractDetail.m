//
//  SecondView.m
//  example5
//
//  Created by PLEASE on 03/01/16.
//  Copyright © 2016 zaltan nyhether. All rights reserved.
//
#import "ContractDetail.h"

@interface ContractDetail ()
@property (strong, nonatomic) IBOutlet UITextField *second;

@end

@implementation ContractDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //currentDetailContract
    self.selected_trip_lat = pc_trip_lat[currentDetailContract];
    self.selected_trip_lon = pc_trip_lon[currentDetailContract];
    self.selected_trip_promise_time = pc_trip_promise_time[currentDetailContract];
    self.selected_trip_address = pc_trip_address[currentDetailContract];
    
    self.pickAddress.text = self.selected_trip_address;
    self.pickTime.text = self.selected_trip_promise_time;
    
    self.flagOfAjaxCall = 0;
    
    //---------driver position-------
    //[self.mapView removeAnnotation:[self.mapView.annotations lastObject]];
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    MKPointAnnotation *annot = [[MKPointAnnotation alloc] init];
    annot.title = @"Driver's location";
    annot.subtitle = @"This is driver's location";
    CLLocationCoordinate2D touchMapCoordinate;
    touchMapCoordinate = CLLocationCoordinate2DMake(driver_lat, driver_lon);
    
    annot.coordinate = touchMapCoordinate;
    [self.mapView addAnnotation:annot];
    
    
    //---------my trip position(trip position)-------
    MKPointAnnotation *annot2 = [[MKPointAnnotation alloc] init];
    annot2.title = @"Trip location";
    annot2.subtitle = @"This is user's trip location";
    
    CLLocationCoordinate2D touchMapCoordinate2;
    touchMapCoordinate2 = CLLocationCoordinate2DMake(self.selected_trip_lat, self.selected_trip_lon);
    annot2.coordinate = touchMapCoordinate2;
    [self.mapView addAnnotation:annot2];
    
    self.flagOfKeyboard = false;
}
- (IBAction)go_settings:(id)sender {
    driverSettingPrevPage = @"DetailContract";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)do_accept_pickcontract:(id)sender
{
    if (self.flagOfAjaxCall == 0)
    {
        NSString *url1 = [NSString stringWithFormat:@"http://bernietaxi.com/service/Driver/DriverAcceptContract?user_id=%d&trip_id=%d&driver_id=%d&paid=%d",pc_user_id[currentDetailContract], pc_trip_id[currentDetailContract], driver_id, g_driverType];
        NSURL *fileURL = [NSURL URLWithString:url1];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:fileURL cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:30.0];
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        self.flagOfAjaxCall = 1;
    }
}

- (IBAction)zoomin:(id)sender {
    float delta = 0.5;
    MKCoordinateRegion region = self.mapView.region;
    MKCoordinateSpan span = self.mapView.region.span;
    span.latitudeDelta*=delta;
    span.longitudeDelta*=delta;
    region.span=span;
    [self.mapView setRegion:region animated:YES];
}
- (IBAction)zoomout:(id)sender {
    float delta = 1.4;
    MKCoordinateRegion region = self.mapView.region;
    MKCoordinateSpan span = self.mapView.region.span;
    span.latitudeDelta*=delta;
    span.longitudeDelta*=delta;
    region.span=span;
    [self.mapView setRegion:region animated:YES];

}
- (IBAction)showPickupLocation:(id)sender {
    float spanX = 0.00725;
    float spanY = 0.00725;
    MKCoordinateRegion region;
    region.center.latitude = self.selected_trip_lat;//self.mapView.userLocation.coordinate.latitude;
    region.center.longitude = self.selected_trip_lon;//self.mapView.userLocation.coordinate.longitude;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    //self.searchButton.hidden = YES;
    [self.mapView setRegion:region animated:YES];
}
- (IBAction)showDriverLocation:(id)sender {
    float spanX = 0.00725;
    float spanY = 0.00725;
    MKCoordinateRegion region;
    region.center.latitude = driver_lat;//self.mapView.userLocation.coordinate.latitude;
    region.center.longitude = driver_lon;//self.mapView.userLocation.coordinate.longitude;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    //self.searchButton.hidden = YES;
    [self.mapView setRegion:region animated:YES];
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
    
    if (self.flagOfAjaxCall == 1)
    {
        if (compareString(resultCode, @"fail"))
        {
            showAlertMessage(@"Error, Check your Internet");
            self.flagOfAjaxCall = 0;
            return;
        }else if (compareString(resultCode, @"exist"))
        {
            showAlertMessage(@"Already started...");
            self.flagOfAjaxCall = 0;
            return;
        }
        if (compareString(resultCode, @"ok"))
        {
            int pos = currentDetailContract;
            trip_id = pc_trip_id[pos];
            trip_lat = pc_trip_lat[pos];
            trip_lon = pc_trip_lon[pos];
            trip_promise_time = pc_trip_promise_time[pos];
            trip_address = pc_trip_address[pos];
            trip_status = pc_trip_status[pos];
            trip_regdate = pc_trip_regdate[pos];
            
            trip_premium = g_driverType;
            trip_status = 2; //STATUS_TRIP_DRIVER_ACCEPTED
            
            user_id = pc_user_id[pos];
            user_name = pc_user_name[pos];
            user_phone = pc_user_phone[pos];
            user_lat = pc_user_lat[pos];
            user_lon = pc_user_lon[pos];
            
            //-----------redirecting
            UIStoryboard *mainStorynboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *documetController = [mainStorynboard instantiateViewControllerWithIdentifier:@"DriverContractShowActivity"];
            [self.navigationController pushViewController:documetController animated:YES];
        }
        self.flagOfAjaxCall = 0;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    showAlertMessage(@"Failed.Try agin");
}

@end
