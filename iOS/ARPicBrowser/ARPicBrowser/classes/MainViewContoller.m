//
//  MainViewContoller.m
//  PanoramioBrowserSample
//
//  Copyright (c) 2012 ARLab. All rights reserved.
//

#import "MainViewContoller.h"
#import "NSDictionary+JSONCategories.h"
#import "panoramioObject.h"
#import "PanoramioARview.h"
#import "PanoramioTableView.h"
#import "PanoramioMapview.h"
#import "PanoramioOptions.h"


@implementation MainViewContoller

/**
 *
 *Download the images when the user's location has changed 1km from previous position.
 *
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (oldLocation == nil || [newLocation distanceFromLocation:[Information getLocationUser]] > kMetersToRefresh) //1 km
    {
        [Information setLocationUsr:newLocation];
        
        [self checkAlert];
        
        [self performSelectorInBackground:@selector(PanoramioConnection) withObject:nil];
    }
}

/**
 *
 *Set a radius of search and configure an initial number of images to download.
 *
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];

    [Information setValueOffset:InicialOffset];
    [Information setNumberMaxImages:kInicialImages];

    _locationManager = [[CLLocationManager alloc] init]; // Create new instance of locMgr
    _locationManager.delegate = self; // Set the delegate as self.
    _dataArray = nil;
    
    [_locationManager startUpdatingLocation];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImages:) name:kRefreshImages object:nil];
}

/**
 *
 *Refresh data in all screens.
 *
 */
- (void)fetchedData 
{
    for (UIViewController* viewController in self.childViewControllers) {
        if (viewController.class == [PanoramioARview class]) {
            PanoramioARview* pan = (PanoramioARview*)viewController;
            [pan setUserLocation:_locationManager.location];
            [pan setDataArray:_dataArray];
        }
        if (viewController.class == [PanoramioTableView class]) {
            PanoramioTableView* pan = (PanoramioTableView*)viewController;
            [pan setDataArray:_dataArray];
        }
        if(viewController.class == [PanoramioMapview class]){
            PanoramioMapview* pan = (PanoramioMapview*)viewController;
            [pan setDataArray:_dataArray];
        }
    }
    
    if(![Information returnFirst]){
        [[NSNotificationCenter defaultCenter] postNotificationName:kActiveRefresh object:nil];   
    }
}

- (void)viewDidUnload 
{ 
    [super viewDidUnload];
}

/**
 * This notification is launched after the user press the refresh data in options
 */
-(void)updateImages:(NSNotification *)notification
{
    [self checkAlert];
    [self performSelectorInBackground:@selector(PanoramioConnection) withObject:nil];
}

/**
 *
 *Call the function that downloads the images.
 *
 */
-(void)PanoramioConnection
{
    _dataArray=[Information PanoramioConnectionWithLocation];
    [self performSelectorOnMainThread:@selector(fetchedData) withObject:nil waitUntilDone:NO];
}

/**
 *
 *Show the "Updating Alert".
 *
 */
-(void)checkAlert{
    if(![Information returnFirst] && ![Information returnRefreshImage]){
        [Information startProcessAlert:kmessageUpdate];
    }
}
@end
