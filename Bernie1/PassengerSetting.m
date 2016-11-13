//
//  SecondView.m
//  example5
//
//  Created by PLEASE on 03/01/16.
//  Copyright © 2016 zaltan nyhether. All rights reserved.
//
#import "PassengerSetting.h"

@interface PassengerSetting ()
@property (strong, nonatomic) IBOutlet UITextField *second;

@end

@implementation PassengerSetting

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.flagOfService = 0;
    self.passenger_name.text = user_name;
    self.passenger_email.text = user_email;
    self.passenger_phonenumber.text = user_phone;
    self.passenger_address.text = user_address;
    
    bDriverStatusThread = false;
    self.flagOfKeyboard = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)do_passenger_logout:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"" forKey:@"s_email"];
    [defaults setValue:@"" forKey:@"s_password"];
    [defaults synchronize];
    
    lc_password = @"";
    lc_email = @"";
}


- (IBAction)do_change_profile:(id)sender {
    if (compareString(self.passenger_name.text, @""))
    {
        showAlertMessage(@"Name is required");
        return;
    }
    if (compareString(self.passenger_email.text, @""))
    {
        showAlertMessage(@"Email is required");
        return;
    }
    if (compareString(self.passenger_phonenumber.text, @""))
    {
        showAlertMessage(@"PhoneNumber is required");
        return;
    }
    if (compareString(self.passenger_address.text, @""))
    {
        showAlertMessage(@"Address is required");
        return;
    }
    if (self.flagOfService == 0)
    {
    self.flagOfService = 1;
    
    NSString *url1 = [NSString stringWithFormat:@"http://bernietaxi.com/service/Passenger/UpdatePassengerInfo?name=%@&email=%@&phone=%@&address=%@&id=%d",
                      self.passenger_name.text,self.passenger_email.text,self.passenger_phonenumber.text,self.passenger_address.text,user_id];
    NSURL *fileURL = [NSURL URLWithString:url1];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:fileURL cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:30.0];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
}
- (IBAction)do_change_password:(id)sender {
    if (compareString(self.ns_password.text, @""))
    {
        showAlertMessage(@"Password is required");
        return;
    }
    if (compareString(self.verify_pasword.text, @""))
    {
        showAlertMessage(@"Password is required");
        return;
    }
    if (!compareString(self.ns_password.text, self.verify_pasword.text))
    {
        showAlertMessage(@"Password doesn't match");
        return;
    }
    if (self.flagOfService == 0)
    {
        self.flagOfService = 2;
        NSString *url1 = [NSString stringWithFormat:@"http://bernietaxi.com/service/Passenger/UpdatePassengerPassword?password=%@&id=%d",
                          [self.ns_password.text MD5],user_id];
        NSURL *fileURL = [NSURL URLWithString:url1];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:fileURL cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:30.0];
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
}

- (IBAction)go_backpage:(id)sender {
    //-----------redirecting
    UIStoryboard *mainStorynboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *documetController = [mainStorynboard instantiateViewControllerWithIdentifier:passengerSettingPrevPage];
    [self.navigationController pushViewController:documetController animated:YES];
}
#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _responseData = [[NSMutableData alloc] init];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *tmp = [[NSString alloc] initWithData:_responseData encoding:NSASCIIStringEncoding];
    
    NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:[tmp dataUsingEncoding:NSUTF8StringEncoding]
                                                          options:0 error:NULL];
    //NSLog(jsonObject);
    NSArray *resultCode = [jsonObject valueForKey:@"resultCode"];
    
    if (compareString(resultCode,@""))
    {
        showAlertMessage(@"Failed. Check Your Internet Connection");
        self.flagOfService = 0;
        return;
    }
    
    if (compareString(resultCode, @"fail"))
    {
        NSString *warning;
        if (self.flagOfService == 1) warning = @"Change Profile Failed";
        else if (self.flagOfService == 2) warning = @"Password Update Failed";
        showAlertMessage(warning);
        self.flagOfService = 0;
        return;
    }
    
    if (compareString(resultCode, @"exist"))
    {
        showAlertMessage(@"Your E-mail Address Already Exist");
        self.flagOfService = 0;
        return;
    }
    if (compareString(resultCode, @"ok"))
    {
        if (self.flagOfService == 1)
        {
            lc_email = self.passenger_email.text;
            showAlertMessage(@"Profile Updated Successfully");
        }
        if (self.flagOfService == 2 )
        {
            lc_password = self.ns_password.text;
            showAlertMessage(@"Password Updated Successfully");
        }
        
        //----------save to db
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:lc_email forKey:@"s_email"];
        [defaults setValue:lc_password forKey:@"s_password"];
        [defaults synchronize];
    }
    self.flagOfService = 0;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    showAlertMessage(@"Failed. Try again.");
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
