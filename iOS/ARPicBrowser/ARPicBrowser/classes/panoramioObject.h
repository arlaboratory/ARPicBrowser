//
//  panoramioObject.h
//  panoramioMio
//
//  Copyright (c) 2011 ARLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "AsyncUIImageView.h"

@interface PanoramioObject : NSObject
{
    NSString* _title;
    NSString* _imageUrl;
    UIImageView* _image;
    NSString* _imageDate;
    CLLocation* _location;
    UIImage *imagePlace;
}

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* imageUrl;
@property (strong, nonatomic) UIImageView* image;
@property (strong, nonatomic) NSString* imageDate;
@property (strong, nonatomic) CLLocation* location;
@property (nonatomic, strong) UIImage *imagePlace;

@end
