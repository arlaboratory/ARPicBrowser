//
//  FirstViewController.m
//  PanoramioBrowserSample
//
//  Copyright (c) 2011 ARLab. All rights reserved.
//

#import "PanoramioARview.h"
#import "panoramioObject.h"


@implementation PanoramioARview

@synthesize dataArray = _dataArray;
@synthesize userLocation = _userLocation;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _arlibCtrl = [[ARglLibController alloc] initWithAppKey:@"5vxGyjfsXet1HXvVW09DfD2N/ljnviDMH5WL50QfIQ=="];
    [_arlibCtrl.view setFrame:self.parentViewController.view.frame];
    [_arlibCtrl setPoiSize:poi_size_big];
    [_arlibCtrl setPopupMode:popup_mode_all];
    [self.view addSubview:_arlibCtrl.view];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.dataArray = nil;
    self.userLocation=nil;
}

/**
 *
 *If ARglLibController isn't update pois, it starts to run.
 *
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    isViewVisible=TRUE;
    [self setupPois]; 
       
}

/**
 *
 *Stop ARglLibController.
 *
 */
- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    isViewVisible=FALSE;
    [_arlibCtrl stop];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/**
 *
 *Add pois to ARglLibController.
 *
 */
- (void)addPoiSet:(Poi *)poiSet
{
    [_arlibCtrl add:poiSet];
}

/**
 *
 *Update pois but before, delete the old pois. Then, start to run ARglLibController.
 *
 */
- (void)setupPois
{   
    Loading=TRUE;
    
     
    [_arlibCtrl removeAllPois];
    
    for (PanoramioObject* panObj in _dataArray) {
        UIImage* small = panObj.imagePlace;
        Poi* poi = [[Poi alloc] init];
        [poi setLocation:[[CLLocation alloc]initWithLatitude:panObj.location.coordinate.latitude longitude:panObj.location.coordinate.longitude]];
        [poi setIconPath:small];
        [poi setAltitudeInDegrees:1];
        [poi setTitle:panObj.title];
        NSMutableDictionary* actions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:panObj.imageUrl,POI_ACTION_PHOTO,[NSString stringWithFormat:@"%f,%f",poi.location.coordinate.latitude,poi.location.coordinate.longitude],POI_ACTION_MAP,panObj.imageUrl,POI_ACTION_TWITTER, nil];
        [poi setActionsDict:actions];
        
        [self addPoiSet:poi];
    }
    
    if(isViewVisible)
        [_arlibCtrl start];
    if([Information returnFirst]){
        [Information setFirst:FALSE];
        [[NSNotificationCenter defaultCenter] postNotificationName:kRemoveSplash object:nil];
    }
    if(isViewVisible && [Information returnAlertActive]){
        [Information stopProcessAlert];
    }

    Loading=FALSE;
}

/**
 *
 *Refresh data.
 *
 *@param [NSMutableArray]dataArray Array with the new data.
 *
 */
-(void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    [self setupPois];
}

-(void)setUserLocation:(CLLocation *)userLocation
{
    _userLocation = userLocation;
    [_arlibCtrl updateLocation:userLocation];
}

@end
