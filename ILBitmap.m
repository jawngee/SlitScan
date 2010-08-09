//
//  ILBitmap.m
//  SlitScanGUI
//
//  Created by Jon Gilkison on 8/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ILBitmap.h"


@implementation ILBitmap

@synthesize pixelData, size;

-(id)initWithPixelData:(RGB24Pixel *)pixels forWidth:(NSInteger)width andHeight:(NSInteger)height
{
	if ((self=[super init]))
	{
		size=(long)((width*3)*height);
		
		pixelData=malloc(size);
		memcpy(pixelData,pixels,size);
	}
	
	return self;
}

-(void)reuse:(RGB24Pixel *)pixels
{
	memcpy(pixelData,pixels,size);
}

-(void)dealloc
{
	free(pixelData);
	[super dealloc];
}

@end
