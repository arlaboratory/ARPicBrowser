//
//  MainViewContoller.h
//  PanoramioBrowserSample
//
//  Copyright (c) 2012 ARLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Information.h"

@interface MainViewContoller : UITabBarController <CLLocationManagerDelegate>
{
    NSMutableArray *_dataArray;
    CLLocationManager* _locationManager;
}


- (void)fetchedData;
- (void)updateImages:(NSNotification*)notification;
- (void)checkAlert;

@end
