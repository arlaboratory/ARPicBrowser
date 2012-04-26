//
//  FirstViewController.h
//  PanoramioBrowserSample
//
//  Copyright (c) 2011 ARLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EADBrowser/ARglLibController.h>
#import "Information.h"

@interface PanoramioARview : UIViewController
{
    NSMutableArray* _dataArray;
    ARglLibController* _arlibCtrl;
    CLLocation* _userLocation;
    IBOutlet UIView *_loadingView;
    bool isViewVisible;
    bool Loading;
}

@property (strong, nonatomic) NSMutableArray* dataArray;
@property (strong, nonatomic) CLLocation* userLocation;

- (void)setupPois;

@end
