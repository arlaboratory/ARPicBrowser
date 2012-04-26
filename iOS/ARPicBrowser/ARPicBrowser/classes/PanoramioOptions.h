//
//  PanoramioOptions.h
//  PanoramioBrowserSample
//
//  Copyright (c) 2012 ARLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Information.h"

@interface PanoramioOptions : UIViewController{
    bool isVisible;
    float valueoffset;
    float x,y;
    float distance;
}

@property (nonatomic, strong) IBOutlet UISlider *SliderDistance;
@property (strong, nonatomic) IBOutlet UILabel *labelSliderDistance;
@property (nonatomic, strong) IBOutlet UISlider *SliderImages;
@property (strong, nonatomic) IBOutlet UILabel *labelSliderImages;
@property (strong, nonatomic) IBOutlet UIButton *refreshBTN;


- (IBAction)distanceChanged:(id)sender;
- (IBAction)numberMaxOfImagesChanged:(id)sender;
- (IBAction)refresh_touch:(id)sender;
- (void) activateRefreshBTN:(NSNotification*) notification;
- (void)initializeSlider:(UISlider*)myslider withMinValue:(int)min MaxValue:(int)max andActualValue:(int)value;
- (void)updateLabel:(UILabel*)myLabel withString:(NSString*)string;
- (void)convertGradesToKm;

@end
