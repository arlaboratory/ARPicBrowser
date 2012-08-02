//
//  Poi.h
//  ARglLib
//
//  Copyright (c) 2011 ARLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#define POI_ACTION_CALL             @"call"
#define POI_ACTION_WEBLINK          @"url"
#define POI_ACTION_EMAIL            @"mail"
#define POI_ACTION_SMS              @"sms"
#define POI_ACTION_PHOTO            @"pic"
#define POI_ACTION_AUDIO            @"aud"
#define POI_ACTION_VIDEO            @"vid"
#define POI_ACTION_FACEBOOK         @"fb"
#define POI_ACTION_TWITTER          @"tw"
#define POI_ACTION_MAP              @"map"

typedef enum  {
    poi_size_small,
    poi_size_normal,
    poi_size_big
}poi_size;


/**
 @brief Represents a POI. The object has the POI's GPS coordinates, altitude, title, short text description and an icon that will be shown in the popups. The font's size and color of the texts in the popups can be set too.
*/
__attribute__((__visibility__("default"))) @interface Poi : NSObject
{
    /**
     @brief _altitude: Height of the poi. Values between -45 and 45.
     */
    double _altitude;
    
    /**
     @brief _location: coordinates of the poi
     */
    CLLocation* _location;
    
    /**
     @brief _title: title of the poi
     */
    NSString* _title;
    
    /**
     @brief _description: description of the poi
     */
    NSString* _description;
    
    /**
     @brief _iconPath: image icon of the poi
     */
    UIImage* _iconPath;
    
    /**
     @brief _alpha: alpha of the poi
     */
    double _selectedAlpha;
    /**
     @brief _alpha: none alpha of the poi
     */
    double _notSelectedAlpha;
    
    /**
     @brief _poiTitleFont: title font
     */
    UIFont* _poiTitleFont;
    
    /**
     @brief _poiDescriptionFont: description font
     */
    UIFont* _poiDescriptionFont;
    
    /**
     @brief _poiDescriptionFont: title font color
     */
    UIColor* _poiTitleColor;
    
    /**
     @brief _poiDescriptionColor: description font color
     */
    UIColor* _poiDescriptionColor;

    /**
     @brief _uId: unique ID of the POI
     */
    int _uId;
    
    /**
     @brief _actionsDict: A NSDictinary can have the following keys and values:<br>
     POI_ACTION_CALL with “123456” will call phone “123456”<br>
     POI_ACTION_WEBLINK with “www.google.com” will open “www.google.com” web page<br>
     POI_ACTION_EMAIL with “mail@address.com” will open the mail forum to send email to address “mail@address.com”<br>
     POI_ACTION_SMS with “123456” will send sms to phone number “123456”<br>
     POI_ACTION_PHOTO with “www.url.com/of/photo.jpg” will open the photo viewer with the photo.jpg in full screen<br>
     POI_ACTION_AUDIO with “www.url.com/of/audio.mp3” will play the audio file audio.mp3<br>
     POI_ACTION_VIDEO with “www.url.com/of/video.m4p” will play the video full screen<br>
     POI_ACTION_FACEBOOK with “nice!” will share the info of the poi (title, description and photo) with the text “nice!” on the user's facebook wall<br>
     POI_ACTION_TWITTER with “nice!” will share the info of the poi (title, description and photo) with the text “nice!” on the user's twitter account<br>
     POI_ACTION_MAP with “34.4,36.77” will show the user the map with directions from the user's location to latitude: 34.4 and longitude 36.77<br>
     */
    NSMutableDictionary* _actionsDict;
}

@property int uId;
@property double altitude;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* description;
@property (nonatomic, strong) UIImage* iconPath;
@property (nonatomic, assign) double selectedAlpha;
@property (nonatomic, assign) double notSelectedAlpha;
@property (nonatomic, strong) UIFont* poiTitleFont;
@property (nonatomic, strong) UIFont* poiDescriptionFont;
@property (nonatomic, strong) UIColor* poiTitleColor;
@property (nonatomic, strong) UIColor* poiDescriptionColor;
@property (nonatomic, strong) NSMutableDictionary* actionsDict;
@property (nonatomic, strong) CLLocation* location;

-(id) init;

/**
 @brief set poi altitude in degrees
 @param degree: a degree of the poi from the user location. raging from -45 to 45 degrees
 */
-(void) setAltitudeInDegrees:(double)degree;

-(BOOL) setIconFromUrl:(NSURL*)urlPath;

@end

