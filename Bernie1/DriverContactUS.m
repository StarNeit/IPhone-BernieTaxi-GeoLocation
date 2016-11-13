//
//  SecondView.m
//  example5
//
//  Created by PLEASE on 03/01/16.
//  Copyright © 2016 zaltan nyhether. All rights reserved.
//
#import "DriverContactUS.h"

@interface DriverContactUS ()
@property (strong, nonatomic) IBOutlet UITextField *second;

@end

@implementation DriverContactUS

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

- (IBAction)do_send_contact:(id)sender {
    if (compareString(self.driver_contact_title.text,@""))
    {
        showAlertMessage(@"Input Title Please");
        return;
    }
    if (compareString(self.driver_contact_content.text,@""))
    {
        showAlertMessage(@"Input Content Please");
        return;
    }
    if (self.flagOfAjaxCall == 0){
        NSString *url1 = [NSString stringWithFormat:@"http://bernietaxi.com/service/Contact?id=%d&user_type=1&title=%@&content=%@",
                          driver_id,self.driver_contact_title.text,self.driver_contact_content.text];
        NSURL *fileURL = [NSURL URLWithString:url1];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:fileURL cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:30.0];
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        self.flagOfAjaxCall = 1;
    }
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.flagOfAjaxCall == 1)
    {
        NSString *tmp = [[NSString alloc] initWithData:_responseData encoding:NSASCIIStringEncoding];
        
        NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:[tmp dataUsingEncoding:NSUTF8StringEncoding]
                                                              options:0 error:NULL];
        if (compareString(tmp, @""))
        {
            showAlertMessage(@"Failed. Check Your Internet Connection");
            self.flagOfAjaxCall = 0;
            return;
        }
        //NSLog(jsonObject);
        NSArray *resultCode = [jsonObject valueForKey:@"resultCode"];
        
        
        if (compareString(resultCode, @"fail"))
        {
            showAlertMessage(@"Unexpected Error, Try again...");
            self.flagOfAjaxCall = 0;
            return;
        }
        
        if (compareString(resultCode, @"ok"))
        {
            showAlertMessage(@"Thank You for Contact Us");
        }
        self.flagOfAjaxCall = 0;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    showAlertMessage(@"Failed. Try again.");
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
