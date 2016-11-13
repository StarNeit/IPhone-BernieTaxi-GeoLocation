//
//  SecondView.m
//  example5
//
//  Created by PLEASE on 03/01/16.
//  Copyright © 2016 zaltan nyhether. All rights reserved.
//
#import "PickContract.h"


@interface PickContract ()
@property (strong, nonatomic) IBOutlet UITextField *second;

@end

@implementation PickContract
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.flagOfAjaxCall = 1;
    NSString *url1 = [NSString stringWithFormat:@"http://bernietaxi.com/service/Driver/GetContractList"];
    NSURL *fileURL = [NSURL URLWithString:url1];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:fileURL cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:30.0];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//------------------------------------------------------------------------------------------//

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return pContractCnt;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = pContractNameList[indexPath.row];//[tableData objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = @"Subtitle 1";
    
    
    // add friend button
    UIButton *acceptButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    acceptButton.frame = CGRectMake(250.0f, 5.0f, 75.0f, 30.0f);
    [acceptButton setTitle:@"Accept" forState:UIControlStateNormal];
    [cell addSubview:acceptButton];
    
    acceptButton.tag = indexPath.row;
    
    [acceptButton addTarget:self
                     action:@selector(acceptButton: )
           forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    // add friend button
    /*
    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    detailButton.frame = CGRectMake(250.0f, 35.0f, 75.0f, 30.0f);
    [detailButton setTitle:@"Detail" forState:UIControlStateNormal];
    [cell addSubview:detailButton];
    detailButton.tag = indexPath.row;
    [detailButton addTarget:self
                     action:@selector(detailButton: )
           forControlEvents:UIControlEventTouchUpInside];
    */
    //[cell setBackgroundColor:[UIColor colorWithRed:.39 green:.87 blue:.255 alpha:1]];
    
     UIImage *cellImage = [UIImage imageNamed:@"zoomin.png"];
     cell.imageView.image = cellImage;
     /*NSString *colorString = @"fff";//[self.colorNames                              objectAtIndex: [indexPath row]];
     cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
     NSString *subtitle = @"All about the color ";
     subtitle = [subtitle stringByAppendingString:colorString];
     cell.detailTextLabel.text = subtitle;*/
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //showAlertMessage(pContractNameList[indexPath.row]);
    //showAlertMessage(pc_trip_address[indexPath.row]);
    NSString *str = [NSString stringWithFormat:@"%@, %@, %@, %@",pc_user_name[indexPath.row],pc_user_phone[indexPath.row],pc_trip_address[indexPath.row],pc_trip_promise_time[indexPath.row]];
    showAlertMessage(str);
}

- (void) acceptButton:(UIButton *) sender
{
    self.currentContract = sender.tag;
    currentDetailContract = sender.tag;
    if (self.flagOfAjaxCall == 0)
    {
        self.flagOfAjaxCall = 2;
        NSString *url1 = [NSString stringWithFormat:@"http://bernietaxi.com/service/Driver/DriverAcceptContract?user_id=%d&trip_id=%d&driver_id=%d&paid=%d",pc_user_id[sender.tag], pc_trip_id[sender.tag], driver_id, g_driverType];
        //showAlertMessage(url1);
        NSURL *fileURL = [NSURL URLWithString:url1];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:fileURL cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:30.0];
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
}

- (void) detailButton:(UIButton *) sender {
    currentDetailContract = sender.tag;
    //-----------redirecting
    UIStoryboard *mainStorynboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *documetController = [mainStorynboard instantiateViewControllerWithIdentifier:@"DetailContract"];
    [self.navigationController pushViewController:documetController animated:YES];
}

