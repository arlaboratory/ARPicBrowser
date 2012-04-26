//
//  Information.m
//  PanoramioBrowserSample
//
//  Copyright (c) 2012 ARLab. All rights reserved.
//

#import "Information.h"

@implementation Information

static float valueOffset;
static CLLocation *locationUser;
static bool first;
static int numberMaxImages;
static UIAlertView *alert;
static bool alertActive;
static bool refreshImages;

/**
 *
 *@retval TRUE. It is working with the iPhone.
 *@retval FALSE. It is working with the iPad.
 *
 */
+(bool)isIPhone{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
}

/**
 *
 *@retval TRUE. The "Updating Alert" is showed.
 *@retval FALSE. The "Updating Alert" isn't showed.
 *
 */
+(bool)returnAlertActive{
    return alertActive;
}

+(void)setRefreshImages:(bool)value{
    refreshImages=value;
}

/**
 *
 *@retval TRUE. The images are being updated.
 *@retval FALSE. The images aren't being updated.
 *
 */
+(bool)returnRefreshImage{
    return refreshImages;
}

/**
 *
 *@retval TRUE. The app was just launched.
 *
 */
+(bool)returnFirst{
    return first;
}

+(void)setFirst:(bool)val
{
    first=val;
}

+(void)setValueOffset:(float)val{
    valueOffset=val;
}

+(float)returnValueOffset{
    return valueOffset;
}

+(void)setNumberMaxImages:(int)val{
    numberMaxImages=val;
}

+(float)returnNumberMaxImages{
    return numberMaxImages;
}

+(CLLocation*)getLocationUser{
    return locationUser;
}

+(void)setLocationUsr:(CLLocation*)newloc{
    locationUser=newloc;
}

/**
 *
 *Download the images. Considers the filters state.
 *
 *@return an array with objects of type PanoramioObject.
 *
 */

+(NSMutableArray*)PanoramioConnectionWithLocation{
    float x1,y1,x2,y2;

    NSMutableArray* dataArray;
    
    x1 = locationUser.coordinate.longitude-valueOffset;
    x2 = locationUser.coordinate.longitude+valueOffset;
    y1 = locationUser.coordinate.latitude-valueOffset;
    y2 = locationUser.coordinate.latitude+valueOffset;
    
    NSString *postMedium = [NSString stringWithFormat:@"?set=public&from=0&to=%d&minx=%f&miny=%f&maxx=%f&maxy=%f&size=%@&mapfilter=true", numberMaxImages,x1,y1,x2,y2,ksizeImageMedium];
    NSString *postOriginal = [NSString stringWithFormat:@"?set=public&from=0&to=%d&minx=%f&miny=%f&maxx=%f&maxy=%f&size=%@&mapfilter=true", numberMaxImages,x1,y1,x2,y2,ksizeImageOriginal];

    NSString *hostStrMedium = [webPanoramio stringByAppendingString:postMedium];
    NSString *hostStrOriginal = [webPanoramio stringByAppendingString:postOriginal];

    NSURL* urlMedium = [NSURL URLWithString:hostStrMedium];
    NSURL* urlOriginal = [NSURL URLWithString:hostStrOriginal];

    NSData* dataMedium = [NSData dataWithContentsOfURL: urlMedium];
    NSData* dataOriginal = [NSData dataWithContentsOfURL: urlOriginal];

    if(dataMedium==nil || dataOriginal==nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:StateConnection delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return nil;
    }else{
        NSError* error;
        NSDictionary* jsonMedium = [NSJSONSerialization JSONObjectWithData:dataMedium //1
                                                             options:kNilOptions 
                                                               error:&error];
        NSDictionary* jsonOriginal = [NSJSONSerialization JSONObjectWithData:dataOriginal //1
                                                                     options:kNilOptions 
                                                                       error:&error];
        
        NSArray* photosMedium = [jsonMedium objectForKey:@"photos"];
        NSArray* photosOriginal = [jsonOriginal objectForKey:@"photos"];
        
        
        if (dataArray==nil) {
            dataArray=[[NSMutableArray alloc] init];
        }else{
            [dataArray removeAllObjects];
        }
        
        for (NSDictionary* photoDict in photosMedium) {
            PanoramioObject* panObj = [[PanoramioObject alloc] init];
            [panObj setTitle:[photoDict objectForKey:kPanoramioImageTitle]];
            [panObj setImageDate:[photoDict objectForKey:kPanoramioImageDate]];
            [panObj setImageUrl:[photoDict objectForKey:kPanoramioImageUrl]];
            UIImage *auxImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:panObj.imageUrl]]];
            [panObj setImagePlace:[Information scaledImageForImage:auxImage newSize:CGSizeMake(kSmallImage, kSmallImage)]];
            CLLocationDegrees latitude = [[photoDict objectForKey:kPanoramioLatitude] doubleValue];
            CLLocationDegrees longtitude = [[photoDict objectForKey:kPanoramioLongtitude] doubleValue];
            CLLocation* location = [[CLLocation alloc] initWithLatitude:latitude longitude:longtitude];
            [panObj setLocation:location];
            
            [dataArray addObject:panObj];
        }
        
        for(int i=0; i<[photosOriginal count]; i++){
            NSDictionary* photo = [photosOriginal objectAtIndex:i];
            PanoramioObject* panObj = [dataArray objectAtIndex:i];
            [panObj setImageUrl:[photo objectForKey:kPanoramioImageUrl]];
        }
        
    return dataArray;
    }
}

/**
 *
 *Resize an image.
 *
 *@param [UIImage]image Image we want to change its size.
 *
 *@param [int]newSize New size of the image.  
 *
 *@return a resized image.
 *
 */
+ (UIImage*)scaledImageForImage:(UIImage*)image newSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

/**
 *
 *Show an alert while the images are being downloaded.
 *
 *@param [NSString]_message Message to show.
 *
 */
+(void)startProcessAlert:(NSString *)_message
{
    alertActive=TRUE;
	alert = [[UIAlertView alloc] initWithTitle:_message message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	spinner.center = CGPointMake(kSpinnerX,kSpinnerY);
	[spinner startAnimating];
	[alert addSubview:spinner];
	[alert show];
}

/**
 *
 *Remove the alert for Superview.
 *
 */
+(void)stopProcessAlert
{
    alertActive=FALSE;
	if (alert != nil) 
	{
		[alert dismissWithClickedButtonIndex:0 animated:YES];
		alert = nil;
	}
}

/**
 *
 *Center an ImageView in a screen.
 *
 *@param [CGRect]frameToCenter ImageView's frame.
 *
 *@return the new frame to center the ImageView.
 *
 */
+(CGRect)centerImageWithFrame:(CGRect)frameToCenter{
    // center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = [UIScreen mainScreen].bounds.size;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    return frameToCenter;
}
@end
