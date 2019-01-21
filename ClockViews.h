//
//  ClockViews.h
//  CycleAlarm
//
//  Created by Symon on 3/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ClockViews : UIView {
    CALayer *containerLayer;
    CALayer *hourHand;
    CALayer *minHand;
    CALayer *secHand;
    NSTimer *timer;
	
	UIButton *bStop;
}
- (void) start;
- (void) stop;


@end
