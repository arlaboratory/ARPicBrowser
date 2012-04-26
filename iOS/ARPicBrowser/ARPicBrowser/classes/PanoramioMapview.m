//
//  PanoramioMapview.m
//  PanoramioBrowserSample
//
//  Copyright (c) 2012 ARLab. All rights reserved.
//

#import "PanoramioMapview.h"
#import "panoramioObject.h"
#import "PanoramioAnnotation.h"
#import "PanoramioARview.h"
#import "CustomButton.h"

@implementation PanoramioMapview

@synthesize mapView = _mapView;
@synthesize dataArray = _dataArray;
@synthesize PoiImage;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.mapView.mapType = MKMapTypeStandard;
    if([Information isIPhone])
        sizeImage=kMinSizeImage_iPhone;
    else
        sizeImage=kMinSizeImage_iPad;
    
    PoiImage = [UIImage imageNamed:@"image_holder.png"];    
    
}

/**
 *
 *Center the map in the user's location.
 *
 */
- (void)gotoLocation
{
    MKCoordinateRegion newRegion;
    CLLocationCoordinate2D locationUser = [Information getLocationUser].coordinate;
    
    newRegion.center.latitude = locationUser.latitude;
    newRegion.center.longitude = locationUser.longitude;
    newRegion.span.latitudeDelta = 2*[Information returnValueOffset];
    newRegion.span.longitudeDelta = 2*[Information returnValueOffset];
    
    spanLat=newRegion.span.latitudeDelta;
    spanLong=newRegion.span.longitudeDelta;
    
    [self.mapView setRegion:newRegion animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.dataArray = nil;
    self.mapView=nil;
    self.PoiImage=nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    isVisible=TRUE;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self gotoLocation];
    [self setupPois];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    [_mapView removeAnnotations:[_mapView annotations]];
    isVisible=FALSE;
}

+ (CGFloat)annotationPadding;
{
    return 10.0f;
}

+ (CGFloat)calloutHeight;
{
    return 40.0f;
}

/**
 *
 *Add pois to map.
 *
 */
-(void)setupPois{
        for (PanoramioObject* panObj in _dataArray) {
            PanoramioAnnotation *annotation = [[PanoramioAnnotation alloc] init];
            annotation.location = panObj.location;
            annotation.title = panObj.title;
            annotation.imageDate = panObj.imageDate;
            annotation.image = panObj.image;
            annotation.imageUrl = panObj.imageUrl;
            annotation.imagePlace = panObj.imagePlace;
            [_mapView addAnnotation:annotation];
        } 
    
    if(isVisible && [Information returnAlertActive]){
        [Information stopProcessAlert];
    }
}

/**
 *
 *Refresh data.
 *
 *@param [NSMutableArray]dataArray Array with the new data.
 *
 */
-(void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    if(isVisible)
        [self setupPois];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/**
 *
 *Show the place's image.
 *
 */
- (void)showImage:(id)sender
{    
    PanoramioPicture *controller = [[PanoramioPicture alloc] init];
    [controller setUrl:[sender _imageURL]];
    [controller setTitleImage:[sender _title]];
       
    [self presentModalViewController:controller animated:YES];
}

//MKMapView Delegate Methods
- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
    if ([annotation isKindOfClass:[PanoramioAnnotation class]])
    {
        PanoramioAnnotation *pinView = (PanoramioAnnotation *)annotation;
        if (pinView!=nil)
        {
            MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:[pinView type]];
            annotationView.canShowCallout = YES;
            
            UIImage* flagImage =pinView.imagePlace; 
            
            if([Information isIPhone])
                sizeImage=kMinSizeImage_iPhone;
            else
                sizeImage=kMinSizeImage_iPad;
            [self resizeRectOfPoi];
            UIGraphicsBeginImageContext(resizeRectPoi.size);
            [PoiImage drawInRect:resizeRectPoi];
            [flagImage drawInRect:resizeRect];
            annotationView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            annotationView.opaque = NO;
            
            UIImageView *labelIcon;
            if([Information isIPhone])
                labelIcon = [[UIImageView alloc] initWithImage:[Information scaledImageForImage:pinView.imagePlace newSize:CGSizeMake(kSmallImageMap_iPhone, kSmallImageMap_iPhone)]];
            else
                labelIcon = [[UIImageView alloc] initWithImage:[Information scaledImageForImage:pinView.imagePlace newSize:CGSizeMake(kSmallImageMap_iPad, kSmallImageMap_iPad)]];            
            annotationView.leftCalloutAccessoryView = labelIcon;
            
            UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            detailButton._imageURL = pinView.imageUrl;
            detailButton._title = pinView.title;
            [detailButton addTarget:self action:@selector(showImage:) forControlEvents:UIControlEventTouchUpInside];
            annotationView.rightCalloutAccessoryView = detailButton;
            
            return annotationView;
        }
    }
    return nil;
}

/**
 *
 *Resize pinViews when the user changes the map's zoom if there are < 30 images.
 * When there are more than 30 images, the map interaction with the user is not good.
 *
 */
