//
//  ViewController.m
//  Bernie1
//
//  Created by PLEASE on 03/01/16.
//  Copyright © 2016 zaltan nyhether. All rights reserved.
//

#import "ViewController.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface ViewController ()

@end

@implementation ViewController{
    CLLocationManager *locationManager;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.flagOfLogin = 0;
    bDriverStatusThread = false;
 /*
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"BernieTaxi"
                                                     message:@"This is OK dialog"
                                                    delegate:self
                                           cancelButtonTitle:@"Yes"
                                           otherButtonTitles: nil];
    [alert addButtonWithTitle:@"No"];
    [alert show];*/
    
    self.gpsFlag = false;
    
    
    //----------GPS location----------
    self->locationManager = [[CLLocationManager alloc] init];
    
    self->locationManager.delegate = self;
    if(IS_OS_8_OR_LATER){
        NSUInteger code = [CLLocationManager authorizationStatus];
        if (code == kCLAuthorizationStatusNotDetermined && ([self->locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [self->locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
            // choose one request according to your business.
            if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
                [self->locationManager requestAlwaysAuthorization];
            } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
                [self->locationManager  requestWhenInUseAuthorization];
            } else {
                NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
            }
        }
    }
    [self->locationManager startUpdatingLocation];
    
    //------------timer-------------
    SEL mySelector = @selector(myTimerCallback:);
    [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:mySelector userInfo:nil repeats:YES];
    
    flagOfUser = 0;//define
}

-(void)myTimerCallback:(NSTimer*)timer
{
    self.gpsFlag = true;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    /*
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];*/
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    CLLocationDistance distance = [newLocation distanceFromLocation:oldLocation];
    if (distance >= 0 && self.gpsFlag == true)
    {
        if (user_id > 0 && flagOfUser == 1) //passenger
        {
            if (self.flagOfLogin == 0)
            {
                NSString *url1 = [NSString stringWithFormat:@"http://bernietaxi.com/service/Passenger/UpdatePassengerLocation?id=%d&lat=%f&lon=%f",user_id,newLocation.coordinate.latitude,newLocation.coordinate.longitude];
                NSURL *fileURL = [NSURL URLWithString:url1];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:fileURL cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:30.0];
                [[NSURLConnection alloc] initWithRequest:request delegate:self];
                self.flagOfLogin = 4;
            }
        }
        if (driver_id > 0 && flagOfUser == 2) //driver
        {
            if (self.flagOfLogin == 0)
            {
                NSString *url1 = [NSString stringWithFormat:@"http://bernietaxi.com/service/Driver/UpdateDriverLocation?id=%d&lat=%f&lon=%f",driver_id,newLocation.coordinate.latitude,newLocation.coordinate.longitude];
                NSURL *fileURL = [NSURL URLWithString:url1];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:fileURL cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:30.0];
                [[NSURLConnection alloc] initWithRequest:request delegate:self];
                self.flagOfLogin = 5;
            }
        }
        self.gpsFlag = false;
    }
    if (currentLocation != nil) {
        //self.lon.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        //self.lat.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        g_curLongitude = currentLocation.coordinate.longitude;
        g_curLatitude = currentLocation.coordinate.latitude;
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button Index =%ld",buttonIndex);
    if (buttonIndex == 0)
    {
        NSLog(@"You have clicked Cancel");
    }
    else if(buttonIndex == 1)
    {
        NSLog(@"You have clicked GOO");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)do_getride:(id)sender {
    if (self.flagOfLogin == 0)
    {
        //-------get_passenger_login_credentials------
        NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
        lc_email = [defaults1 valueForKey:@"s_email"];
        lc_password = [defaults1 valueForKey:@"s_password"];

        //--------redirecting--------
        if (!compareString(lc_email,@"") && lc_email != nil)
        {
            NSString *url1 = [NSString stringWithFormat:@"http://bernietaxi.com/service/Passenger/Login?email=%@&password=%@",lc_email,[lc_password MD5]];
            NSURL *fileURL = [NSURL URLWithString:url1];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:fileURL cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:30.0];
            NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            self.flagOfLogin = 1;
        }else
        {
            UIStoryboard *mainStorynboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *documetController;
            documetController = [mainStorynboard instantiateViewControllerWithIdentifier:@"registerpassengeraccount"];
            [self.navigationController pushViewController:documetController animated:YES];
        }
    }
}
- (IBAction)do_volunteer_driver:(id)sender
{
    if (self.flagOfLogin == 0)
    {
        //-------get_driver_login_credentials------
        NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
        dc_email = [defaults1 valueForKey:@"d_email"];
        dc_password = [defaults1 valueForKey:@"d_password"];
        
        //--------redirecting--------
        if (!compareString(dc_email,@"") && dc_email != nil)
        {
            NSString *url1 = [NSString stringWithFormat:@"http://bernietaxi.com/service/Driver/Login?email=%@&password=%@", dc_email,[dc_password MD5]];
            NSURL *fileURL = [NSURL URLWithString:url1];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:fileURL cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:30.0];
            // Create url connection and fire request
            NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            self.flagOfLogin = 2;
        }else
        {
            UIStoryboard *mainStorynboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *documetController;
            documetController = [mainStorynboard instantiateViewControllerWithIdentifier:@"registerdriveraccount"];
            [self.navigationController pushViewController:documetController animated:YES];
        }
    }
}