- (IBAction)go_settings:(id)sender {
    driverSettingPrevPage = @"driverpickcontract";
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {  _responseData = [[NSMutableData alloc] init]; }

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data { [_responseData appendData:data];}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse {  return nil;}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *tmp = [[NSString alloc] initWithData:_responseData encoding:NSASCIIStringEncoding];
    
    NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:[tmp dataUsingEncoding:NSUTF8StringEncoding]
                                                          options:0 error:NULL];
    NSArray *resultCode = [jsonObject valueForKey:@"resultCode"];
    
    if (self.flagOfAjaxCall == 1)
    {
        if (compareString(resultCode,@""))
        {
            showAlertMessage(@"Failed. Check Your Internet Connection");
            self.flagOfAjaxCall = 0;
            return;
        }
        
        if (compareString(resultCode, @"fail"))
        {
            showAlertMessage(@"No Contract Information");
            self.flagOfAjaxCall = 0;
            return;
        }
        
        if (compareString(resultCode, @"ok"))
        {
            NSArray *tripArr = [jsonObject valueForKey:@"trip"];
            for (int i = 0 ; i < tripArr.count; i ++)
            {
                pc_trip_id[i] = jsonIntValidate([tripArr[i] valueForKey:@"trip_id"]);
                pc_trip_lat[i] = jsonDoubleValidate([tripArr[i] valueForKey:@"trip_lat"]);
                pc_trip_lon[i] = jsonDoubleValidate([tripArr[i] valueForKey:@"trip_lon"]);
                pc_trip_promise_time[i] = [tripArr[i] valueForKey:@"trip_promise_time"];
                pc_trip_address[i] = [tripArr[i] valueForKey:@"trip_address"];
                pc_trip_status[i] = jsonIntValidate([tripArr[i] valueForKey:@"trip_status"]);
                pc_trip_regdate[i] = [tripArr[i] valueForKey:@"trip_regdate"];
                pc_trip_premium[i]= jsonIntValidate([tripArr[i] valueForKey:@"trip_premium"]);
                
                
                pc_user_id[i] = jsonIntValidate([tripArr[i] valueForKey:@"user_id"]);
                pc_user_name[i] = [tripArr[i] valueForKey:@"user_name"];
                pc_user_phone[i] = [tripArr[i] valueForKey:@"user_phone"];
                pc_user_lat[i] = jsonDoubleValidate([tripArr[i] valueForKey:@"user_lat"]);
                pc_user_lon[i] = jsonDoubleValidate([tripArr[i] valueForKey:@"user_lon"]);
            }
        }
        self.flagOfAjaxCall = 0;
    }
    if (self.flagOfAjaxCall == 2)
    {
        if (compareString(resultCode, @"fail"))
        {
            showAlertMessage(@"Error, Check your Internet");
            self.flagOfAjaxCall = 0;
            return;
        }else if (compareString(resultCode, @"exist"))
        {
            showAlertMessage(@"Already started...");
            self.flagOfAjaxCall = 0;
            return;
        }
        if (compareString(resultCode, @"ok"))
        {
            int pos = self.currentContract;
            trip_id = pc_trip_id[pos];
            trip_lat = pc_trip_lat[pos];
            trip_lon = pc_trip_lon[pos];
            trip_promise_time = pc_trip_promise_time[pos];
            trip_address = pc_trip_address[pos];
            trip_status = pc_trip_status[pos];
            trip_regdate = pc_trip_regdate[pos];
            
            trip_premium = g_driverType;
            trip_status = 2; //STATUS_TRIP_DRIVER_ACCEPTED
            
            user_id = pc_user_id[pos];
            user_name = pc_user_name[pos];
            user_phone = pc_user_phone[pos];
            user_lat = pc_user_lat[pos];
            user_lon = pc_user_lon[pos];
            
            //-----------redirecting
            UIStoryboard *mainStorynboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *documetController = [mainStorynboard instantiateViewControllerWithIdentifier:@"DriverContractShowActivity"];
            [self.navigationController pushViewController:documetController animated:YES];
        }
        self.flagOfAjaxCall = 0;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    showAlertMessage(@"Failed.Try agin");
}


@end
