//
//  ILSlitScanner.m
//  SlitScan
//
//  Created by Jon Gilkison on 8/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ILSlitScanner.h"
#import "QTMovie+MiscShit.h"
#import "ILBitmap.h"

@interface ILSlitScanner(private)
	-(void)populateFrames;
@end

@implementation ILSlitScanner

-(id)initWithMoviePath:(NSString *)theMoviePath 
			  exportTo:(NSString*)theExportPath 
			filePrefix:(NSString *)theFilePrefix 
		  slitDistance:(NSInteger)theSlitDistance 
			startFrame:(NSInteger)theStartFrame 
			  endFrame:(NSInteger)theEndFrame 
				offset:(float)theOffset;
{
	if ((self=[super init]))
	{
		offset=theOffset;
		distance=(theSlitDistance==0) ? 1 : theSlitDistance;
		
		grabber=[[[ILFrameGrabber alloc] initWithFile:theMoviePath] retain];
		outputPath=[theExportPath retain];
		filenamePrefix=theFilePrefix;
		frames=[[NSMutableArray arrayWithCapacity:grabber.width] retain];

		currentFrame=theStartFrame;
		maxFrames=(theEndFrame<=0) ? grabber.frameCount-grabber.width : theEndFrame;
		maxFrames=maxFrames+(grabber.width/distance);
		if (maxFrames>grabber.frameCount-grabber.width)
			maxFrames=grabber.frameCount-grabber.width;
		
		NSLog(@"width:%d",(int)grabber.width);
		NSLog(@"height:%d",(int)grabber.height);
		NSLog(@"frame count:%d",grabber.frameCount);
		NSLog(@"slit distance:%d",distance);
		NSLog(@"start frame:%d",currentFrame);
		NSLog(@"end frame:%d",maxFrames);
		
		long rowBytes=(long)(grabber.width*3);
		workPixels=malloc(rowBytes*(long)grabber.height);
		
		rep = [[NSBitmapImageRep alloc] 
		 initWithBitmapDataPlanes: nil
		 pixelsWide: (int)grabber.width 
		 pixelsHigh: (int)grabber.height
		 bitsPerSample: 8
		 samplesPerPixel: 3 
		 hasAlpha: NO
		 isPlanar: NO 
		 colorSpaceName: NSCalibratedRGBColorSpace // 0 = black, 1 = white in this color space.
		 bytesPerRow: (int)(grabber.width*3)     // Passing zero means "you figure it out."
		 bitsPerPixel: 24];  // This must agree with bitsPerSample and samplesPerPixel.	

		NSLog(@"Loading first %d frames ...",(int)grabber.width);
		for(int i=currentFrame; i<currentFrame+(grabber.width/distance); i++)
			[frames addObject:[[ILBitmap alloc] initWithPixelData:[grabber imageAtFrame:i] forWidth:grabber.width andHeight:grabber.height]];

		int fproc=0;
		NSLog(@"Processing ...");
		NSDate *stime=[NSDate date]; 
		while ([self nextFrame]) 
		{
			fproc++;
			NSTimeInterval delta=[stime timeIntervalSinceNow];
			float fps=fproc/(0-delta);
			float eta=((maxFrames-currentFrame)/fps)/60;
			NSLog(@"current frame: %d = %0.02f%% fps: %0.02f eta: %0.02f",currentFrame,((float)currentFrame/(float)maxFrames)*100.0,fps,eta); 
		}
	}
	
	return self;
}

-(void)dealloc
{
	[grabber release];
	[outputPath release];
	[frames release];
	[super dealloc];
}

-(BOOL)nextFrame
{
	int x=(int)grabber.width*offset;
	int v=0;
	while(x<grabber.width-distance)
	{
		ILBitmap *source=[frames objectAtIndex:v];
		for(int x2=0; x2<distance; x2++)
			for(int y=0; y<grabber.height; y++)
				workPixels[(x+x2)+(y*(long)grabber.width)]=source.pixelData[(x+x2)+(y*(long)grabber.width)];
		
		x+=distance;
		v++;
	}

	x=(int)grabber.width*offset;
	v=0;
	while(x>=distance)
	{
		ILBitmap *source=[frames objectAtIndex:v];
		for(int x2=0; x2<distance; x2++)
			for(int y=0; y<grabber.height; y++)
				workPixels[(x-x2)+(y*(long)grabber.width)]=source.pixelData[(x-x2)+(y*(long)grabber.width)];
		
		v++;
		x-=distance;
	}

	//	
//	for(int i=0; i<grabber.width; i++)
//	{
//		ILBitmap *source=[frames objectAtIndex:i];
//		for(int y=0; y<grabber.height; y++)
//			workPixels[i+(y*(long)grabber.width)]=source.pixelData[i+(y*(long)grabber.width)];
//	}
	
	unsigned char* data=[rep bitmapData];
	memcpy(data,workPixels,(int)(grabber.width*grabber.height*3));
	
	NSData *pdata=[rep representationUsingType: NSPNGFileType properties: nil];
	[pdata writeToFile:[NSString stringWithFormat:@"/%@/%@-%06d.png",outputPath,filenamePrefix,currentFrame] atomically:NO];
	[pdata release];
	
	currentFrame++;
	if (currentFrame>=maxFrames)
		return NO;
	
	ILBitmap *top=[frames objectAtIndex:0];
	[top reuse:[grabber imageAtFrame:currentFrame+((grabber.width/distance)-1)]];
	[frames removeObjectAtIndex:0];
	[frames addObject:top];
	
	return YES;
}

@end
