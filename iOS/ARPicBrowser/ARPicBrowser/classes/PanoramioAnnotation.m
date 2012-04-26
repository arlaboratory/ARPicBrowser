//
//  NSObject+PanoramioAnnotation.m
//  PanoramioBrowserSample
//
//  Copyright (c) 2012 ARLab. All rights reserved.
//

#import "PanoramioAnnotation.h"

@implementation PanoramioAnnotation

@synthesize coordinate;
@synthesize type;

- (id) initWithCoordinate:(CLLocationCoordinate2D)coord
{
    coordinate = coord;
    return self;
}

- (CLLocationCoordinate2D)coordinate;
{
    return _location.coordinate; 
}

- (NSString *)title
{
    return _title;
}

- (NSString *)subtitle
{
    return _imageDate;
}

@end
