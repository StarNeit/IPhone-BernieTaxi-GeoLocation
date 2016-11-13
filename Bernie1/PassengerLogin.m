//
//  SecondView.m
//  example5
//
//  Created by PLEASE on 03/01/16.
//  Copyright © 2016 zaltan nyhether. All rights reserved.
//
#import "PassengerLogin.h"

@interface PassengerLogin ()
@property (strong, nonatomic) IBOutlet UITextField *second;

@end

@implementation PassengerLogin

- (void)viewDidLoad {
    //[super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.flagOfAjaxCall = 0;
    self.flagOfKeyboard = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doPassengerLogin:(id)sender {
    if (compareString(self.email.text,@""))
    {
        showAlertMessage(@"Email is required");
        return;
    }
    if (compareString(self.password.text,@""))
    {
        showAlertMessage(@"Password is required");
        return;
    }
    if (self.flagOfAjaxCall == 0)
    {
        NSString *url1 = [NSString stringWithFormat:@"http://bernietaxi.com/service/Passenger/Login?email=%@&password=%@",
                          self.email.text,[self.password.text MD5]];
        NSURL *fileURL = [NSURL URLWithString:url1];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:fileURL
                                                               cachePolicy:NSURLCacheStorageNotAllowed
                                                           timeoutInterval:30.0];
        // Create url connection and fire request
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        self.flagOfAjaxCall = 1;
    }
}


#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _responseData = [[NSMutableData alloc] init];
    //self.loginbut.enabled  =false;
  
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (self.flagOfAjaxCall == 1)
    {
        NSString *tmp = [[NSString alloc] initWithData:_responseData encoding:NSASCIIStringEncoding];
        
        NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:[tmp dataUsingEncoding:NSUTF8StringEncoding]
                                                              options:0 error:NULL];
        //NSLog(jsonObject);
        NSArray *resultCode = [jsonObject valueForKey:@"resultCode"];
        
        if (compareString(resultCode,@""))
        {
            showAlertMessage(@"Failed. Check Your Internet Connection");
            self.flagOfAjaxCall = 0;
            return;
        }
        
        if (compareString(resultCode, @"fail"))
        {
            showAlertMessage(@"Password is wrong");
            self.flagOfAjaxCall = 0;
            return;
        }
        
        if (compareString(resultCode, @"ok"))
        {
            
            // Extract values:
            NSArray *user_information = [jsonObject valueForKey:@"user"];
            NSArray *user_enabled = [user_information valueForKey:@"user_enabled"];
            NSArray *user_delete = [user_information valueForKey:@"user_deleted"];
            
            
            if(!compareString(user_enabled,@"1")){
                showAlertMessage(@"Your account has been Suspended");
                self.flagOfAjaxCall = 0;
                return;
            }
            if(!compareString(user_delete,@"0")){
                showAlertMessage(@"Your accont has been Deleted");
                self.flagOfAjaxCall = 0;
                return;
            }
            
            flagOfUser = 1;
            
            lc_email = self.email.text;
            lc_password = self.password.text;
            
            //----------save to db
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:lc_email forKey:@"s_email"];
            [defaults setValue:lc_password forKey:@"s_password"];
            [defaults synchronize];
            
            
            user_id = jsonIntValidate([user_information valueForKey:@"user_id"]);
            user_email = [user_information valueForKey:@"user_email"];
            user_name = [user_information valueForKey:@"user_name"];
            user_phone = [user_information valueForKey:@"user_phone"];
            user_address = [user_information valueForKey:@"user_address"];
            user_lat = jsonDoubleValidate([user_information valueForKey:@"user_lat"]);
            user_lon = jsonDoubleValidate([user_information valueForKey:@"user_lon"]);
            user_regdate = [user_information valueForKey:@"user_regdate"];
            
            //------trip info-------
            NSArray *trip_information = [jsonObject valueForKey:@"trip"];
            NSLog(@"trip_information=%@", trip_information);
            trip_id = jsonIntValidate([trip_information valueForKey:@"trip_id"]);
            if (trip_id == 0)
            {
                set_default_trip();
                set_default_driver();
                //-----------redirecting
                UIStoryboard *mainStorynboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController *documetController = [mainStorynboard instantiateViewControllerWithIdentifier:@"passengercontractsubmit"];
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
                
                set_default_driver();
                driver_id = jsonIntValidate([trip_information valueForKey:@"driver_id"]);
                
                
                
                if(driver_id > 0)
                {
                    driver_name = [trip_information valueForKey:@"driver_name"];
                    driver_license_card = [trip_information valueForKey:@"driver_license_card"];
                    driverPhone = [trip_information valueForKey:@"driver_phone"];
                    driver_lat = jsonDoubleValidate([trip_information valueForKey:@"driver_lat"]);
                    driver_lon = jsonDoubleValidate([trip_information valueForKey:@"driver_lon"]);
                }
                
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
