//
//  NSDictionary+JSONCategories.h
//  PanoramioBrowserSample
//
//  Copyright (c) 2011 ARLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(JSONCategories)
+(NSDictionary*)dictionaryWithContentsOfJSONURLString:(NSString*)urlAddress;
-(NSData*)toJSON;
@end
