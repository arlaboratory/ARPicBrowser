//
//  AppDelegate.h
//  PanoramioBrowserSample
//
//  Copyright (c) 2012 ARLab. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    UIImageView *imageView;
}

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic, strong)IBOutlet UIImageView* splash;

-(void)removeSplashView:(NSNotification*)notification;

@end
