#import <Foundation/Foundation.h>
#import "ILSlitScanner.h"

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	[NSApplication sharedApplication];
	
	NSUserDefaults *args = [NSUserDefaults standardUserDefaults];
	
	NSString *input=[args stringForKey:@"input"];
	
	NSString *output=[args stringForKey:@"output"];
	NSString *prefix=[args stringForKey:@"prefix"];
	
	NSInteger start=[args integerForKey:@"start"];
	NSInteger end=[args integerForKey:@"end"];
	NSInteger distance=[args integerForKey:@"distance"];
	float offset=[args floatForKey:@"offset"];
	
	
	ILSlitScanner *scanner=[[ILSlitScanner alloc] initWithMoviePath:input
														   exportTo:output 
														 filePrefix:prefix 
													   slitDistance:distance 
														 startFrame:start 
														   endFrame:end 
															 offset:offset];

    [pool drain];
    return 0;
}
