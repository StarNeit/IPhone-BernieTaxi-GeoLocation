//
//  SecondView.m
//  example5
//
//  Created by PLEASE on 03/01/16.
//  Copyright © 2016 zaltan nyhether. All rights reserved.
//
#import "RegisterDriverAccount.h"

@interface RegisterDriverAccount ()
@property (strong, nonatomic) IBOutlet UITextField *second;

@end

@implementation RegisterDriverAccount

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.flagOfAjaxCall = 0;
    self.flagOfKeyboard = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)do_signup_driver:(id)sender {
    if (compareString(self.driver_name.text, @""))
    {
        showAlertMessage(@"Name is required");
        return;
    }
    if (compareString(self.driver_email.text, @""))
    {
        showAlertMessage(@"Email is required");
        return;
    }
    if (compareString(self.driver_password.text, @""))
    {
        showAlertMessage(@"Password is required");
        return;
    }
    if (compareString(self.driver_verifypassword.text, @""))
    {
        showAlertMessage(@"Password is required");
        return;
    }
    if (compareString(self.driver_phone_number.text, @""))
    {
        showAlertMessage(@"PhoneNumber is required");
        return;
    }
    if (compareString(self.driver_license_card.text, @""))
    {
        showAlertMessage(@"Driver License Card is required");
        return;
    }
   
    
    if (self.flagOfAjaxCall == 0)
    {
        NSString *url1 = [NSString stringWithFormat:@"http://bernietaxi.com/service/Driver/RegisterDriver?name=%@&email=%@&password=%@&phone=%@&license=%@&deviceType=iphone&paypal=&deviceToken=",
                          self.driver_name.text,self.driver_email.text, [self.driver_password.text MD5], self.driver_phone_number.text, self.driver_license_card.text];
        NSURL *fileURL = [NSURL URLWithString:url1];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:fileURL
                                                               cachePolicy:NSURLCacheStorageNotAllowed
                                                           timeoutInterval:30.0];
 
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
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
        //self.signupbut.enabled = true;
        //----------
        // Convert to JSON object:
        NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:[tmp dataUsingEncoding:NSUTF8StringEncoding]
                                                              options:0 error:NULL];
        
        NSArray *resultCode = [jsonObject valueForKey:@"resultCode"];
        
        if (compareString(resultCode,@""))
        {
            showAlertMessage(@"Failed. Check Your Internet Connection");
            self.flagOfAjaxCall = 0;
            return;
        }
        
        if (!compareString(resultCode, @"ok"))
        {
            showAlertMessage(@"Your E-mail Address Already Exist");
            self.flagOfAjaxCall = 0;
            return;
        }
        
        flagOfUser = 2;
        // Extract values:
        NSArray *user_information = [jsonObject valueForKey:@"driver"];
        NSLog(@"user_information=%@", user_information);
        
        driver_id = [[user_information valueForKey:@"driver_id"] intValue];
        driver_email = [user_information valueForKey:@"driver_email"];
        driver_name = [user_information valueForKey:@"driver_name"];
        driver_license_card = [user_information valueForKey:@"driver_license_card"];
        driver_paypal = [user_information valueForKey:@"driver_paypal"];
        driverPhone = [user_information valueForKey:@"driver_phone"];
        driver_lat = [[user_information valueForKey:@"driver_lat"] doubleValue];
        driver_lon = [[user_information valueForKey:@"driver_lon"] doubleValue];
        
        
        //----------save to db
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:self.driver_email.text forKey:@"d_email"];
        [defaults setValue:self.driver_password.text forKey:@"d_password"];
        [defaults synchronize];
        dc_email = self.driver_email.text;
        dc_password = self.driver_password.text;
        
        set_default_passenger();
        [self getContractList];
        //-----------redirecting
        UIStoryboard *mainStorynboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *documetController = [mainStorynboard instantiateViewControllerWithIdentifier:@"driverpickcontract"];
        [self.navigationController pushViewController:documetController animated:YES];
        
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
- (void)registerForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)deregisterFromKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self registerForKeyboardNotifications];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [self deregisterFromKeyboardNotifications];
    
    [super viewWillDisappear:animated];
    
}


- (void)keyboardWasShown:(NSNotification *)notification {
    
    NSDictionary* info = [notification userInfo];
    
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGPoint buttonOrigin = self.mButton.frame.origin;
    
    CGFloat buttonHeight = self.mButton.frame.size.height;
    
    CGRect visibleRect = self.view.frame;
    
    visibleRect.size.height -= keyboardSize.height;
    
    if (!CGRectContainsPoint(visibleRect, buttonOrigin)){
        
        CGPoint scrollPoint = CGPointMake(0.0, buttonOrigin.y - visibleRect.size.height + buttonHeight);
        
        [self.uiScrollView setContentOffset:scrollPoint animated:YES];
        
    }
    
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    
    [self.uiScrollView setContentOffset:CGPointZero animated:YES];
    
}
@end
