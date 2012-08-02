//
//  ARglLibController.h
//  ARglLib
//
//  Copyright (c) 2011 ARLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Poi.h"

typedef enum  {
    popup_mode_all,
    popup_mode_bottom,
    popup_mode_center,
    popup_mode_none
}popup_mode;

typedef enum  {
    ui_orientation_all,
    ui_orientation_portrait,
    ui_orientation_landscape_left,
    ui_orientation_landscape_right
}orientations_mode;


@protocol ARLibProtocol <NSObject>
@optional
/**
 @brief Callback called with the user touches a poi
 Use this callback to implement custom UI, events or actions when the POI's clicked by the user
 @param the poi touched
 */
-(void) poiClicked:(Poi*)poi;

/**
 @brief Callback called with the user points his mobile device in the direction of a poi
 Use this callback to implement custom UI, events or actions when the POI's clicked by the user
 @param the pointed-at poi
 */
-(void) poiSelected:(Poi*)poi;

@end

__attribute__((__visibility__("default"))) @interface ARglLibController : UIViewController

/**
 @brief Initializes ARglLibController
 @param appKey Is the APP serial key, invalid key will result with uninitialized instance.
 @return instance of newly initialized ARglLibController
 */
-(id) initWithAppKey:(NSString*) appKey;

/**
 @brief Initializes ARglLibController
 @param appKey Is the APP serial key, invalid key will result with uninitialized instance.
 @param useDefaultCamera: when set to NO the background is transparent.
 @return instance of newly initialized ARglLibController
 */
-(id) initWithAppKey:(NSString*) appKey useDefaultCamera:(BOOL)useDefaultCamera;

/**
 @brief Adds POI to the AR Browser
 @param POI to be added
 @return uId of the Poi added
 */
-(int) add:(Poi*) poi;

/**
 @brief Adds POI to the AR Browser
 @param POI to be added
 @param uId: unique ID of the Poi to be added
 @return True if Poi successfuly added and the ID is unique.
 */
-(BOOL) add:(Poi*)poi withId:(int)uId;

/**
 @brief Returns Poi by ID.
 @param uId: unique ID of the Poi.
 @return The poi with the given ID, or nil if no poi with the ID is found.
 */
-(Poi*) getPoi:(int)uId;

/**
 @brief Removes POI from the AR Browser
 @param POI to be removed
 @return True is poi found and removed
 */
-(BOOL) remove:(Poi*) poi;
/**
 @brief Removes POI from the AR Browser
 @param uId id of the poi to be removed
 @return True is poi found and removed
 */
-(BOOL) removePoiWithId:(int)uId;

/**
 @brief Removes all POI from the AR Browser
 */
-(void) removeAllPois;

/**
 @brief Starts running the AR Browser
 */
-(void) start;

/**
 @brief Stops the AR Browser
 */
-(void) stop;

/**
 @brief Sets the POI size
 @param size can be any of: poi_size_small, poi_size_normal, poi_size_big
 */
-(void) setPoiSize:(poi_size)size;

/**
 @brief controls the behavior of the popups
 @param mode can be one of: popup_mode_all - shows all popups<br>
                            popup_mode_bottom - shows only bottom popup<br>
                            popup_mode_center - shows only center popup (when poi touched)<br>
                            popup_mode_none - all popups disabled<br>
 */
-(void) setPopupMode:(popup_mode)mode;

/**
 @brief controls the supported orientations for the UI (radar and popups)
 @param mode can be one of:  ui_orientation_all - supports all arientations (default)<br>
                             ui_orientation_portrait - UI orientation fixed to portrait<br>
                             ui_orientation_landscape_left - UI orientation fixed to landscape left<br>
                             ui_orientation_landscape_right - UI orientation fixed to landscape right<br>
 */
-(void) setUIorientationMode:(orientations_mode)mode;

/**
 @brief Sets the radar offset from the top left corner
 @param size in pixels
 */
-(void) setRadarOffset:(int)offset;

/**
 @brief Status of AR Browser
 @return true if running, false otherwize
 */
-(BOOL) isRunning;

/**
 @brief refreshes the pois on constant time intervals, should be called from didUpdateToLocation:: from the location manager
 @param the new CLLocation
 */
-(void) updateLocation:(CLLocation *)newuserLocation; 

/**
 @brief Sets facebook key to allow using the facebook sharing action
 @param facebook key
 */
@property (strong, nonatomic) NSString* faceBookKey;

/**
 @brief Sets ARLibProtocol delegate to recive the Browser's callbacks
 @param facebook key
 */
@property (weak, nonatomic)  NSObject <ARLibProtocol>* delegate;

/**
 @brief When true, the POIs altitude will be calculated in relation to the user location set in updateLocation:
 * false will ignore the location altitude.
 */
@property (assign, nonatomic) BOOL enableLocationAltitude;

@end
