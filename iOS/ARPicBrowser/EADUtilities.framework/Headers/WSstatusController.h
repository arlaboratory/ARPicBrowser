//
//  WSstatusController.h
//  ARglLib
//
//  Copyright (c) 2011 ARLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AES.h"

@interface WSstatusController : NSObject <NSURLConnectionDelegate>

- (BOOL)Register;

@property (strong, nonatomic) NSString* appKey;
@property (strong, nonatomic) NSString* productId;

@end