void getContractList()
{
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://bernietaxi.com/service/Driver/GetContractList"]];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error ];
    if (error == nil)
    {
        // Parse data here
        NSString *tmp = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:[tmp dataUsingEncoding:NSUTF8StringEncoding]
                                                              options:0 error:NULL];
        NSArray *resultCode = [jsonObject valueForKey:@"resultCode"];
        if (compareString(resultCode, @"fail"))
        {
            pContractCnt = 0;
            for (int i = 0 ; i < 30; i ++)
            {
                pContractNameList[i] = @"";
            }
            return;
        }
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

- (IBAction)doDonate:(id)sender {
    
   // NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://bernietaxi.com/service/donate"]];
    
    //[[UIApplication sharedApplication] openURL:@"http://bernietaxi.com/service/donate"];
    
    UIApplication *mySafari = [UIApplication sharedApplication];
    NSURL *myURL = [[NSURL alloc]initWithString:@"http://bernietaxi.com/service/donate"];
    [mySafari openURL:myURL];
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {  _responseData = [[NSMutableData alloc] init]; }

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data { [_responseData appendData:data];}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse {  return nil;}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    if (self.flagOfLogin == 4 || self.flagOfLogin == 5)
    {
        self.flagOfLogin = 0;
        return;
    }
    
    NSString *tmp = [[NSString alloc] initWithData:_responseData encoding:NSASCIIStringEncoding];
    NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:[tmp dataUsingEncoding:NSUTF8StringEncoding]
                                                          options:0 error:NULL];
    NSArray *resultCode = [jsonObject valueForKey:@"resultCode"];
    
    if (compareString(resultCode,@""))
    {
        showAlertMessage(@"Failed. Check Your Internet Connection");
        self.flagOfLogin = 0;
        return;
    }
    
    if (compareString(resultCode, @"fail"))
    {
        UIStoryboard *mainStorynboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *documetController;
        if (self.flagOfLogin == 1)
            documetController = [mainStorynboard instantiateViewControllerWithIdentifier:@"registerpassengeraccount"];
        else
            documetController = [mainStorynboard instantiateViewControllerWithIdentifier:@"registerdriveraccount"];
        [self.navigationController pushViewController:documetController animated:YES];
        self.flagOfLogin = 0;
        return;
    }
    
    if (self.flagOfLogin == 1)
    {
        if (compareString(resultCode, @"ok"))
        {
            // Extract values:
            NSArray *user_information = [jsonObject valueForKey:@"user"];
            
            user_id = jsonIntValidate([user_information valueForKey:@"user_id"]);
            user_email = [user_information valueForKey:@"user_email"];
            user_name = [user_information valueForKey:@"user_name"];
            user_phone = [user_information valueForKey:@"user_phone"];
            user_address = [user_information valueForKey:@"user_address"];
            user_lat = jsonDoubleValidate([user_information valueForKey:@"user_lat"]);
            user_lon = jsonDoubleValidate([user_information valueForKey:@"user_lon"]);
            user_regdate = [user_information valueForKey:@"user_regdate"];
            NSArray *user_enabled = [user_information valueForKey:@"user_enabled"];
            NSArray *user_delete = [user_information valueForKey:@"user_deleted"];
            
            
            if(!compareString(user_enabled,@"1")){
                showAlertMessage(@"Your account has been Suspended");
                self.flagOfLogin = 0;
                return;
            }
            if(!compareString(user_delete,@"0")){
                showAlertMessage(@"Your accont has been Deleted");
                self.flagOfLogin = 0;
                return;
            }
            
            flagOfUser = 1;
            //------trip info-------
            NSArray *trip_information = [jsonObject valueForKey:@"trip"];
            NSLog(@"trip_information=%@", trip_information);
            trip_id = jsonIntValidate([trip_information valueForKey:@"trip_id"]);
            if (trip_id == 0)
            {
                self.flagOfLogin = 0;
                //-----------redirecting
                UIStoryboard *mainStorynboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController *documetController = [mainStorynboard instantiateViewControllerWithIdentifier:@"passengercontractsubmit"];
                [self.navigationController pushViewController:documetController animated:YES];
            }
            else
            {
                trip_lat = jsonDoubleValidate([trip_information valueForKey:@"trip_lat"]);
                trip_lon = [[trip_information valueForKey:@"trip_lon"] doubleValue];
                trip_promise_time = [trip_information valueForKey:@"trip_promise_time"];
                trip_address = [trip_information valueForKey:@"trip_address"];
                trip_status = jsonIntValidate([trip_information valueForKey:@"trip_status"]);
                trip_regdate = [trip_information valueForKey:@"trip_regdate"];
                
                driver_id = jsonIntValidate([trip_information valueForKey:@"driver_id"]);
                
                
                if(driver_id > 0)
                {
                    driver_name = [trip_information valueForKey:@"driver_name"];
                    driver_license_card = [trip_information valueForKey:@"driver_license_card"];
                    driverPhone = [trip_information valueForKey:@"driver_phone"];
                    driver_lat = jsonDoubleValidate([trip_information valueForKey:@"driver_lat"]);
                    driver_lon = jsonDoubleValidate([trip_information valueForKey:@"driver_lon"]);
                }
                self.flagOfLogin = 0;
                if(trip_status == 4 || trip_status == 5) //STATUS_TRIP_FINISH , STATUS_TRIP_PAID
                {
                    //-----------redirecting
                    UIStoryboard *mainStorynboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    UIViewController *documetController = [mainStorynboard instantiateViewControllerWithIdentifier:@"use_another_account"];
                    [self.navigationController pushViewController:documetController animated:YES];
                }
                else if(trip_status == 3 || trip_status == 2 || trip_status == 1) //STATUS_TRIP_ONGOING , STATUS_TRIP_DRIVER_ACCEPTED, STATUS_TRIP_CREATED
                {
                    //-----------redirecting
                    UIStoryboard *mainStorynboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    UIViewController *documetController = [mainStorynboard instantiateViewControllerWithIdentifier:@"createpassengercontract"];
                    [self.navigationController pushViewController:documetController animated:YES];
                }else
                {
                    //-----------redirecting
                    UIStoryboard *mainStorynboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    UIViewController *documetController = [mainStorynboard instantiateViewControllerWithIdentifier:@"passengercontractsubmit"];
                    [self.navigationController pushViewController:documetController animated:YES];
                }
            }
        }
        self.flagOfLogin = 0;
    }
    
    if (self.flagOfLogin == 2)
    {
        if (compareString(resultCode, @"ok"))
        {
            // Extract values:
            NSArray *driver_information = [jsonObject valueForKey:@"driver"];
            
            
            int driver_enabled = jsonIntValidate([driver_information valueForKey:@"driver_enabled"]);
            int driver_delete = jsonIntValidate([driver_information valueForKey:@"driver_deleted"]);
            
            
            if(driver_enabled != 1){
                showAlertMessage(@"Your account has been Suspended");
                self.flagOfLogin = 0;
                return;
            }
            if(driver_delete != 0){
                showAlertMessage(@"Your accont has been Deleted");
                self.flagOfLogin = 0;
                return;
            }
            flagOfUser = 2;
            
            driver_id = jsonIntValidate([driver_information valueForKey:@"driver_id"]);
            driver_name = [driver_information valueForKey:@"driver_name"];
            driver_email = [driver_information valueForKey:@"driver_email"];
            driver_license_card = [driver_information valueForKey:@"driver_license_card"];
            driver_paypal =[driver_information valueForKey:@"driver_paypal"];
            driverPhone =[driver_information valueForKey:@"driver_phone"];
            driver_lat = jsonDoubleValidate([driver_information valueForKey:@"driver_lat"]);
            driver_lon = jsonDoubleValidate([driver_information valueForKey:@"driver_lon"]);
            
            //------trip info-------
            NSArray *trip_information = [jsonObject valueForKey:@"trip"];
            NSLog(@"trip_information=%@", trip_information);
            trip_id = [[trip_information valueForKey:@"trip_id"] intValue];
            if (trip_id == 0)
            {
                set_default_passenger();
                getContractList();
                self.flagOfLogin = 0;
                //-----------redirecting
                UIStoryboard *mainStorynboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController *documetController = [mainStorynboard instantiateViewControllerWithIdentifier:@"driverpickcontract"];
                [self.navigationController pushViewController:documetController animated:YES];
            }
            else
            {
                trip_lat = jsonDoubleValidate([trip_information valueForKey:@"trip_lat"]);
                trip_lon = jsonDoubleValidate([trip_information valueForKey:@"trip_lon"]);
                trip_promise_time = [trip_information valueForKey:@"trip_promise_time"];
                trip_address = [trip_information valueForKey:@"trip_address"];
                trip_status = jsonIntValidate([trip_information valueForKey:@"trip_status"]);
                trip_regdate = [trip_information valueForKey:@"trip_regdate"];
                trip_premium = jsonIntValidate([trip_information valueForKey:@"trip_premium"]);;
                
                user_id = jsonIntValidate([trip_information valueForKey:@"user_id"]);
                user_name = [trip_information valueForKey:@"user_name"];
                user_phone = [trip_information valueForKey:@"user_phone"];
                user_lat = jsonDoubleValidate([trip_information valueForKey:@"user_lat"]);
                user_lon = jsonDoubleValidate([trip_information valueForKey:@"user_lon"]);
                
                g_driverType = trip_premium;
                self.flagOfLogin = 0;
                if(trip_status == 2)//STATUS_TRIP_DRIVER_ACCEPTED
                {
                    //-----------redirecting
                    UIStoryboard *mainStorynboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    UIViewController *documetController = [mainStorynboard instantiateViewControllerWithIdentifier:@"DriverContractShowActivity"];
                    [self.navigationController pushViewController:documetController animated:YES];
                }
                else if(trip_status == 3)//STATUS_TRIP_ONGOING
                {
                    //-----------redirecting
                    UIStoryboard *mainStorynboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    UIViewController *documetController = [mainStorynboard instantiateViewControllerWithIdentifier:@"drivercontractfinish"];
                    [self.navigationController pushViewController:documetController animated:YES];
                }
                else if (trip_status == 4 || trip_status == 5)//STATUS_TRIP_FINISH,STATUS_TRIP_PAID
                {
                    set_default_trip();
                    getContractList();
                    //-----------redirecting
                    UIStoryboard *mainStorynboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    UIViewController *documetController = [mainStorynboard instantiateViewControllerWithIdentifier:@"driverpickcontract"];
                    [self.navigationController pushViewController:documetController animated:YES];
                }
                else    //STATUS_TRIP_CREATED
                {
                    getContractList();
                    //-----------redirecting
                    UIStoryboard *mainStorynboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    UIViewController *documetController = [mainStorynboard instantiateViewControllerWithIdentifier:@"driverpickcontract"];
                    [self.navigationController pushViewController:documetController animated:YES];
                }
            }
        }
        self.flagOfLogin = 0;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	    showAlertMessage(@"Failed.Try agin");
}
@end