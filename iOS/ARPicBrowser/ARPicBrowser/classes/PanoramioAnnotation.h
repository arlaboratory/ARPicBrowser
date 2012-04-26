//
//  NSObject+PanoramioAnnotation.h
//  PanoramioBrowserSample
//
//  Copyright (c) 2012 ARLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "panoramioObject.h"
#import <MapKit/MapKit.h>

@interface PanoramioAnnotation : PanoramioObject<MKAnnotation>{
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property(nonatomic,strong) NSString * type;

- (id) initWithCoordinate:(CLLocationCoordinate2D)coord;

@end
