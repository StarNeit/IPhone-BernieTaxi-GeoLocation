//
//  SecondView.m
//  example5
//
//  Created by PLEASE on 03/01/16.
//  Copyright © 2016 zaltan nyhether. All rights reserved.
//
#import "DriverLogin.h"

@interface DriverLogin ()

@end

@implementation DriverLogin

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
- (IBAction)do_login_driver:(id)sender {
    if (compareString(self.driver_email.text,@""))
    {
        showAlertMessage(@"Email is required");
        return;
    }
    if (compareString(self.driver_password.text,@""))
    {
        showAlertMessage(@"Password is required");
        return;
    }
    if (self.flagOfAjaxCall == 0)
    {
        NSString *url1 = [NSString stringWithFormat:@"http://bernietaxi.com/service/Driver/Login?email=%@&password=%@", self.driver_email.text,[self.driver_password.text MD5]];
        NSURL *fileURL = [NSURL URLWithString:url1];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:fileURL cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:30.0];
        // Create url connection and fire request
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
        self.flagOfAjaxCall = 1;
    }
}

 - (void) getContractList
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

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    _responseData = [[NSMutableData alloc] init];
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

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
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
            dc_email = self.driver_email.text;
            dc_password = self.driver_password.text;
            
            //----------save to db
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:dc_email forKey:@"d_email"];
            [defaults setValue:dc_password forKey:@"d_password"];
            [defaults synchronize];
            
            
            // Extract values:
            NSArray *driver_information = [jsonObject valueForKey:@"driver"];
            
            
            int driver_enabled = jsonIntValidate([driver_information valueForKey:@"driver_enabled"]);
            int driver_delete = jsonIntValidate([driver_information valueForKey:@"driver_deleted"]);
            
            
            if(driver_enabled != 1){
                showAlertMessage(@"Your account has been Suspended");
                self.flagOfAjaxCall = 0;
                return;
            }
            if(driver_delete != 0){
                showAlertMessage(@"Your accont has been Deleted");
                self.flagOfAjaxCall = 0;
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
                [self getContractList];
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
                    [self getContractList];
                    //-----------redirecting
                    UIStoryboard *mainStorynboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    UIViewController *documetController = [mainStorynboard instantiateViewControllerWithIdentifier:@"driverpickcontract"];
                    [self.navigationController pushViewController:documetController animated:YES];
                }
                else    //STATUS_TRIP_CREATED
                {
                    [self getContractList];
                    //-----------redirecting
                    UIStoryboard *mainStorynboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    UIViewController *documetController = [mainStorynboard instantiateViewControllerWithIdentifier:@"driverpickcontract"];
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