-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
        if([mapView.annotations count]<30){
            float newSizeImage=0;
            if(_mapView.region.span.latitudeDelta!=spanLat || _mapView.region.span.longitudeDelta!=spanLong){
                spanLat = _mapView.region.span.latitudeDelta;
                spanLong = _mapView.region.span.longitudeDelta;
                if(spanLat<kInicialSpanToImage ||  spanLong<kInicialSpanToImage){
                    if([Information isIPhone])
                        newSizeImage = kMaxSizeImage_iPhone;
                    else
                        newSizeImage = kMaxSizeImage_iPad;
                }else if(spanLat>kLastSpanToImage || spanLong>kLastSpanToImage){
                    if([Information isIPhone])
                        newSizeImage = kMinSizeImage_iPhone;
                    else
                        newSizeImage = kMinSizeImage_iPad;
                }else{
                    float a;
                    float b;
                    //To get new size of image
                    if([Information isIPhone]){
                        a = (kMinSizeImage_iPhone - kMaxSizeImage_iPhone)/(kLastSpanToImage - kInicialSpanToImage);
                        b = kMaxSizeImage_iPhone - (kInicialSpanToImage*a);
                    }else{
                        a = (kMinSizeImage_iPad - kMaxSizeImage_iPad)/(kLastSpanToImage - kInicialSpanToImage);
                        b = kMaxSizeImage_iPad - (kInicialSpanToImage*a);   
                    }
                    newSizeImage = a*spanLat + b;
                }
                if((int)newSizeImage != sizeImage){
                    sizeImage = (int)newSizeImage;
                    [self resizeRectOfPoi];
                    UIGraphicsBeginImageContext(resizeRectPoi.size);
                    [PoiImage drawInRect:resizeRectPoi];
                    
                    for (int i=0; i<[_mapView.annotations count]; i++){
                        id <MKAnnotation> annotation=[_mapView.annotations objectAtIndex:i];
                        if ([annotation isKindOfClass:[MKUserLocation class]]){
                            continue;
                        }
                        PanoramioAnnotation *pinView = (PanoramioAnnotation *)annotation;                    MKAnnotationView *av = [self.mapView viewForAnnotation:annotation];
                        [pinView.imagePlace drawInRect:resizeRect];
                        av.image=UIGraphicsGetImageFromCurrentImageContext();
                        
                        [av setNeedsDisplay];
                        [av setNeedsLayout];
                    }
                    UIGraphicsEndImageContext();
                }   
            }
        }
}

/**
 *
 *Draw the place's image over the default image of pin.
 *
 */
-(void)resizeRectOfPoi{
    int kStartPhotoX;
    int kStartPhotoY;
    if([Information isIPhone]){
        kStartPhotoX = (sizeImage*kAuxSizePinMaxX)/(kMaxSizeImage_iPhone);
        kStartPhotoY = (sizeImage*kAuxSizePinMaxY)/(kMaxSizeImage_iPhone);
    }else{
        kStartPhotoX = (sizeImage*kAuxSizePinMaxX)/(kMaxSizeImage_iPad);
        kStartPhotoY = (sizeImage*kAuxSizePinMaxY)/(kMaxSizeImage_iPad);
    }
    
    //Size of default image of pin
    resizeRectPoi.size = CGSizeMake(sizeImage+kStartPhotoX, sizeImage+kStartPhotoY);
    CGSize maxSizePoi = CGRectInset(self.view.bounds,
                                    [PanoramioMapview annotationPadding],
                                    [PanoramioMapview annotationPadding]).size;
    maxSizePoi.height -= self.navigationController.navigationBar.frame.size.height + [PanoramioMapview calloutHeight];
    if (resizeRectPoi.size.width > maxSizePoi.width)
        resizeRectPoi.size = CGSizeMake(maxSizePoi.width, resizeRectPoi.size.height / resizeRectPoi.size.width * maxSizePoi.width);
    if (resizeRectPoi.size.height > maxSizePoi.height)
        resizeRectPoi.size = CGSizeMake(resizeRectPoi.size.width / resizeRectPoi.size.height * maxSizePoi.height, maxSizePoi.height);
    resizeRectPoi.origin = (CGPoint){0.0f, 0.0f};
    
    //Size of place's image 
    resizeRect.size = CGSizeMake(sizeImage, sizeImage);
    CGSize maxSize = CGRectInset(self.view.bounds,
                                 [PanoramioMapview annotationPadding],
                                 [PanoramioMapview annotationPadding]).size;
    maxSize.height -= self.navigationController.navigationBar.frame.size.height + [PanoramioMapview calloutHeight];
    if (resizeRect.size.width > maxSize.width)
        resizeRect.size = CGSizeMake(maxSize.width, resizeRect.size.height / resizeRect.size.width * maxSize.width);
    if (resizeRect.size.height > maxSize.height)
        resizeRect.size = CGSizeMake(resizeRect.size.width / resizeRect.size.height * maxSize.height, maxSize.height);
    resizeRect.origin = (CGPoint){resizeRectPoi.origin.x+kStartPhotoX/2, resizeRectPoi.origin.y+kStartPhotoX/2};
}



@end
