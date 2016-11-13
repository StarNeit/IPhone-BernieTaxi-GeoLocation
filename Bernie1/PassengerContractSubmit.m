//
//  SecondView.m
//  example5
//
//  Created by PLEASE on 03/01/16.
//  Copyright © 2016 zaltan nyhether. All rights reserved.
//
#import "PassengerContractSubmit.h"

#define TRIM(string) [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
#define HEXCOLOR(c) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 green:((c>>16)&0xFF)/255.0 blue:((c>>8)&0xFF)/255.0 alpha:((c)&0xFF)/255.0];

@interface PassengerContractSubmit ()
@property (strong, nonatomic) IBOutlet UITextField *second;

@end

@implementation PassengerContractSubmit

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0; //user needs to press for 2 seconds
    [self.mapView addGestureRecognizer:lpgr];
    
    
    
    _toolbar.hidden = true;
    _datePicker.hidden = true;
    _toolbar.hidden = true;
    _datePicker.hidden = true;
    UIColor* c = HEXCOLOR(0xbeb9b3ff);
    _datePicker.backgroundColor = c;
    _toolbar.backgroundColor = c;
    [_textField setDelegate:self];
    
    
    
    self.flagOfAjaxCall = 0;
    self.pdblLatitude = -99999;
    self.pdblLongitude = -99999;
    
    self.mapView.delegate = self;
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation = YES;
    
    self.flagOfKeyboard = false;
    
    
    
    //---------driver position-------
    //[self.mapView removeAnnotation:[self.mapView.annotations lastObject]];
    //[self.mapView removeAnnotations:self.mapView.annotations];
    
    MKPointAnnotation *annot = [[MKPointAnnotation alloc] init];
    annot.title = @"My location";
    annot.subtitle = @"This is my location";
    CLLocationCoordinate2D touchMapCoordinate;
    touchMapCoordinate = CLLocationCoordinate2DMake(user_lat, user_lon);
    
    annot.coordinate = touchMapCoordinate;
    [self.mapView addAnnotation:annot];
    
    
    //move to current user location.
    float spanX = 0.2;
    float spanY = 0.2;
    MKCoordinateRegion region;
    region.center.latitude = user_lat;
    region.center.longitude = user_lon;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    [self.mapView setRegion:region animated:YES];
    
    
    bDriverStatusThread = false;
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    NSLog(annotation.title);
    if (compareString(annotation.title, @"Trip location"))
    {
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                         reuseIdentifier:nil];
        UIImage *flagImage = [UIImage imageNamed:@"annotation1.png"];
        // You may need to resize the image here.
        annotationView.image = flagImage;
        
        return annotationView;
    }else{
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                        reuseIdentifier:nil];
        UIImage *flagImage = [UIImage imageNamed:@"annotation2.png"];
        // You may need to resize the image here.
        annotationView.image = flagImage;
        return annotationView;
    }
}


- (IBAction)go_settings:(id)sender {
    passengerSettingPrevPage = @"passengercontractsubmit";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    //[self.mapView removeAnnotation:[self.mapView.annotations lastObject]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@",  @"Trip location"];
    [self.mapView removeAnnotations:[self.mapView.annotations filteredArrayUsingPredicate:predicate]];
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    MKPointAnnotation *annot = [[MKPointAnnotation alloc] init];
    annot.coordinate = touchMapCoordinate;
    annot.title = @"Trip location";
    annot.subtitle = @"This is trip location";
    
    
   
    [self.mapView addAnnotation:annot];
    
    
    
    
    self.pdblLatitude = touchMapCoordinate.latitude;
    self.pdblLongitude = touchMapCoordinate.longitude;
    
    
    
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:self.pdblLatitude longitude:self.pdblLongitude]; //insert your coordinates
    
    [ceo reverseGeocodeLocation:loc
              completionHandler:^(NSArray *placemarks, NSError *error) {
                  CLPlacemark *placemark = [placemarks objectAtIndex:0];
                  NSLog(@"placemark %@",placemark);
                  //String to hold address
                  NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@","];
                  /*NSLog(@"addressDictionary %@", placemark.addressDictionary);
                   
                   NSLog(@"placemark %@",placemark.region);
                   NSLog(@"placemark %@",placemark.country);  // Give Country Name
                   
                   NSLog(@"placemark %@",placemark.locality); // Extract the city name
                   NSLog(@"location %@",placemark.name);
                   NSLog(@"location %@",placemark.ocean);
                   NSLog(@"location %@",placemark.postalCode);
                   NSLog(@"location %@",placemark.subLocality);
                   
                   NSLog(@"location %@",placemark.location);
                   //Print the location to console
                   NSLog(@"I am currently at %@",locatedAt);*/
                  
                  //NSString *result = [locatedAt stringByReplacingOccurrencesOfString:@" " withString:@""];
                  //self.address.text = TRIM(result);
                  self.address.text = locatedAt;
              }
     ];
    //[annot release];
    
}


