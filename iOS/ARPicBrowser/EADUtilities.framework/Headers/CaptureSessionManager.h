#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@protocol CameraCaptureDelegate
- (void)processNewCameraFrame:(CVImageBufferRef)cameraFrame;
@end

@interface CaptureSessionManager : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate> {
    
    
}

@property (strong,nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property (strong,nonatomic) AVCaptureSession *captureSession;
@property (strong,nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (strong,nonatomic) UIImage *stillImage;
@property (weak, nonatomic) id<CameraCaptureDelegate> delegate;

- (void)addVideoInput;
- (void)addVideoOutput;
- (void)addVideoPreviewLayer;

@end

