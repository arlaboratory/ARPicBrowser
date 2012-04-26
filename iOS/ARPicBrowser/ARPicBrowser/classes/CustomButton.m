//
//  CustomButton.m
//  PanoramioBrowserSample
//
//  Copyright (c) 2012 ARLab. All rights reserved.
//

#import "CustomButton.h"
#import <objc/runtime.h>

@implementation UIButton(CustomButton)

static char UIB_PROPERTY_KEY;
static char UIB_PROPERTY_KEY2;


@dynamic _imageURL;

-(void)set_imageURL:(NSString *)_imageURL
{
    objc_setAssociatedObject(self, &UIB_PROPERTY_KEY, _imageURL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSObject*)_imageURL
{
    return (NSObject*)objc_getAssociatedObject(self, &UIB_PROPERTY_KEY);
}

-(void)set_title:(NSString *)_title
{
    objc_setAssociatedObject(self, &UIB_PROPERTY_KEY2, _title, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSObject*)_title
{
    return (NSObject*)objc_getAssociatedObject(self, &UIB_PROPERTY_KEY2);
}

@end