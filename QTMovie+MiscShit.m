//
//  QTMovie+MiscShit.m
//  SceneDetector
//
//  Created by Jon Gilkison on 10/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "QTMovie+MiscShit.h"


@implementation QTMovie(MiscShit)

-(void)setCurrentTimeInterval:(NSTimeInterval)interval
{
	[self setCurrentTime:[self scaleTime:interval fromSource:self]];
}

-(void)incCurrentTimeInterval:(double)seconds
{
	QTTime amount=[self scaleTime:seconds fromSource:self];
	QTTime current=[self currentTime];
	current.timeValue+=amount.timeValue;
	[self  setCurrentTime:current];
}

-(QTTime)scaleTime:(NSTimeInterval)theTime fromSource:(QTMovie *)movie
{
	if (movie==nil)
		movie=self;
	
	QTTime stime=QTMakeTimeWithTimeInterval(theTime);
	TimeScale scale=GetMovieTimeScale([movie quickTimeMovie]);
	QTTime result=QTMakeTimeScaled(stime, scale);
	
	NSLog(@"scaled time: %d",result.timeValue);
	return result;
}


-(NSInteger)calculateFrameCount
{
	NSInteger frameCount=0;
	
	// count the number of frames
	OSType whichMediaType = VIDEO_TYPE;
    
	short flags = nextTimeMediaSample + nextTimeEdgeOK;
    
	TimeValue theTime = 0;
	
    while (theTime >= 0)
	{
        frameCount++;
        GetMovieNextInterestingTime([self quickTimeMovie],
									flags,
									1,
									&whichMediaType,
									theTime,
									0,
									&theTime,
									nil);
		
        flags = nextTimeMediaSample;
    }
	
	return frameCount;
}


@end
