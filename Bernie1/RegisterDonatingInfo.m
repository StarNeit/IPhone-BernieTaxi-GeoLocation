//
//  SecondView.m
//  example5
//
//  Created by PLEASE on 03/01/16.
//  Copyright © 2016 zaltan nyhether. All rights reserved.
//
#import "RegisterDonatingInfo.h"

@interface RegisterDonatingInfo ()
@end

@implementation RegisterDonatingInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.backbut.hidden = false;
    self.flagOfKeyboard = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)do_donate:(id)sender
{
    if (self.flagOfKeyboard == true)
    {
        [self animateTextField:sender up:NO];
        self.flagOfKeyboard = false;
    }
    if (compareString(self.email.text, @""))
    {
        showAlertMessage(@"Email is required");
        return;
    }
    if (compareString(self.firstnm.text, @""))
    {
        showAlertMessage(@"FirstName is required");
        return;
    }
    if (compareString(self.lastnm.text, @""))
    {
        showAlertMessage(@"LastName is required");
        return;
    }
    
    self.webview.hidden = false;
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:
                @"http://bernietaxi.com/service/donate?email=%@&first_name=%@&last_name=%@",self.email.text,self.firstnm.text,self.lastnm.text]];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [self.webview loadRequest:req];
    self.webview.delegate = self;
    
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
