//
//  PanoramioOptions.m
//  PanoramioBrowserSample
//
//  Copyright (c) 2012 ARLab. All rights reserved.
//

#import "PanoramioOptions.h"

@implementation PanoramioOptions



@synthesize SliderDistance, SliderImages, labelSliderDistance, labelSliderImages, refreshBTN;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/**
 *
 *Initialize sliders and update labels.
 *
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self convertGradesToKm];
    [self initializeSlider:SliderDistance withMinValue:kMinDistance MaxValue:kMaxDistance andActualValue:InicialOffset*KOneKMinMeters];
    [self updateLabel:labelSliderDistance withString:kdistance];

    [self initializeSlider:SliderImages withMinValue:kminImages MaxValue:kmaxImages andActualValue:kInicialImages];
    [self updateLabel:labelSliderImages withString:kImages];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.SliderImages=nil;
    self.SliderDistance=nil;
    self.labelSliderImages=nil;
    self.labelSliderDistance=nil;
    self.refreshBTN=nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    isVisible=TRUE;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activateRefreshBTN:) name:kActiveRefresh object:nil];
}


- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    isVisible=FALSE;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/**
 *
 *Change the distance.
 *
 */
- (IBAction)distanceChanged:(id)sender {
    [self convertGradesToKm];
    [Information setValueOffset:[SliderDistance value]/KOneKMinMeters];
    [self updateLabel:labelSliderDistance withString:kdistance];
}

/**
 *
 *Change the number of images to download.
 *
 */
-(IBAction)numberMaxOfImagesChanged:(id)sender{
    [Information setNumberMaxImages:(int)[SliderImages value]];
    [self updateLabel:labelSliderImages withString:kImages];
}

/**
 *
 *Update images and show the "Updating Alert".
 *
 */
- (IBAction)refresh_touch:(id)sender{
    refreshBTN.enabled=FALSE;
    [Information setRefreshImages:TRUE];
    [Information startProcessAlert:kmessageUpdate];
    [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshImages object:nil];
}

/**
 *
 *Remove the "Updating Alert" from Superview.
 *
 */
-(void)activateRefreshBTN:(NSNotification *)notification{
    if(isVisible && [Information returnAlertActive]){
        [Information stopProcessAlert];
    }
    refreshBTN.enabled=TRUE;
    [Information setRefreshImages:FALSE];
}

/**
 *
 *Initialize a slider.
 *
 *@param [UISlider]myslider Slider to initialize.
 *
 *@param [int]min Minimum value of slider.  
 *
 *@param [int]max Maximum value of slider.  
 *
 *@param [int]value Actual value of slider.  
 *
 */
-(void)initializeSlider:(UISlider*)myslider withMinValue:(int)min MaxValue:(int)max andActualValue:(int)value
{
    myslider.value=value;
    myslider.minimumValue=min;
    myslider.maximumValue=max;
    UIImage *imageSlider;
    if([Information isIPhone]){
        imageSlider = [UIImage imageNamed:@"slider_thumb_iphone"];
    }else{
        imageSlider = [UIImage imageNamed:@"slider_thumb"];
    }
    [myslider setThumbImage:imageSlider forState:UIControlStateNormal];
    [myslider setThumbImage:imageSlider forState:UIControlStateSelected];
    [myslider setThumbImage:imageSlider forState:UIControlStateHighlighted];
}

/**
 *
 *Update a label.
 *
 *@param [UILabel]myLabel Label to update.
 *
 *@param [NSString]string If it is equal to "distance", the label is about distance and if it is equal to "images", the label to update is about the
 *                        number max of images.  
 *
 */
-(void)updateLabel:(UILabel*)myLabel withString:(NSString*)string
{
    if([string isEqualToString:kdistance]){
        if(distance>1000)
           myLabel.text = [NSString stringWithFormat:@"%.2f Km",distance/KOneKMinMeters];
        else
            myLabel.text = [NSString stringWithFormat:@"%.0f m",distance];
    }else if([string isEqualToString:kImages]){
        myLabel.text = [NSString stringWithFormat:@"%d images",(int)[SliderImages value]];
    }
}

/**
 *
 *Convert the grades (that are used of radius to download the images) to km.
 *
 */
-(void)convertGradesToKm
{
    valueoffset = [Information returnValueOffset];
    
    CLLocation *myLocation = [Information getLocationUser];
    
    x=myLocation.coordinate.latitude+valueoffset;
    y=myLocation.coordinate.longitude+valueoffset;
    
    CLLocation *posic = [[CLLocation alloc] initWithLatitude:x longitude:y];
    
    CLLocationDistance distanc = [myLocation distanceFromLocation:posic];
    
    distance = distanc;
    
}

@end
