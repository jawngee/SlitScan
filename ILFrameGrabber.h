//
//  ILFrameGrabber.h
//  
//  Convenience class for extracting specific frames from a quicktime movie
//  into a 24-bit pixel buffer for further manipulation.
//
//  TODO: Refactor to use Core Video?
//
//  Created by Jon Gilkison on 7/29/09.
//  Copyright 2009 Interface Lab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuickTime/QuickTime.h>
#import <QTKit/QTKit.h>
#import "PixelDefs.h"


@interface ILFrameGrabber : NSObject 
{
	@public
	TimeValue currentTime;		// current movie time
	UInt32 frameCount;			// number of frames in the movie
	UInt32 currentFrame;		// current frame number
	
	double width;				// width
	double height;				// height

	long timeScale;				// time scale
	
	RGB24Pixel *pixelData;		// pointer to the 24-bit pixel data
	
	QTMovie *movie;				// The source movie
	
	@private
	// Pointer to the gWorld
	GWorldPtr gWorld;
}

@property (assign, nonatomic, setter=setCurrentTime:) TimeValue currentTime;
@property (assign, nonatomic, setter=setCurrentFrame:) UInt32 currentFrame;

@property (retain, nonatomic) QTMovie *movie;

@property (readonly) RGB24Pixel *pixelData;
@property (readonly) double width;
@property (readonly) double height;
@property (readonly) UInt32 frameCount;
@property (readonly) long timeScale;

// Initialize the grabber with an existing QTMovie
-(id)initWithMovie:(QTMovie *)theMovie;

// Initialize the grabber with an existing QTMovie
-(id)initWithMovie:(QTMovie *)theMovie havingFrameCount:(NSInteger)theFrameCount;


// Initialize the grabber with a file
-(id)initWithFile:(NSString *)theFile;

// Rewind the movie to the start
-(void)rewind;

// Advance to the next frame
-(void)next;

// Advance to the next frame and return that image
-(RGB24Pixel *)nextImage;

// Get an image at a specific time
-(RGB24Pixel *)imageAtTime:(double)seconds;

// Get an image for a specific frame
-(RGB24Pixel *)imageAtFrame:(UInt32)frame;

// Get an image for a specific frame
-(NSImage *)nsImageAtFrame:(UInt32)frame;

// Writes the current image to file for the specified format.
-(void)writeImageToFile:(NSString *)fileName withFormat:(NSBitmapImageFileType)fileType;

// Writes the current image to file for the specified format, appending the frame number.
-(void)writeImageToFile:(NSString *)fileName withFormat:(NSBitmapImageFileType)fileType appendingFrameNumber:(BOOL)appendFrameNumber;

@end
