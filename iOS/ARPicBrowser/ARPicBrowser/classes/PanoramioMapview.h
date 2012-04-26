//
//  PanoramioMapview.h
//  PanoramioBrowserSample
//
//  Copyright (c) 2012 ARLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Information.h"
#import "PanoramioPicture.h"


@interface PanoramioMapview : UIViewController<MKMapViewDelegate>{
    
    MKMapView *_mapView;
    NSMutableArray* _dataArray;
    float spanLat;
    float spanLong;
    int sizeImage;
    CGRect resizeRectPoi;
    CGRect resizeRect;
    bool isVisible;
}

@property (strong, nonatomic) NSMutableArray* dataArray;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) UIImage *PoiImage;

+ (CGFloat)annotationPadding;
+ (CGFloat)calloutHeight;
- (void)showImage:(id)sender;
- (void)gotoLocation;
- (void)resizeRectOfPoi;
- (void)setupPois;

@end
