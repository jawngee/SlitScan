//
//  ILSlitScanner.h
//  SlitScan
//
//  Created by Jon Gilkison on 8/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuickTime/QuickTime.h>
#import <QTKit/QTKit.h>
#import "ILFrameGrabber.h"
#import "PixelDefs.h"

/**
 Generates a series of bitmaps that mimic slit scan process
 */
@interface ILSlitScanner : NSObject 
{
	NSInteger distance;				/**< The distance between slits */
	BOOL forward;					/**< The direction for ordering slits, YES = Forward, NO=Backward */
	
	NSString *outputPath;			/**< The path to export the images */
	NSString *filenamePrefix;		/**< The filename prefix */
	NSMutableArray *frames;			/**< Queue of frames */

	NSInteger currentFrame;			/**< Current frame # */
	NSInteger maxFrames;			/**< Max # of frames to process */
	
	ILFrameGrabber *grabber;		/**< The frame grabber itself */
	
	RGB24Pixel *workPixels;			/**< The destination pixels */
	NSBitmapImageRep *rep;			/**< The destination image rep */
	
	float offset;
}

/**
 Initializes a slit scanner
 */
-(id)initWithMoviePath:(NSString *)theMoviePath 
			  exportTo:(NSString*)theExportPath 
			filePrefix:(NSString *)theFilePrefix 
		  slitDistance:(NSInteger)theSlitDistance 
			startFrame:(NSInteger)theStartFrame 
			  endFrame:(NSInteger)theEndFrame 
				offset:(float)theOffset;

/**
 Generates the next frame.  Returns YES if more frames can be generated 
 */
-(BOOL)nextFrame;

@end
