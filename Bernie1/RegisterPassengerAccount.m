//
//  SecondView.m
//  example5
//
//  Created by PLEASE on 03/01/16.
//  Copyright © 2016 zaltan nyhether. All rights reserved.
//
#import "RegisterPassengerAccount.h"
#import <CommonCrypto/CommonDigest.h>




@interface RegisterPassengerAccount ()


@end


@implementation RegisterPassengerAccount


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



- (IBAction)doPassengerSignUp:(id)sender
{
  if (compareString(self.firstnm.text, @""))
  {
      showAlertMessage(@"Name is required!");
      return;
  }
    if (compareString(self.email.text, @""))
    {
        showAlertMessage(@"Email is required!");
        return;
    }
    if (compareString(self.password.text, @""))
    {
        showAlertMessage(@"Password is required!");
        return;
    }
    if (compareString(self.passwordverify.text, @""))
    {
        showAlertMessage(@"Password is required!");
        return;
    }
    if (compareString(self.phonenumber.text, @""))
    {
        showAlertMessage(@"PhoneNumber is required!");
        return;
    }
    if (compareString(self.address.text, @""))
    {
        showAlertMessage(@"Address is required!");
        return;
    }
    if (!compareString(self.password.text, self.passwordverify.text))
    {
        showAlertMessage(@"Password dosen't match");
        return;
    }
   
    if (self.flagOfAjaxCall == 0)
    {
        NSString *url1 = [NSString stringWithFormat:@"http://bernietaxi.com/service/Passenger/RegisterPassenger?name=%@&email=%@&password=%@&phone=%@&address=%@&deviceType=iphone&deviceToken=",
                          self.firstnm.text,self.email.text, [self.password.text MD5], self.phonenumber.text, self.address.text];
        NSURL *fileURL = [NSURL URLWithString:url1];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:fileURL
                                                               cachePolicy:NSURLCacheStorageNotAllowed
                                                           timeoutInterval:30.0];
        // Create url connection and fire request
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        self.flagOfAjaxCall = 1;
    }
}
- (IBAction)didexitedit:(id)sender {
}


#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _responseData = [[NSMutableData alloc] init];
    //self.signupbut.enabled = false;
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
        
        flagOfUser = 1;
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
        user_id = [[user_information valueForKey:@"user_id"] intValue];
        user_email = [user_information valueForKey:@"user_email"];
        user_name = [user_information valueForKey:@"user_name"];
        NSArray* user_password = [user_information valueForKey:@"user_password"];
        user_phone = [user_information valueForKey:@"user_phone"];
        user_address = [user_information valueForKey:@"user_address"];
        user_lat = [[user_information valueForKey:@"user_lat"] doubleValue];
        user_lon = [[user_information valueForKey:@"user_lon"] doubleValue];
        user_regdate = [user_information valueForKey:@"user_regdate"];
        
        set_default_driver();
        
        
        //----------save to db
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:user_email forKey:@"s_email"];
        [defaults setValue:self.password.text forKey:@"s_password"];
        [defaults synchronize];
        
        //-----------redirecting
        UIStoryboard *mainStorynboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *documetController = [mainStorynboard instantiateViewControllerWithIdentifier:@"passengercontractsubmit"];
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