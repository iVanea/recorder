//
//  CycleAlarmAppDelegate.m
//  CycleAlarm
//
//  Created by Symon on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CycleAlarmAppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation CycleAlarmAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize tabBarBottomView, imgUpSelectedButton, tag;

#pragma mark -
#pragma mark Application lifecycle



- (IBAction) actTabBarChangeSelected:(id) Sender {
	
	[tabBarController setSelectedIndex:[Sender tag]];
	
	imgUpSelectedButton.image = [UIImage imageNamed:[NSString stringWithFormat:@"s_%i.png", [Sender tag]+1]];
	CGPoint origin;
	int minUp = 6;
	int minWidth = 64;
	switch ([Sender tag]+1) {
		case 1:
			origin = CGPointMake(0, minUp);
			break;
		case 2:
			origin = CGPointMake(minWidth, minUp);
			break;
		case 3:
			origin = CGPointMake(minWidth*2, minUp);
			break;
		case 4:
			origin = CGPointMake(minWidth*3, minUp);
			break;
		case 5:
			origin = CGPointMake(minWidth*4, minUp);
			break;
		default:
			break;
	}
	imgUpSelectedButton.frame = CGRectMake(origin.x, origin.y, minWidth, 62);
	
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
	
	/*
	// for normal work record, listener, audio
	OSStatus status = AudioSessionInitialize(NULL, NULL, NULL, NULL);
	if (status!=0) { printf(" AudioSessionInitialize ERROR!"); }
	
	UInt32 audioCategory = kAudioSessionCategory_PlayAndRecord;
	status = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(audioCategory), &audioCategory);
	if (status!=0) { printf(" AudioSessionSetProperty ERROR!"); }
	
	CFStringRef audio_route = (CFStringRef)'spkr';
	status = AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audio_route), &audio_route);
	if (status!=0) { printf(" AudioSessionSetProperty ERROR!"); }
	
	status = AudioSessionSetActive(true);
	if (status!=0) { printf(" AudioSessionSetActive ERROR!"); }
	*/
	
	
    
    // Override point for customization after application launch.

    // Add the tab bar controller's view to the window and display.
    tabBarController.delegate=self;
	[tabBarController setSelectedIndex:1];
	[window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
	[tabBarController setSelectedIndex:0];
	tabBarController.tabBar.hidden = NO; //YES
	
	
	//###########################################################################
	//tabBarBottomArtificial
	tabBarBottomView = [[UIView alloc] init];
    tabBarBottomView.frame = CGRectMake(0, 411, 320, 69);//411
	[window addSubview:tabBarBottomView];
	
	int minUp = 6;
	int minWidth = 64;
	UIImageView *imgTempView = [[UIImageView alloc] init];
	imgTempView.frame = CGRectMake(0, 0, 320, 69);
	imgTempView.image = [UIImage imageNamed:@"bar.png"];
	[tabBarBottomView addSubview:imgTempView];
	[imgTempView release];
	
	UIButton *b = [[UIButton alloc] init];
	b.frame = CGRectMake(0, minUp, 64, 62);
	b.tag = 0;
	[b setImage:[UIImage imageNamed:@"info.png"] forState:UIControlStateNormal];
	[b addTarget:self action:@selector(actTabBarChangeSelected:) forControlEvents:UIControlEventTouchUpInside];
	[tabBarBottomView addSubview:b];
	[b release];
	
	b = [[UIButton alloc] init];
	b.frame = CGRectMake(minWidth, minUp, 64, 62);
	b.tag = 1;
	[b setImage:[UIImage imageNamed:@"test.png"] forState:UIControlStateNormal];
	[b addTarget:self action:@selector(actTabBarChangeSelected:) forControlEvents:UIControlEventTouchUpInside];
	[tabBarBottomView addSubview:b];
	[b release];
	
	b = [[UIButton alloc] init];
	b.frame = CGRectMake(minWidth*2, minUp, 64, 62);
	b.tag = 2;
	[b setImage:[UIImage imageNamed:@"settings.png"] forState:UIControlStateNormal];
	[b addTarget:self action:@selector(actTabBarChangeSelected:) forControlEvents:UIControlEventTouchUpInside];
	[tabBarBottomView addSubview:b];
	[b release];
	
	b = [[UIButton alloc] init];
	b.frame = CGRectMake(minWidth*3, minUp, 64, 62);
	b.tag = 3;
	[b setImage:[UIImage imageNamed:@"alarm.png"] forState:UIControlStateNormal];
	[b addTarget:self action:@selector(actTabBarChangeSelected:) forControlEvents:UIControlEventTouchUpInside];
	[tabBarBottomView addSubview:b];
	[b release];
	
	b = [[UIButton alloc] init];
	b.frame = CGRectMake(minWidth*4, minUp, 64, 62);
	b.tag = 4;
	[b setImage:[UIImage imageNamed:@"statistics.png"] forState:UIControlStateNormal];
	[b addTarget:self action:@selector(actTabBarChangeSelected:) forControlEvents:UIControlEventTouchUpInside];
	[tabBarBottomView addSubview:b];
	//tabBarBottomView.hidden = YES;
	tabBarController.tabBar.hidden = YES;
	
	imgUpSelectedButton = [[UIImageView alloc] init];
	imgUpSelectedButton.image = [UIImage imageNamed:[NSString stringWithFormat:@"s_1.png"]];
	CGPoint origin;
	origin = CGPointMake(0, minUp);
	imgUpSelectedButton.frame = CGRectMake(origin.x, origin.y, (imgUpSelectedButton.image.size.width /2), (imgUpSelectedButton.image.size.height /2));
	[tabBarBottomView addSubview:imgUpSelectedButton];
	//###########################################################################
	

    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark UITabBarControllerDelegate methods

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

