//
//  PanoramioPicture.h
//  PanoramioBrowserSample
//
//  Copyright (c) 2011 ARLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Information.h"

@interface PanoramioPicture : UIViewController{
    UIActivityIndicatorView* activityView;
    UIButton* imgbutton;
}

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *titleImage;
@property (nonatomic, strong) UIImageView* asyncImg;

-(void)setImage;

@end




