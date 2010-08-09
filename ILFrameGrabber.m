//
//  ILFrameGrabber.m
//  SceneDetector
//
//  Created by Jon Gilkison on 7/29/09.
//  Copyright 2009 Interface Lab. All rights reserved.
//

#import "ILFrameGrabber.h"
#import <QuickTime/QuickTime.h>
#import "QTMovie+MiscShit.h"

@implementation ILFrameGrabber

@synthesize currentTime;
@synthesize currentFrame;
@synthesize frameCount;
@synthesize pixelData;
@synthesize width;
@synthesize height;
@synthesize timeScale;
@synthesize movie;


-(void)setupGrabber
{
    NSNumber *timeScaleObj;
	
    timeScaleObj = [movie attributeForKey:QTMovieTimeScaleAttribute];
    timeScale = [timeScaleObj longValue];
	

	currentTime = 0;
	frameCount = [movie calculateFrameCount];
	currentFrame = 0;
	
	
	// setup the offscreen buffer to draw on
    OSErr err = noErr;
	Rect srcRect;
	
    GetMovieBox([movie quickTimeMovie],&srcRect);
	
	width=(srcRect.right-srcRect.left);
	height=(srcRect.bottom-srcRect.top);
	
	long rowBytes=(long)(width*3);
	
	pixelData=malloc(rowBytes*(long)height);
	
	if (pixelData==nil)
	{
		NSLog(@"Needed to allocate %qi ... but could not do it.",(rowBytes*height));
		exit(666);
	}
	
	
    err = QTNewGWorldFromPtr(&gWorld, k24RGBPixelFormat, &srcRect, nil, nil, 0, pixelData, rowBytes);
	
    SetMovieGWorld([movie quickTimeMovie], gWorld,  nil);
	
	// let's get it on
	[self setCurrentFrame:0];
}

// Initialize the grabber with an existing QTMovie
-(id)initWithMovie:(QTMovie *)theMovie
{
	if ((self=[super init]))
	{
		movie=theMovie;
		frameCount=[theMovie calculateFrameCount];
		[self setupGrabber];
	}
	
	return self;
}

// Initialize the grabber with an existing QTMovie
-(id)initWithMovie:(QTMovie *)theMovie havingFrameCount:(NSInteger)theFrameCount
{
	if ((self=[self init]))
	{
		movie=theMovie;
		frameCount=theFrameCount;
		[self setupGrabber];
	}
	
	return self;
}

// Initialize the grabber with a file
-(id)initWithFile:(NSString *)theFile
{
	if ((self=[super init]))
	{
		NSError *error=nil;
		
		movie=[[QTMovie alloc] initWithFile:theFile error:&error];

		if (error)
		{
			NSLog(@"Error loading movie: %@",[error localizedDescription]);
			exit([error code]);
		}
		
		[self setupGrabber];
	}
	
	return self;
}

// setter for currentTime property
-(void)setCurrentTime:(TimeValue)value
{
	currentTime=value;
	SetMovieTimeValue([movie quickTimeMovie],value);

	MoviesTask([movie quickTimeMovie],0);
}

// setter for currentFrame property
-(void)setCurrentFrame:(UInt32)value
{
    if ( value < frameCount ) 
	{
		TimeValue theTime=0;
		
		UInt32 fCount=0;

		OSType whichMediaType = VIDEO_TYPE;
		
		short flags = nextTimeMediaSample + nextTimeEdgeOK;
		
		// we can't make any assumptions about the duration of the frame
		// otherwise we could jump to roughly where the frame is in the timeline
		// and hope for the best.  But we need accuracy here.
		while ((theTime >= 0) && (fCount<value))
		{
			GetMovieNextInterestingTime([movie quickTimeMovie],
										flags,
										1,
										&whichMediaType,
										theTime,
										0,
										&theTime,
										nil);
			
			
			flags = nextTimeMediaSample;

			fCount++;
		}
		
		if (theTime==-1)
		{
			// err
		}
		
		currentFrame=value;
		[self setCurrentTime:theTime];
    }
}

// Rewind the movie to the start
-(void)rewind
{
	[self setCurrentFrame:0];
}

// Advance to the next frame
-(void)next
{
	[self setCurrentFrame:currentFrame+1];
}

// Advance to the next frame and return that image
-(RGB24Pixel *)nextImage
{
	[self next];
	return pixelData;
}

// Get an image at a specific time
-(RGB24Pixel *)imageAtTime:(double)seconds
{
	TimeValue timev=(long)(seconds*timeScale);
	
	[self setCurrentTime:timev];
	
	return pixelData;
}

// Get an image for a specific frame
-(RGB24Pixel *)imageAtFrame:(UInt32)frame
{
	[self setCurrentFrame:frame];
	return pixelData;
}

// Get an image for a specific frame
-(NSImage *)nsImageAtFrame:(UInt32)frame
{
	[self setCurrentFrame:frame];
	
    NSBitmapImageRep *rep = 
    [[NSBitmapImageRep alloc] 
	 initWithBitmapDataPlanes: nil
	 pixelsWide: (int)width 
	 pixelsHigh: (int)height
	 bitsPerSample: 8
	 samplesPerPixel: 3 
	 hasAlpha: NO
	 isPlanar: NO 
	 colorSpaceName: NSCalibratedRGBColorSpace // 0 = black, 1 = white in this color space.
	 bytesPerRow: (int)(width*3)     // Passing zero means "you figure it out."
	 bitsPerPixel: 24];  // This must agree with bitsPerSample and samplesPerPixel.	
	

	unsigned char* data=[rep bitmapData];
	memcpy(data,pixelData,(int)(width*height*3));

	
	NSImage *image=[[NSImage alloc] initWithData:[rep TIFFRepresentation]];
	
	return image;
}

// Writes the current image to file for the specified format.
-(void)writeImageToFile:(NSString *)fileName withFormat:(NSBitmapImageFileType)fileType
{
	[self writeImageToFile:fileName withFormat:fileType appendingFrameNumber:NO];
}

// Writes the current image to file for the specified format, appending the frame number.
-(void)writeImageToFile:(NSString *)fileName withFormat:(NSBitmapImageFileType)fileType appendingFrameNumber:(BOOL)appendFrameNumber
{
	NSBitmapImageRep *rep = 
    [[NSBitmapImageRep alloc] 
	 initWithBitmapDataPlanes: (unsigned char **)&pixelData
	 pixelsWide: (int)width 
	 pixelsHigh: (int)height
	 bitsPerSample: 8
	 samplesPerPixel: 3
	 hasAlpha: NO
	 isPlanar: NO 
	 colorSpaceName: NSCalibratedRGBColorSpace
	 bytesPerRow: (int)(width*3)
	 bitsPerPixel: 24];
	
	NSData *data=[rep representationUsingType:fileType properties:nil];
	[data writeToFile:fileName atomically:NO];
}

@end
