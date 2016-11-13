//
//  SecondView.h
//  example5
//
//  Created by PLEASE on 03/01/16.
//  Copyright © 2016 zaltan nyhether. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "global.h"

@interface PickContract : UIViewController<NSURLConnectionDataDelegate>
{
    NSMutableData *_responseData;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) int flagOfAjaxCall;
@property (nonatomic) int currentContract;
@end

