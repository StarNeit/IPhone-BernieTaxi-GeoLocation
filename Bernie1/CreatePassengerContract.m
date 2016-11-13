//
//  SecondView.m
//  example5
//
//  Created by PLEASE on 03/01/16.
//  Copyright © 2016 zaltan nyhether. All rights reserved.
//
#import "CreatePassengerContract.h"
#include <assert.h>
#include <pthread.h>

bool threadFlag = false;

void* PosixThreadMainRoutine(void* data)
{
    // Do some work here.
    while(true){
       
        if(bDriverStatusThread)
        {
             NSLog(@"thread is running");
            threadFlag = true;
        }
        [NSThread sleepForTimeInterval:15];
    }
    return NULL;
}

void LaunchThread()
{
    // Create the thread using POSIX routines.
    pthread_attr_t  attr;
    pthread_t       posixThreadID;
    int             returnVal;
    
    returnVal = pthread_attr_init(&attr);
    assert(!returnVal);
    returnVal = pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
    assert(!returnVal);
    
    int threadError = pthread_create(&posixThreadID, &attr, &PosixThreadMainRoutine, NULL);
    
    returnVal = pthread_attr_destroy(&attr);
    assert(!returnVal);
    if (threadError != 0)
    {
        // Report an error.
    }
}


@interface CreatePassengerContract ()
@property (strong, nonatomic) IBOutlet UITextField *second;

@end

@implementation CreatePassengerContract

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    bDriverStatusThread = true;
    if (driver_email != nil)
    {
        self.contract_driver_nm.text  = driver_name;
        self.contract_driver_phonenumber.text = driverPhone;
    }
    
    LaunchThread();
    SEL mySelector = @selector(myTimerCallback:);
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:mySelector userInfo:nil repeats:YES];
   
    self.flagOfAjaxCall = 0;
    self.message = -1;
    
    self.mapView.delegate = self;
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation = YES;
    
    self.stateOfContract = 0;
    
    
    self.driverIcon.hidden = true;
    //---------my trip position(trip position)-------
    MKPointAnnotation *annot2 = [[MKPointAnnotation alloc] init];
    annot2.title = @"Trip location";
    annot2.subtitle = @"This is user's trip location";
    
    CLLocationCoordinate2D touchMapCoordinate2;
    touchMapCoordinate2 = CLLocationCoordinate2DMake(trip_lat, trip_lon);
    annot2.coordinate = touchMapCoordinate2;
    [self.mapView addAnnotation:annot2];
    
    
    //---------user position(user position)-------
    MKPointAnnotation *annot3 = [[MKPointAnnotation alloc] init];
    annot3.title = @"User location";
    annot3.subtitle = @"This is user location";
    
    CLLocationCoordinate2D touchMapCoordinate3;
    touchMapCoordinate3 = CLLocationCoordinate2DMake(user_lat, user_lon);
    annot3.coordinate = touchMapCoordinate3;
    [self.mapView addAnnotation:annot3];

    
   
    
    //move to current user location.
    float spanX = 0.2;
    float spanY = 0.2;
    MKCoordinateRegion region;
    region.center.latitude = user_lat;
    region.center.longitude = user_lon;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    [self.mapView setRegion:region animated:YES];
    
    self.flagOfKeyboard = false;
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
- (IBAction)go_settings:(id)sender {
    passengerSettingPrevPage = @"createpassengercontract";
}

- (IBAction)call_driver:(id)sender
{
   /* NSURL *phoneNumber = [[NSURL alloc] initWithString: @"tel:867-5309"];
    [[UIApplication sharedApplication] openURL: phoneNumber];
   /* NSString *phoneNumber = @"tel:867-5309";
    UIWebView *webView = [[UIWebView alloc] init];
    NSURL *url = [NSURL URLWithString:phoneNumber];
    NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];
    webView.dataDetectorTypes = UIDataDetectorTypeNone;
    [webView loadRequest:requestURL];*/
    /*
    NSString *phoneNumber = [@"tel://" stringByAppendingString:@"15940581953"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];*/
    
    /*NSString *phoneNumber = [@"telprompt://" stringByAppendingString:@"15940581953"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    
    /*
    NSString *cleanedString = [[@"telprompt://55555555555" componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    NSString *escapedPhoneNumber = [cleanedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *phoneURLString = [NSString stringWithFormat:@"telprompt:%@", escapedPhoneNumber];
    NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneURL]) {
        [[UIApplication sharedApplication] openURL:phoneURL];
    }*/
    if (self.stateOfContract == 1)
    {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.contract_driver_phonenumber.text]]];
        showAlertMessage(self.contract_driver_phonenumber.text);
    }
}

