//
//  main.m
//  Bernie1
//
//  Created by PLEASE on 03/01/16.
//  Copyright © 2016 zaltan nyhether. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

NSArray* pContractNameList[30];
int pContractCnt;
int pc_trip_id[30];
double pc_trip_lat[30];
double pc_trip_lon[30];
NSString* pc_trip_promise_time[30];
NSString*  pc_trip_address[30];
int pc_trip_status[30];
int pc_trip_premium[30];
NSString* pc_trip_regdate[30];

int pc_user_id[30];
NSString* pc_user_name[30];
double pc_user_lat[30];
double pc_user_lon[30];
NSString* pc_user_phone[30];

int trip_id;
double trip_lat;
double trip_lon;
NSString* trip_promise_time;
NSString*  trip_address;
int trip_status;
int trip_premium;
NSString* trip_regdate;

int driver_id;
NSString* driver_name;
NSString* driver_email;
NSString* driverPhone;
NSString* driver_license_card;
NSString* driver_paypal;
double driver_lat;
double driver_lon;
NSString* driver_regdate;

int user_id;
NSString* user_name;
double user_lat;
double user_lon;
NSString* user_phone;
NSString* user_email;
NSString* user_address;
NSString* user_deviceToken;
NSString* user_regdate;

NSString* lc_email;
NSString* lc_password;
NSString* dc_email;
NSString* dc_password;

bool bDriverStatusThread;
int g_driverType;
int currentDetailContract;

NSString* passengerSettingPrevPage;
NSString* driverSettingPrevPage;

double g_curLatitude;
double g_curLongitude;
int flagOfUser;

void set_default_driver()
{
    driver_id = 0;
    driver_email = nil;
    driverPhone = nil;
    driver_lat = 0;
    driver_license_card = nil;
    driver_lon = 0;
    driver_name = nil;
    driver_paypal = nil;
    driver_regdate = nil;
}

void set_default_passenger()
{
     user_id = 0;
     user_name = nil;
     user_lat = 0.0;
     user_lon = 0;
     user_phone = nil;
     user_email = nil;
     user_address = nil;
     user_deviceToken = nil;
     user_regdate = nil;
}

void set_default_trip()
{
    trip_id = 0;
    trip_lat = 0;
    trip_lon = 0;
    trip_promise_time = nil;
    trip_address = nil;
    trip_status = 0;
    trip_premium = 0;
    trip_regdate = nil;
}



void showAlertMessage(NSString *str){
    if (str==nil) return;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"BernieTaxi" message:str
                                                   delegate:nil  cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

bool compareString(NSArray *str1, NSArray *str2)
{
    //if (str1 == nil || str2 == nil) return false;
    if ([(NSString*)str1 compare:(NSString*)str2]==NSOrderedSame)
        return true;
    return false;
}

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}

int jsonIntValidate(NSString *param)
{
    if (param == [NSNull null])
    {
        return 0;
    }else{
        return [param intValue];
    }
}

double jsonDoubleValidate(NSString *param)
{
    if (param == [NSNull null])
    {
        return 0;
    }else{
        return [param doubleValue];
    }
}