- (IBAction)ZoomInMap:(id)sender {
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

- (IBAction)ZoomOutMap:(id)sender {
    float delta = 2;
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

- (IBAction)textFieldClicked:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-dd-MM HH:mm:ss"];
    
    _textField.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate: _datePicker.date]];
    _datePicker.hidden = false;
    _toolbar.hidden = false;
}

- (IBAction)datePickerChanged:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-dd-MM HH:mm:ss"];
    _textField.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate: _datePicker.date]];
}

- (IBAction)closeDatePicker:(id)sender {
    _datePicker.hidden = true;
    _toolbar.hidden = true;
}

//Needed to prevent keyboard from opening
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}


- (IBAction)do_createcontract:(id)sender {
    if (compareString(self.address.text,@""))
    {
        showAlertMessage(@"Select Contract Location by Long Click Map");
        return;
    }
    if (compareString(self.textField.text, @""))
    {
        showAlertMessage(@"Selct Time by Click Textbox");
        return;
    }
    if (self.flagOfAjaxCall == 0)
    {
        if (self.pdblLongitude == -99999)
        {
            self.pdblLongitude = user_lon;
            self.pdblLatitude = user_lat;
        }
        NSString *url1 = [NSString stringWithFormat:@"http://bernietaxi.com/service/Passenger/CreateContract?user_id=%d&lat=%f&lon=%f&address=%@&time=%@",user_id,self.pdblLatitude,self.pdblLongitude,self.address.text, self.textField.text];
        NSURL *fileURL = [NSURL URLWithString:[url1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:fileURL
                                                               cachePolicy:NSURLCacheStorageNotAllowed
                                                           timeoutInterval:30.0];
        // Create url connection and fire request
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        self.flagOfAjaxCall = 1;
    }
}

- (IBAction)showUserLoc:(id)sender
{
    float spanX = 0.00725;
    float spanY = 0.00725;
    MKCoordinateRegion region;
    region.center.latitude = g_curLatitude;//self.mapView.userLocation.coordinate.latitude;
    region.center.longitude = g_curLongitude;//self.mapView.userLocation.coordinate.longitude;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    @try {
        [self.mapView setRegion:region animated:YES];
    }
    @catch (NSException *exception) {
        
    }
}
- (IBAction)showTripLoc:(id)sender
{
    if (self.pdblLongitude != -99999)
    {
        float spanX = 0.00725;
        float spanY = 0.00725;
        MKCoordinateRegion region;
        region.center.latitude = self.pdblLatitude;//self.mapView.userLocation.coordinate.latitude;
        region.center.longitude = self.pdblLongitude;//self.mapView.userLocation.coordinate.longitude;
        region.span.latitudeDelta = spanX;
        region.span.longitudeDelta = spanY;
        @try {
            [self.mapView setRegion:region animated:YES];
        }
        @catch (NSException *exception) {
            
        }
    }    
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
     _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.flagOfAjaxCall == 1)
    {
        NSString *tmp = [[NSString alloc] initWithData:_responseData encoding:NSASCIIStringEncoding];
        NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:[tmp dataUsingEncoding:NSUTF8StringEncoding]
                                                              options:0 error:NULL];
        
        NSArray *resultCode = [jsonObject valueForKey:@"resultCode"];
        
        if (compareString(resultCode,@""))
        {
            showAlertMessage(@"Failed. Check Your Internet Connection");
            self.flagOfAjaxCall = 0;
            return;
        }
        
        if (compareString(resultCode, @"fail"))
        {
            showAlertMessage(@"Create contract failed");
            self.flagOfAjaxCall = 0;
            return;
        }
        
        if (compareString(resultCode, @"ok"))
        {
            
            trip_id = [[jsonObject valueForKey:@"trip_id"] intValue];
                        
            if(trip_id > 0)
            {
                trip_lat = self.pdblLatitude;
                trip_lon = self.pdblLongitude;
                trip_address = self.address.text;
                trip_promise_time = self.textField.text;
                trip_status = 1;
                set_default_driver();
                
                //-----------redirecting
                UIStoryboard *mainStorynboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController *documetController = [mainStorynboard instantiateViewControllerWithIdentifier:@"createpassengercontract"];
                [self.navigationController pushViewController:documetController animated:YES];
            }else{
                showAlertMessage(@"Create contract failed");
                self.flagOfAjaxCall = 0;
                return;
            }
        }
        self.flagOfAjaxCall = 0;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    showAlertMessage(@"Register Failed");
}
//----key
- (IBAction)exitfield:(UITextField *)sender {
    
}

- (IBAction)begindediting:(UITextField *)sender
{
    if (self.flagOfKeyboard == false)
    {
        [self animateTextField:sender up:YES];
        self.flagOfKeyboard = true;
    }
    
}

- (IBAction)endediting:(UITextField *)sender {
    if (self.flagOfKeyboard == true)
    {
        [self animateTextField:sender up:NO];
        self.flagOfKeyboard = false;
    }
    
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = -150; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

@end