-(void)myTimerCallback:(NSTimer*)timer
{
    if (threadFlag == true)
    {
        if (self.flagOfAjaxCall == 0)
        {
            self.flagOfAjaxCall = 1;
            NSString *url1 = [NSString stringWithFormat:@"http://bernietaxi.com/service/Passenger/GetContractInfo?user_id=%d&trip_id=%d", user_id,trip_id];
            NSURL *fileURL = [NSURL URLWithString:url1];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:fileURL cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:30.0];
            NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        }
        threadFlag = false;
    }
    
    if (self.message == 0)
    {
        showAlertMessage(@"New driver accepted your contract");
        self.contract_driver_nm.text = driver_name;
        self.contract_driver_phonenumber.text = driverPhone;
        
        //---------my driver position(trip position)-------
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@",  @"Driver location"];
        [self.mapView removeAnnotations:[self.mapView.annotations filteredArrayUsingPredicate:predicate]];
        
        MKPointAnnotation *annot = [[MKPointAnnotation alloc] init];
        annot.title = @"Driver location";
        annot.subtitle = @"This is driver location";
        
        CLLocationCoordinate2D touchMapCoordinate;
        touchMapCoordinate = CLLocationCoordinate2DMake(driver_lat,driver_lon );
        annot.coordinate = touchMapCoordinate;
        [self.mapView addAnnotation:annot];
        
        self.stateOfContract = 1;
    }
    if (self.message == 1)
    {
        self.driverIcon.hidden = false;
        self.contract_driver_nm.text = driver_name;
        self.contract_driver_phonenumber.text = driverPhone;
        //ShowDriverMarker(false);
        
        
        //---------my driver position(trip position)-------
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@",  @"Driver location"];
        [self.mapView removeAnnotations:[self.mapView.annotations filteredArrayUsingPredicate:predicate]];
        
        MKPointAnnotation *annot = [[MKPointAnnotation alloc] init];
        annot.title = @"Driver location";
        annot.subtitle = @"This is driver location";
        
        CLLocationCoordinate2D touchMapCoordinate;
        touchMapCoordinate = CLLocationCoordinate2DMake(driver_lat,driver_lon );
        annot.coordinate = touchMapCoordinate;
        [self.mapView addAnnotation:annot];
        
        self.stateOfContract = 1;
    }
    if (self.message == 2)
    {
        showAlertMessage(@"Sorry, Your driver cancelled your contract");
        self.contract_driver_nm.text = @"Waiting";
        self.contract_driver_phonenumber.text = @"Waiting";
        /*
        
        [self.mapView removeAnnotations:self.mapView.annotations];
        //---------my trip position(trip position)-------
        MKPointAnnotation *annot2 = [[MKPointAnnotation alloc] init];
        annot2.title = @"Trip location";
        annot2.subtitle = @"This is user's trip location";
        
        CLLocationCoordinate2D touchMapCoordinate2;
        touchMapCoordinate2 = CLLocationCoordinate2DMake(trip_lat, trip_lon);
        annot2.coordinate = touchMapCoordinate2;
        [self.mapView addAnnotation:annot2];*/
        
        self.stateOfContract = 0;
    }
    
    self.message = -1;
}

- (IBAction)do_confirm_completion:(id)sender {
    if (self.stateOfContract == 1)
    {
        if (self.flagOfAjaxCall == 0)
        {
            self.flagOfAjaxCall = 2;
            
            int status;
            if (trip_premium == 1) status = 5; //STATUS_TRIP_PAID
            else status = 4;//STATUS_TRIP_FINISH
            
            NSString *url1 = [NSString stringWithFormat:@"http://bernietaxi.com/service/Passenger/GivePaidToDriver?user_id=%d&trip_id=%d&driver_id=%d&status=%d"
                              , user_id,trip_id, driver_id, status];
            NSURL *fileURL = [NSURL URLWithString:url1];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:fileURL cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:30.0];
            NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        }
    }else
    {
        showAlertMessage(@"Drivers didn't accept your contract yet");
    }
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
- (IBAction)showDriverLoc:(id)sender {
    if (self.stateOfContract == 1)
    {
        float spanX = 0.00725;
        float spanY = 0.00725;
        MKCoordinateRegion region;
        region.center.latitude = driver_lat;//self.mapView.userLocation.coordinate.latitude;
        region.center.longitude = driver_lon;//self.mapView.userLocation.coordinate.longitude;
        region.span.latitudeDelta = spanX;
        region.span.longitudeDelta = spanY;
        //self.searchButton.hidden = YES;
        @try {
            [self.mapView setRegion:region animated:YES];
        }
        @catch (NSException *exception) {
            
        }
    }else{
        showAlertMessage(@"Driver didn't accept your contract yet");
    }
}

