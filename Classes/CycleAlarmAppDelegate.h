//
//  CycleAlarmAppDelegate.h
//  CycleAlarm
//
//  Created by Symon on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CycleAlarmAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
	UIView *tabBarBottomView;
	UIImageView *imgUpSelectedButton;
	NSInteger tag;
}

@property (assign) NSInteger tag;
@property (nonatomic, retain) UIView *tabBarBottomView;
@property (nonatomic, retain) UIImageView *imgUpSelectedButton;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
