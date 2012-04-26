//
//  AppDelegate.m
//  PanoramioBrowserSample
//
//  Copyright (c) 2012 ARLab. All rights reserved.
//

#import "AppDelegate.h"
#import "PanoramioARview.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize splash;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeSplashView:) name:kRemoveSplash object:nil];
    
    //Splash's images
    NSArray *myImages = [NSArray arrayWithObjects: 
                    [UIImage imageNamed:@"Icon01.png"], 
                    [UIImage imageNamed:@"Icon02.png"], 
                    [UIImage imageNamed:@"Icon03.png"], 
                    [UIImage imageNamed:@"Icon04.png"], 
                    [UIImage imageNamed:@"Icon05.png"], 
                    [UIImage imageNamed:@"Icon06.png"], 
                    [UIImage imageNamed:@"Icon07.png"], 
                    nil]; 
        
    splash = [[UIImageView alloc] init];
    splash.animationImages=myImages;
    splash.animationDuration=1;
    splash.animationRepeatCount=0;
    
    if([Information isIPhone]){
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"splashbg_iphone.png"]];
        [splash setFrame:CGRectMake(xStart_iPhone, yStart_iPhone, splash_iPhone, splash_iPhone)];
    }else{
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"splashbg_ipad.png"]];
        [splash setFrame:CGRectMake(xStart_iPad, yStart_iPad, splash_iPad, splash_iPad)];
    }
        
    [imageView setFrame:[self.window bounds]];

    //Loads the animation, it will be removed after the Panoramio data is processed
    [splash startAnimating];
    [self.window makeKeyAndVisible];

    [self.window addSubview:imageView];
    [self.window addSubview:splash];

    //The ARView will use it to know if it's necessary to remove the initial splash
    [Information setFirst:TRUE];

    return YES;
}

/**
 * Removes the initial animated splash
 */
-(void)removeSplashView:(NSNotification *)notification{
    [splash stopAnimating];
    [imageView removeFromSuperview];
    [splash removeFromSuperview];
    
}

@end
