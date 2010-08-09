//
//  ILBitmap.h
//  SlitScanGUI
//
//  Created by Jon Gilkison on 8/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PixelDefs.h"

@interface ILBitmap : NSObject {
	RGB24Pixel *pixelData;		// pointer to the 24-bit pixel data
	long size;
}

@property (readonly) long size;
@property (readonly) RGB24Pixel *pixelData;		// pointer to the 24-bit pixel data

-(id)initWithPixelData:(RGB24Pixel *)pixels forWidth:(NSInteger)width andHeight:(NSInteger)height;
-(void)reuse:(RGB24Pixel *)pixels;


@end