- (IBAction)showUserLoc:(id)sender {
    
    float spanX = 0.00725;
    float spanY = 0.00725;
    MKCoordinateRegion region;
    region.center.latitude = g_curLatitude;//user_lat;//self.mapView.userLocation.coordinate.latitude;
    region.center.longitude = g_curLongitude;//user_lon;//self.mapView.userLocation.coordinate.longitude;
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

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response { _responseData = [[NSMutableData alloc] init];}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {   [_responseData appendData:data];}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse {   return nil;}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSString *tmp = [[NSString alloc] initWithData:_responseData encoding:NSASCIIStringEncoding];
    
    NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:[tmp dataUsingEncoding:NSUTF8StringEncoding]
                                                          options:0 error:NULL];
    
    NSArray *resultCode = [jsonObject valueForKey:@"resultCode"];
    
    if (compareString(resultCode,@""))
    {
        self.flagOfAjaxCall = 0;
        return;
    }
    
    if (compareString(resultCode, @"fail"))
    {
        self.flagOfAjaxCall = 0;
        return;
    }
    
    if (compareString(resultCode, @"ok"))
    {
        if (self.flagOfAjaxCall == 2)
        {
            bDriverStatusThread = false;
            trip_status = 4;//STATUS_TRIP_FINISH
            self.flagOfAjaxCall = 0;
            
            //-----------redirecting
            UIStoryboard *mainStorynboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *documetController = [mainStorynboard instantiateViewControllerWithIdentifier:@"passengercontractfinish"];
            [self.navigationController pushViewController:documetController animated:YES];
            return;
        }
        //------trip info-------
        NSArray *trip_information = [jsonObject valueForKey:@"trip"];
        
        trip_premium = jsonIntValidate([jsonObject valueForKey:@"trip_premium"]);
        
        int temp_driver_id = 0;
        NSString *temp_driver_name = nil;
        NSString *temp_driver_license_card = nil;
        NSString *temp_driverPhone = nil;
        double temp_driver_lat = 0;
        double temp_driver_lon = 0;
        
        temp_driver_id = jsonIntValidate([trip_information valueForKey:@"driver_id"]);
                                         
                
        if (jsonIntValidate([trip_information valueForKey:@"driver_id"]) > 0)
        {
           
            temp_driver_name = [trip_information valueForKey:@"driver_name"];
            temp_driver_license_card = [trip_information valueForKey:@"driver_license_card"];
            temp_driverPhone = [trip_information valueForKey:@"driver_phone"];
            temp_driver_lat = [[trip_information valueForKey:@"driver_lat"] doubleValue];
            temp_driver_lon = [[trip_information valueForKey:@"driver_lon"] doubleValue];
           
        }
        
        if (jsonIntValidate([trip_information valueForKey:@"driver_id"]) > 0)
        {
            trip_status = 2;//STATUS_TRIP_DRIVER_ACCEPTED
            
            if (driver_id <= 0)
            {
                driver_id = temp_driver_id;
                driver_name = temp_driver_name;
                driver_license_card =temp_driver_license_card;
                driverPhone = temp_driverPhone ;
                driver_lat = temp_driver_lat ;
                driver_lon = temp_driver_lon ;
                self.message = 0;//sendmessage(0)
            }else{
                
                self.message = 1;//sendmessage(1)
            }
        }else
        {
            trip_status = 1; //STATUS_TRIP_CREATED
            if (driver_id > 0)
            {
                set_default_driver();
                
                self.message = 2;//sendmessage(2)
            }
        }
        
        self.flagOfAjaxCall = 0;
    }
}

@end
