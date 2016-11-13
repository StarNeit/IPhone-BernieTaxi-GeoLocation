//
//  global.h
//  Bernie1
//
//  Created by PLEASE on 05/01/16.
//  Copyright © 2016 zaltan nyhether. All rights reserved.
//
#import <UIKit/UIKit.h>


extern int pContractCnt;
extern NSString* pContractNameList[30];

extern int pc_trip_id[30];
extern double pc_trip_lat[30];
extern double pc_trip_lon[30];
extern NSString* pc_trip_promise_time[30];
extern NSString*  pc_trip_address[30];
extern int pc_trip_status[30];
extern int pc_trip_premium[30];
extern NSString* pc_trip_regdate[30];

extern int pc_user_id[30];
extern NSString* pc_user_name[30];
extern double pc_user_lat[30];
extern double pc_user_lon[30];
extern NSString* pc_user_phone[30];

extern int trip_id;
extern double trip_lat;
extern double trip_lon;
extern NSString* trip_promise_time;
extern NSString*  trip_address;
extern int trip_status;
extern int trip_premium;
extern NSString* trip_regdate;

extern int driver_id;
extern NSString* driver_name;
extern NSString* driver_email;
extern NSString* driverPhone;
extern NSString* driver_license_card;
extern NSString* driver_paypal;
extern double driver_lat;
extern double driver_lon;
extern NSString* driver_regdate;

extern int user_id;
extern NSString* user_name;
extern NSString* user_email;
extern double user_lat;
extern double user_lon;
extern NSString* user_phone;
extern NSString* user_address;
extern NSString* user_deviceToken;
extern NSString* user_regdate;

extern NSString* lc_email;
extern NSString* lc_password;
extern NSString* dc_email;
extern NSString* dc_password;

extern int g_driverType;
extern int currentDetailContract;

extern double g_curLatitude;
extern double g_curLongitude;
extern int flagOfUser;

extern NSString* passengerSettingPrevPage;
extern NSString* driverSettingPrevPage;

extern void showAlertMessage(NSString *str);
extern bool compareString(NSString *str1, NSString *str2);
extern void set_default_driver();
extern void set_default_passenger();
extern void set_default_trip();

extern bool bDriverStatusThread;
extern int jsonIntValidate(NSString *param);
extern double jsonDoubleValidate(NSString *param);
