//
//  PixelDefs.h
//  SceneDetector
//
//  Created by Jon Gilkison on 8/7/09.
//  Copyright 2009 Interfacelab. All rights reserved.
//

// 24 bit pixel
typedef struct _RGB24Pixel {
	unsigned char red;
	unsigned char green;
	unsigned char blue;
} RGB24Pixel;
typedef RGB24Pixel * RGB24PixelPtr;


// gray pixel with alpha
typedef struct _GrayPixel {
	unsigned char gray;
	unsigned char alpha;
} GrayPixel;

// gray pixel with no alpha
typedef struct _GrayPixelNoAlpha {
	unsigned char gray;
} GrayPixelNoAlpha;
