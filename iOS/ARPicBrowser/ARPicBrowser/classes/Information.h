//
//  Information.h
//  PanoramioBrowserSample
//
//  Copyright (c) 2012 ARLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "panoramioObject.h"

//SLIDER_DISTANCE (the real values are /1000)
#define kMaxDistance 100
#define kMinDistance 1
#define InicialOffset 0.01
#define KOneKMinMeters 1000
#define kdistance @"distance"
//////////////

//SLIDER_IMAGES
#define kminImages 1
#define kmaxImages 100
#define kInicialImages 10
#define kImages @"images"
//////////////

//SPINNER
#define kSpinnerX 142
#define kSpinnerY 70
//////////////

//AUXILIAR CONSTANT TO CREATE PanoramioObject
#define kPanoramioImageTitle @"photo_title"
#define kPanoramioImageUrl @"photo_file_url"
#define kPanoramioImageDate @"upload_date"
#define kPanoramioLatitude @"latitude"
#define kPanoramioLongtitude @"longitude"
//////////////

//WEBSERVICE
#define webPanoramio @"http://www.panoramio.com/map/get_panoramas.php"
#define StateConnection @"Server Not Reachable. Please ensure you have internet connection and launch again the app."
#define ksizeImageMedium @"medium"
#define ksizeImageOriginal @"original"
//////////////

//NOTIFICATIONS
#define kRefreshImages @"UpdateImages"
#define kRemoveSplash @"RemoveSplash"
#define kActiveRefresh @"ActivateRefreshBTN"
#define kStartAlert @"StartAlert"
//////////////

//SIZE IMAGES
#define kSmallImage 128

#define kSmallImageMap_iPhone 35
#define kMinSizeImage_iPhone 32
#define kMaxSizeImage_iPhone 80
#define kSmallImageMap_iPad 35
#define kMinSizeImage_iPad 32
#define kMaxSizeImage_iPad 80

#define kInicialSpanToImage 0.001
#define kLastSpanToImage 0.05
#define kAuxSizePinMaxX 20
#define kAuxSizePinMaxY 30
//////////////

//FRAMES
#define activityViewStart 0
#define activityViewSize 10
#define closeImgStart 10
#define closeImgSize 25
//////////////

//REFRESH DATA
#define kMetersToRefresh 1000
//////////////

//ALERTS
#define kImageNotDownload @"The image hasn't been downloaded. Ensure you have internet connection."
#define kmessageUpdate @"Updating..."
//////////////

//IMAGE DETAIL 
#define StartActivityView 0
#define sizeActivityView 10
#define StartcloseImg 10
#define sizecloseImg 25
#define kAlpha 0.8

#define StartLabelX_iPhone 50
#define WidthLabel_iPhone 240
#define StartLabelY_iPhone 2
#define HeightLabel_iPhone 120

#define StartLabelX_iPad 70
#define WidthLabel_iPad 668
#define StartLabelY_iPad 10
#define HeightLabel_iPad 200

#define KNumberLinesLabel 5
//////////////

//SPLASH
#define xStart_iPad 128
#define yStart_iPad 122
#define splash_iPad 512

#define xStart_iPhone 35
#define yStart_iPhone 52
#define splash_iPhone 245
//////////////

@interface Information : NSObject 

+(bool)isIPhone;
+(NSMutableArray*)PanoramioConnectionWithLocation;
+(void)setValueOffset:(float)val;
+(float)returnValueOffset;
+(UIImage*)scaledImageForImage:(UIImage*)image newSize:(CGSize)newSize;
+(CLLocation*)getLocationUser;
+(void)setLocationUsr:(CLLocation*)newloc;
+(bool)returnFirst;
+(void)setFirst:(bool)val;
+(void)setNumberMaxImages:(int)val;
+(float)returnNumberMaxImages;
+(void)startProcessAlert:(NSString *)_message;
+(void)stopProcessAlert;
+(bool)returnAlertActive;
+(void)setRefreshImages:(bool)value;
+(bool)returnRefreshImage;
+(CGRect)centerImageWithFrame:(CGRect)frameToCenter;
@end
