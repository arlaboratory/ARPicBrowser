//
//  PanoramioPicture.m
//  PanoramioBrowserSample
//
//  Copyright (c) 2011 ARLab. All rights reserved.
//

#import "PanoramioPicture.h"

@implementation PanoramioPicture

@synthesize url;
@synthesize titleImage;
@synthesize asyncImg;

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


- (void)viewDidLoad
{
    [super viewDidLoad];
    imgbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [imgbutton setFrame:self.view.frame];
    activityView = [[UIActivityIndicatorView alloc] init];
    [activityView setFrame:CGRectMake(StartActivityView, StartActivityView, sizeActivityView, sizeActivityView)];
    [activityView setCenter:self.view.center];
    [activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityView startAnimating];
    [imgbutton addSubview:activityView];
    [imgbutton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:kAlpha]];
    [imgbutton addTarget:self action:@selector(dismissMediaViewer:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:imgbutton];
    UIImageView* closeImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"close.png"]];
    [closeImg setFrame:CGRectMake(StartcloseImg, StartcloseImg, sizecloseImg, sizecloseImg)];
    [imgbutton addSubview:closeImg];
    UILabel *titlePicture = [[UILabel alloc] init];
    if([Information isIPhone])
        [titlePicture setFrame:CGRectMake(StartLabelX_iPhone, StartLabelY_iPhone, WidthLabel_iPhone, HeightLabel_iPhone)];
    else
        [titlePicture setFrame:CGRectMake(StartLabelX_iPad, StartLabelY_iPad, WidthLabel_iPad, HeightLabel_iPad)];
    titlePicture.text = titleImage;
    titlePicture.numberOfLines=0;
    [titlePicture sizeToFit];
    titlePicture.textColor = [UIColor whiteColor];
    titlePicture.textAlignment = UITextAlignmentCenter;
    titlePicture.opaque = FALSE;
    titlePicture.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.view addSubview:titlePicture];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [self setImage];
}
/**
 *
 *Show the place's image and its title. While the image is being downloaded, an UIActivityIndicatorView is showed.
 *
 */
-(void)setImage{
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    if(image==nil){
        [activityView stopAnimating];
        [activityView removeFromSuperview];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:kImageNotDownload delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        float Ximage = image.size.width;
        float Yimage = image.size.height;
        float aspect = Ximage/Yimage;
        if(Ximage>[UIScreen mainScreen].bounds.size.width){
            Ximage = [UIScreen mainScreen].bounds.size.width;
            Yimage = Ximage/aspect;
        }else if(Yimage>[UIScreen mainScreen].bounds.size.height){
            Yimage = [UIScreen mainScreen].bounds.size.height;
            Ximage=Yimage*aspect;
        }
        image = [Information scaledImageForImage:image newSize:CGSizeMake(Ximage, Yimage)];
        asyncImg = [[UIImageView alloc] initWithImage:image];
        [asyncImg setFrame:[Information centerImageWithFrame:asyncImg.frame]];
        [imgbutton addSubview:asyncImg];
        
    }
}

-(void)dismissMediaViewer:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [self setUrl:nil];
    [self setTitleImage:nil];
    [self setAsyncImg:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [asyncImg setImage:nil];
    [self setAsyncImg:nil];
    imgbutton=nil;
    activityView=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0)
        [self dismissModalViewControllerAnimated:YES];
}

@end
