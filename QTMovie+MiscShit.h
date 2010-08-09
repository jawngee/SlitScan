//
//  QTMovie+MiscShit.h
//  SceneDetector
//
//  Created by Jon Gilkison on 10/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QTKit/QTKit.h>

@interface QTMovie(MiscShit)

-(NSInteger)calculateFrameCount;

-(void)setCurrentTimeInterval:(NSTimeInterval)interval;
-(void)incCurrentTimeInterval:(double)seconds;

-(QTTime)scaleTime:(NSTimeInterval)theTime fromSource:(QTMovie *)movie;

@end
