//
//  AsyncImageView.m
//
//  Version 1.2.3
//
//  Created by Nick Lockwood on 03/04/2011.
//  Copyright 2011 Charcoal Design. All rights reserved.
//
//  Get the latest version of AsyncImageView from either of these locations:
//
//  http://charcoaldesign.co.uk/source/cocoa#asyncimageview
//  https://github.com/nicklockwood/AsyncImageView
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//

#import "AsyncUIImageView.h"


NSString *const AsyncUIImageLoadDidFinish = @"AsyncImageLoadDidFinish";
NSString *const AsyncUIImageLoadDidFail = @"AsyncImageLoadDidFail";
NSString *const AsyncUIImageTargetReleased = @"AsyncImageTargetReleased";

NSString *const AsyncUIImageImageKey = @"image";
NSString *const AsyncUIImageURLKey = @"URL";
NSString *const AsyncUIImageCacheKey = @"cache";
NSString *const AsyncUIImageErrorKey = @"error";


@interface AsyncUIImageCache ()

@property (nonatomic, strong) NSMutableDictionary *cache;

@end


@implementation AsyncUIImageCache

@synthesize cache;
@synthesize useImageNamed;

+ (AsyncUIImageCache *)sharedCache
{
    static AsyncUIImageCache *sharedInstance = nil;
    if (sharedInstance == nil)
    {
        sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

- (id)init
{
    if ((self = [super init]))
    {
		useImageNamed = YES;
        cache = [[NSMutableDictionary alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(clearCache)
													 name:UIApplicationDidReceiveMemoryWarningNotification
												   object:nil];
    }
    return self;
}

- (UIImage *)imageForURL:(NSURL *)URL
{
	if (useImageNamed && [URL isFileURL])
	{
		NSString *path = [URL path];
		NSString *imageName = [path lastPathComponent];
		NSString *directory = [path stringByDeletingLastPathComponent];
		if ([[[NSBundle mainBundle] resourcePath] isEqualToString:directory])
		{
			return [UIImage imageNamed:imageName];
		}
	}
    return [cache objectForKey:URL];
}

- (void)setImage:(UIImage *)image forURL:(NSURL *)URL
{
    if (useImageNamed && [URL isFileURL])
    {
        NSString *path = [URL path];
        NSString *directory = [path stringByDeletingLastPathComponent];
        if ([[[NSBundle mainBundle] resourcePath] isEqualToString:directory])
        {
            //do not store in cache
            return;
        }
    }
    [cache setObject:image forKey:URL];
}

- (void)removeImageForURL:(NSURL *)URL
{
    [cache removeObjectForKey:URL];
}

- (void)clearCache
{
    //remove objects that aren't in use
    for (NSURL *URL in [cache allKeys])
    {
        //  UIImage *image = [cache objectForKey:URL];
        //        if ([image retainCount] == 1)
        //        {
        [cache removeObjectForKey:URL];
        //        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end


@interface AsyncUIImageConnection : NSObject

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) AsyncUIImageCache *cache;
@property (nonatomic, strong) id target;
@property (nonatomic, assign) SEL success;
@property (nonatomic, assign) SEL failure;
@property (nonatomic, assign) BOOL decompressImage;
@property (nonatomic, readonly, getter = isLoading) BOOL loading;
@property (nonatomic, readonly) BOOL cancelled;

+ (AsyncUIImageConnection *)connectionWithURL:(NSURL *)URL
                                        cache:(AsyncUIImageCache *)cache
                                       target:(id)target
                                      success:(SEL)success
                                      failure:(SEL)failure
                              decompressImage:(BOOL)decompressImage;

- (AsyncUIImageConnection *)initWithURL:(NSURL *)URL
                                  cache:(AsyncUIImageCache *)cache
                                 target:(id)target
                                success:(SEL)success
                                failure:(SEL)failure
                        decompressImage:(BOOL)decompressImage;

- (void)start;
- (void)cancel;
- (BOOL)isInCache;

@end


@implementation AsyncUIImageConnection

@synthesize connection;
@synthesize data;
@synthesize URL;
@synthesize cache;
@synthesize target;
@synthesize success;
@synthesize failure;
@synthesize decompressImage;
@synthesize loading;
@synthesize cancelled;


+ (AsyncUIImageConnection *)connectionWithURL:(NSURL *)URL
                                        cache:(AsyncUIImageCache *)_cache
                                       target:(id)target
                                      success:(SEL)_success
                                      failure:(SEL)_failure
                              decompressImage:(BOOL)_decompressImage
{
    return [[self alloc] initWithURL:URL
                               cache:_cache
                              target:target
                             success:_success
                             failure:_failure
                     decompressImage:_decompressImage];
}

- (AsyncUIImageConnection *)initWithURL:(NSURL *)_URL
                                  cache:(AsyncUIImageCache *)_cache
                                 target:(id)_target
                                success:(SEL)_success
                                failure:(SEL)_failure
                        decompressImage:(BOOL)_decompressImage
{
    if ((self = [self init]))
    {
        self.URL = _URL;
        self.cache = _cache;
        self.target = _target;
        self.success = _success;
        self.failure = _failure;
		self.decompressImage = _decompressImage;
    }
    return self;
}

- (BOOL)isInCache
{
    return [cache imageForURL:URL] != nil;
}

- (void)loadFailedWithError:(NSError *)error
{
	loading = NO;
	cancelled = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:AsyncUIImageLoadDidFail
                                                        object:target
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                URL, AsyncUIImageURLKey,
                                                                error, AsyncUIImageErrorKey,
                                                                nil]];
}

- (void)cacheImage:(UIImage *)image
{
	if (!cancelled)
	{
        if (image)
        {
            [cache setImage:image forURL:URL];
        }
        
		NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
										 image, AsyncUIImageImageKey,
										 URL, AsyncUIImageURLKey,
										 nil];
		if (cache)
		{
			[userInfo setObject:cache forKey:AsyncUIImageCacheKey];
		}
		
		loading = NO;
		[[NSNotificationCenter defaultCenter] postNotificationName:AsyncUIImageLoadDidFinish
															object:target
														  userInfo:[userInfo copy]];
	}
	else
	{
		loading = NO;
		cancelled = NO;
	}
}

- (void)decompressImageInBackground:(UIImage *)image
{
	@synchronized ([self class])
	{
		if (!cancelled && decompressImage)
		{
			//force image decompression
			UIGraphicsBeginImageContext(CGSizeMake(1, 1));
			[image drawAtPoint:CGPointZero];
			UIGraphicsEndImageContext();
		}
        
		//add to cache (may be cached already but it doesn't matter)
		[self performSelectorOnMainThread:@selector(cacheImage:)
							   withObject:image
							waitUntilDone:YES];
	}
}

- (void)processDataInBackground:(NSData *)_data
{
	@synchronized ([self class])
	{	
		if (!cancelled)
		{
			UIImage *image = [[UIImage alloc] initWithData:_data];
			if (image)
			{
				[self decompressImageInBackground:image];
			}
			else
			{
				@autoreleasepool {
					NSError *error = [NSError errorWithDomain:@"AsyncImageLoader" code:0 userInfo:[NSDictionary dictionaryWithObject:@"Invalid image data" forKey:NSLocalizedDescriptionKey]];
					[self performSelectorOnMainThread:@selector(loadFailedWithError:) withObject:error waitUntilDone:YES];
				}
			}
		}
		else
		{
			//clean up
			[self performSelectorOnMainThread:@selector(cacheImage:)
								   withObject:nil
								waitUntilDone:YES];
		}
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.data = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)_data
{
    //check for released target
    if (target == nil)
    {
        [self cancel];
        [[NSNotificationCenter defaultCenter] postNotificationName:AsyncUIImageTargetReleased object:target];
        return;
    }
    
    //check for cached image
	UIImage *image = [cache imageForURL:URL];
    if (image)
    {
        [self cancel];
        [self performSelectorInBackground:@selector(decompressImageInBackground:) withObject:image];
        return;
    }
    
    //add data
    [data appendData:_data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self performSelectorInBackground:@selector(processDataInBackground:) withObject:data];
    self.connection = nil;
    self.data = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.connection = nil;
    self.data = nil;
    [self loadFailedWithError:error];
}

- (void)start
{
    if (loading && !cancelled)
    {
        return;
    }
	
	//begin loading
	loading = YES;
	cancelled = NO;
    
    //check for released target
    if (target == nil)
    {
		[self cancel];
        [[NSNotificationCenter defaultCenter] postNotificationName:AsyncUIImageTargetReleased object:target];
        return;
    }
    
    //check for nil URL
    if (URL == nil)
    {
        [self cacheImage:nil];
        return;
    }
    
    //check for cached image
	UIImage *image = [cache imageForURL:URL];
    if (image)
    {
        [self performSelectorInBackground:@selector(decompressImageInBackground:) withObject:image];
        return;
    }
    
    //begin load
    NSURLRequest *request = [NSURLRequest requestWithURL:URL
                                             cachePolicy:NSURLCacheStorageNotAllowed
                                         timeoutInterval:[AsyncUIImageLoader sharedLoader].loadingTimeout];
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [connection start];
}

- (void)cancel
{
	cancelled = YES;
    [connection cancel];
    self.connection = nil;
    self.data = nil;
}


@end


@interface AsyncUIImageLoader ()

@property (nonatomic, strong) NSMutableArray *connections;

@end


@implementation AsyncUIImageLoader

@synthesize cache;
@synthesize connections;
@synthesize concurrentLoads;
@synthesize loadingTimeout;
@synthesize decompressImages;

+ (AsyncUIImageLoader *)sharedLoader
{
	static AsyncUIImageLoader *sharedInstance = nil;
	if (sharedInstance == nil)
	{
		sharedInstance = [[self alloc] init];
	}
	return sharedInstance;
}

- (AsyncUIImageLoader *)init
{
	if ((self = [super init]))
	{
        cache = [AsyncUIImageCache sharedCache];
        concurrentLoads = 2;
        loadingTimeout = 60;
		decompressImages = YES;
		connections = [[NSMutableArray alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(imageLoaded:)
													 name:AsyncUIImageLoadDidFinish
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(imageFailed:)
													 name:AsyncUIImageLoadDidFail
												   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(targetReleased:)
													 name:AsyncUIImageTargetReleased
												   object:nil];
	}
	return self;
}

- (void)updateQueue
{
    //remove released targets
    for (int i = [connections count] - 1; i >= 0; i--)
    {
        AsyncUIImageConnection *connection = [connections objectAtIndex:i];
        if (connection.target == nil)
        {
			[connection cancel];
            [connections removeObjectAtIndex:i];
        }
    }
    
    //start connections
    NSInteger count = 0;
    for (AsyncUIImageConnection *connection in connections)
    {
        if (![connection isLoading])
        {
            if ([connection isInCache])
            {
                [connection start];
            }
            else if (count < concurrentLoads)
            {
                count ++;
                [connection start];
            }
        }
    }
}

- (void)imageLoaded:(NSNotification *)notification
{  
    //complete connections for URL
    NSURL *URL = [notification.userInfo objectForKey:AsyncUIImageURLKey];
    for (int i = [connections count] - 1; i >= 0; i--)
    {
        AsyncUIImageConnection *connection = [connections objectAtIndex:i];
        if ([connection.URL isEqual:URL])
        {
            //cancel earlier connections for same target/action
            for (int j = i - 1; j >= 0; j--)
            {
                AsyncUIImageConnection *earlier = [connections objectAtIndex:j];
                if (earlier.target == connection.target &&
                    earlier.success == connection.success)
                {
                    [earlier cancel];
                    [connections removeObjectAtIndex:j];
                    i--;
                }
            }
            
            //cancel connection (in case it's a duplicate)
            [connection cancel];
            
            //perform action
			UIImage *image = [notification.userInfo objectForKey:AsyncUIImageImageKey];
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [connection.target performSelector:connection.success withObject:image withObject:connection.URL];
            #pragma clang diagnostic pop
            
            //remove from queue
            [connections removeObjectAtIndex:i];
        }
    }
    
    //update the queue
    [self updateQueue];
}

- (void)imageFailed:(NSNotification *)notification
{
    //remove connections for URL
    NSURL *URL = [notification.userInfo objectForKey:AsyncUIImageURLKey];
    for (int i = [connections count] - 1; i >= 0; i--)
    {
        AsyncUIImageConnection *connection = [connections objectAtIndex:i];
        if ([connection.URL isEqual:URL])
        {
            //cancel connection (in case it's a duplicate)
            [connection cancel];
            
            //perform failure action
            if (connection.failure)
            {
                NSError *error = [notification.userInfo objectForKey:AsyncUIImageErrorKey];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [connection.target performSelector:connection.failure withObject:error withObject:URL];
#pragma clang diagnostic pop
            }
            
            //remove from queue
            [connections removeObjectAtIndex:i];
        }
    }
    
    //update the queue
    [self updateQueue];
}

- (void)targetReleased:(NSNotification *)notification
{
    //remove connections for URL
    id target = [notification object];
    for (int i = [connections count] - 1; i >= 0; i--)
    {
        AsyncUIImageConnection *connection = [connections objectAtIndex:i];
        if (connection.target == target)
        {
            //cancel connection
            [connection cancel];
            [connections removeObjectAtIndex:i];
        }
    }
    
    //update the queue
    [self updateQueue];
}

- (void)loadImageWithURL:(NSURL *)URL target:(id)target success:(SEL)success failure:(SEL)failure
{
    //create new connection
    [connections addObject:[AsyncUIImageConnection connectionWithURL:URL
                                                               cache:cache
                                                              target:target
                                                             success:success
                                                             failure:failure
                                                     decompressImage:decompressImages]];
    [self updateQueue];
}

- (void)loadImageWithURL:(NSURL *)URL target:(id)target action:(SEL)action
{
    [self loadImageWithURL:URL target:target success:action failure:NULL];
}

- (void)loadImageWithURL:(NSURL *)URL
{
    [self loadImageWithURL:URL target:nil success:NULL failure:NULL];
}

- (void)cancelLoadingURL:(NSURL *)URL target:(id)target action:(SEL)action
{
    for (int i = [connections count] - 1; i >= 0; i--)
    {
        AsyncUIImageConnection *connection = [connections objectAtIndex:i];
        if ([connection.URL isEqual:URL] && connection.target == target && connection.success == action)
        {
            [connection cancel];
            [connections removeObjectAtIndex:i];
        }
    }
}

- (void)cancelLoadingURL:(NSURL *)URL target:(id)target
{
    for (int i = [connections count] - 1; i >= 0; i--)
    {
        AsyncUIImageConnection *connection = [connections objectAtIndex:i];
        if ([connection.URL isEqual:URL] && connection.target == target)
        {
            [connection cancel];
            [connections removeObjectAtIndex:i];
        }
    }
}

- (void)cancelLoadingURL:(NSURL *)URL
{
    for (int i = [connections count] - 1; i >= 0; i--)
    {
        AsyncUIImageConnection *connection = [connections objectAtIndex:i];
        if ([connection.URL isEqual:URL])
        {
            [connection cancel];
            [connections removeObjectAtIndex:i];
        }
    }
}

- (NSURL *)URLForTarget:(id)target action:(SEL)action
{
    //return the most recent image URL assigned to the target
    //this is not neccesarily the next image that will be assigned
    for (int i = [connections count] - 1; i >= 0; i--)
    {
        AsyncUIImageConnection *connection = [connections objectAtIndex:i];
        if (connection.target == target && connection.success == action)
        {
            return connection.URL;
        }
    }
    return nil;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end


@implementation UIImageView(AsyncUIImageView)

- (void)setImageURL:(NSURL *)imageURL
{
	[[AsyncUIImageLoader sharedLoader] loadImageWithURL:imageURL target:self action:@selector(setImage:)];
}

- (NSURL *)imageURL
{
	return [[AsyncUIImageLoader sharedLoader] URLForTarget:self action:@selector(setImage:)];
}

@end
