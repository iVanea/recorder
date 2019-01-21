//
//  ClockView.m
//  CycleAlarm
//
//  Created by Symon on 3/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ClockViews.h"

@implementation ClockViews


float Degrees2Radians(float degrees) { return degrees * M_PI / 180; }


- (void) start{
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self 
										   selector:@selector(updateClock) 
										   userInfo:nil repeats:YES];
}
- (void) stop{
    [timer invalidate];
    timer = nil;
}

- (void) updateClock{
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) 
                                                                       fromDate:[NSDate date]];
    NSInteger seconds = [dateComponents second];
    NSInteger minutes = [dateComponents minute];
    NSInteger hours = [dateComponents hour];
	
	NSString *tString = [NSString stringWithFormat:@"%i", hours];
	//NSLog(@"Hours: ==== %@", tString);
	
	if (hours>12) {
		hours -= 12; 
	}
	float secAll = (hours * 3600) + (minutes * 60) + (seconds);
	secAll /= 3600;
	
	float minAll = (minutes * 60) + (seconds);
	minAll /= 60;
	//NSLog(@"HoursAll: ==== %f", secAll);
	
    //correction of inverted clock
    seconds += 30; seconds %=60;
    minutes += 30; minutes %=60;
    //hours += 6; hours %=12;
	
	tString = [NSString stringWithFormat:@"%d", hours];
	//NSLog(@"Hours2: ==== %@", tString);
	
	
    hourHand.transform = CATransform3DMakeRotation (3.14*(1+(secAll/6)), 0, 0, 1);
   // minHand.transform = CATransform3DMakeRotation (Degrees2Radians(minutes*360/60), 0, 0, 1);
	minHand.transform = CATransform3DMakeRotation (3.14*(1+(minAll/30)), 0, 0, 1);
    secHand.transform = CATransform3DMakeRotation (Degrees2Radians(seconds*360/60), 0, 0, 1);
}
- (void) layoutSubviews{
    [super layoutSubviews];
	
    containerLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
	
  //  float length = MIN(self.frame.size.width, self.frame.size.height)/2;
    CGPoint c = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    hourHand.position = minHand.position = secHand.position = c;
	
    //hourHand.bounds = CGRectMake(0,0,10,length*0.5);
    //minHand.bounds = CGRectMake(0,0,8,length*0.8);
    //secHand.bounds = CGRectMake(0,0,4,length); 17 186
	hourHand.bounds = CGRectMake(0,0,28,101);
	minHand.bounds = CGRectMake(0,0,28,131);
	secHand.bounds = CGRectMake(0,0,12,124);
	
    hourHand.anchorPoint = CGPointMake(0.5,0.0);
    minHand.anchorPoint = CGPointMake(0.5,0.0);
    secHand.anchorPoint = CGPointMake(0.3,0.0);
	
}

- (id)initWithFrame:(CGRect)frame {
	
    self = [super initWithFrame:frame];
    if (self) {
		
        containerLayer = [[CALayer layer] retain];
		
        hourHand = [[CALayer layer] retain];
        minHand = [[CALayer layer] retain];
        secHand = [[CALayer layer] retain];
		/*
        //paint your hands: simple colors
        hourHand.backgroundColor = [UIColor blackColor].CGColor;
        hourHand.cornerRadius = 3;
        minHand.backgroundColor = [UIColor grayColor].CGColor;
        secHand.backgroundColor = [UIColor whiteColor].CGColor;
        secHand.borderWidth = 1.0;
        secHand.borderColor = [UIColor grayColor].CGColor;
		*/
        //put images
        hourHand.contents = (id)[UIImage imageNamed:@"igSec.png"].CGImage;
        minHand.contents = (id)[UIImage imageNamed:@"igMinute2.png"].CGImage;
        secHand.contents = (id)[UIImage imageNamed:@"igSecond.png"].CGImage;
		
		UIImageView *tImgClock = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iGoClock5.png"]];
		tImgClock.frame = CGRectMake(29, 84, 266, 266);		
		UIImageView *tImgCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"igCircle.png"]];
		tImgCircle.frame = CGRectMake(125, 178, 72, 72);	
		[self.layer addSublayer:tImgClock.layer];
		
        [containerLayer addSublayer:hourHand];
        [containerLayer addSublayer:minHand];
        [containerLayer addSublayer:secHand];
        [self.layer addSublayer:containerLayer];
		
        self.layer.borderColor = [UIColor clearColor].CGColor;
        self.layer.borderWidth = 1.0;
		[self.layer addSublayer:tImgCircle.layer];
		
		
		/*bStop = [[UIButton alloc] initWithFrame:CGRectMake(160, 300, 20, 20)];
		[self.layer addSublayer:bStop.layer];*/
		
		[tImgClock release];
		[tImgCircle release];
		
    }
    return self;
}
- (void)dealloc {
    [self stop];
    [hourHand release];
    [minHand release];
    [secHand release];
    [containerLayer release];
    [super dealloc];
}


@end
