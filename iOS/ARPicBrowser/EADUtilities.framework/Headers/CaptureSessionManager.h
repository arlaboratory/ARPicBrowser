#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@protocol CameraCaptureDelegate
- (void)processNewCameraFrame:(CVImageBufferRef)cameraFrame;
@end

__attribute__((__visibility__("default"))) @interface CaptureSessionManager : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate> {
    
    
}

//NSString *const AVCaptureSessionPresetPhoto;
//NSString *const AVCaptureSessionPresetHigh;
//NSString *const AVCaptureSessionPresetMedium;
//NSString *const AVCaptureSessionPresetLow;
//NSString *const AVCaptureSessionPreset352x288;
//NSString *const AVCaptureSessionPreset640x480;
//NSString *const AVCaptureSessionPresetiFrame960x540;
//NSString *const AVCaptureSessionPreset1280x720;
//NSString *const AVCaptureSessionPresetiFrame1280x720;

@property (strong,nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property (strong,nonatomic) AVCaptureSession *captureSession;
@property (strong,nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (strong,nonatomic) UIImage *stillImage;
@property (weak, nonatomic) id<CameraCaptureDelegate> delegate;

- (void)addVideoInput;
- (void)addVideoOutput;
- (void)addVideoPreviewLayer;

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;
+ (UIInterfaceOrientation)getInterfaceOrientationFromDeviceOrientation:(UIDeviceOrientation)dOrientation;

@end