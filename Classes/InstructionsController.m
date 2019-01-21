//
//  InstructionsController.m
//  CycleAlarm
//
//  Created by Symon on 3/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#define instrHeightEn  1725
#define instrHeightRu  2083

#import "InstructionsController.h"
#import <AudioToolbox/AudioToolbox.h>
#include <stdlib.h> 


@implementation InstructionsController

- (NSString *) saveFilePath: (int) poster
{
	NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	if (poster == 1) {
		return [[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"saveSoundAll.plist"];
	}
	if (poster == 2) {
		return [[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"saveSoundAllsleep.plist"];
	}
	return 0;
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
		
	for (int i = 0; i<2; i++) {
		NSString *myPath = [self saveFilePath:i+1];
		BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:myPath];

	if (!fileExists)
	{
		NSString *itt = [NSString stringWithFormat:@"ipod-library://item/item.mp3?id=1"];
		NSString *itt2 = @"None";
		
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSString *soundFolder;
		if (i == 0) {
			soundFolder = @"SoundSleep";
		}
		if (i == 1) {
			soundFolder = @"Sound";
		}
		NSString *str = [[NSBundle mainBundle] resourcePath];
		NSArray *arrFlags = [[NSArray alloc] initWithArray:[fileManager contentsOfDirectoryAtPath:[str stringByAppendingPathComponent:soundFolder] error:nil]];
		
		//NSArray *arrFlags2 = [NSArray array];
		if (i == 0) {// for alarm
			NSArray *arrFlags2 = [[NSArray alloc] initWithObjects:@"1", @"1", nil];
			NSArray *arriPod = [[NSArray alloc] initWithObjects:itt, itt2, nil];
			NSArray *valuesS = [[NSArray alloc] initWithObjects:arrFlags, arrFlags2, arriPod, nil]; 
			[valuesS writeToFile:[self saveFilePath:i+1] atomically:YES];
			
			[arrFlags2 release];
			[arriPod release];
			[valuesS release];
		}
		if (i == 1) { // for sleep
			NSArray *arrFlags2 = [[NSArray alloc] initWithObjects:@"2", @"1", nil];
			NSArray *arriPod = [[NSArray alloc] initWithObjects:itt, itt2, nil];
			NSArray *valuesS = [[NSArray alloc] initWithObjects:arrFlags, arrFlags2, arriPod, nil]; 
			[valuesS writeToFile:[self saveFilePath:i+1] atomically:YES];
			
			[arrFlags2 release];
			[arriPod release];
			[valuesS release];
		}
		[arrFlags release];
	} 
		
	}
	
	
}


// determined iPhone Device
- (NSString *) IphoneModel {
	size_t size;
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
	char *machine = malloc(size);
	sysctlbyname("hw.machine", machine, &size, NULL, 0);
	NSString *platform = [NSString stringWithCString:machine encoding: NSUTF8StringEncoding];
	free(machine);
	
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
	if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
	if ([platform isEqualToString:@"iPad2,1"])      return @"iPad2";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    return platform;
}


- (void)viewWillDisappear:(BOOL)animated {
	NSLog(@"WillDisApear Instrucitons");
	
	[imgInstr removeFromSuperview];
	[instrScrollView removeFromSuperview];
	[imgBack removeFromSuperview];
	[imgScrollView removeFromSuperview];
	
	
	[imgBack release];
	[imgInstr release];
	[instrScrollView release];
	[imgScrollView release];

	imgBack = nil;
	imgInstr = nil;
	instrScrollView = nil;
	imgScrollView = nil;
}
- (void)viewWillAppear:(BOOL)animated {
	int r = arc4random() %747474; 
	NSLog(@"random: %i\n", r);
	
	instrScrollView = [[UIScrollView alloc] init];
	instrScrollView.delegate = self;
	
	NSString *enRu = @"en";
	NSString * languageAllDevice = [[NSLocale preferredLanguages] objectAtIndex:0];
	NSString  *language = [[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode];
	NSString  *countryCode = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
	NSLog(@"language: allLanguage: %@, lang: %@, reg: %@", languageAllDevice, language, countryCode);
	if ([languageAllDevice isEqual:@"ru_Ru"] || [languageAllDevice isEqual:@"ru"] || [languageAllDevice isEqual:@"RU"] 
		|| [language isEqual:@"ru_Ru"] || [language isEqual:@"ru"] || [language isEqual:@"RU"] 
		|| [countryCode isEqual:@"ru_Ru"] || [countryCode isEqual:@"ru"] || [countryCode isEqual:@"RU"] ) {
		enRu = @"ru";
		iEnRu = 1;
	}
	
	NSString *s = [self IphoneModel];
	NSString *iN = [NSString stringWithFormat:@"instruction_%@_2x.png", enRu];
	
	if ([s isEqualToString:@"iPhone 4"] || [s isEqualToString:@"iPhone 4S"] 
		|| [s isEqualToString:@"iPhone 3GS"] || [s isEqualToString:@"iPod Touch 4G"])
	{
		iN = [NSString stringWithFormat:@"instruction_%@_2x.png", enRu];
	}
	if ([s isEqualToString:@"iPhone 3G"] || [s isEqualToString:@"iPod Touch 2G"] 
		|| [s isEqualToString:@"iPod Touch 3G"] || [s isEqualToString:@"iPod Touch 1G"] 
		|| [s isEqualToString:@"iPhone 1G"])
	{
		iN = [NSString stringWithFormat:@"instruction_%@_320.png", enRu];
	}
	
	
	imgHeaderView.image = [UIImage imageNamed:[NSString stringWithFormat:@"instruction_header_%@.png", enRu]];
	
	
	
	
	if ([s isEqualToString:@"iPhone 1G"] || [s isEqualToString:@"iPod Touch 2G"] || [s isEqualToString:@"iPod Touch 3G"]
		|| [s isEqualToString:@"Simulator"])
	{
		// no record audio
		
	} else {
		
		// for normal work record, listener, audio => iPhone 3g, 3gs, 4, iPod 4g, 
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
		
	}
	
	
	//=====
	float instrHeight = 0;
	if (iEnRu == 1) {
		instrHeight = instrHeightRu;
	} else if (iEnRu == 0) {
		instrHeight = instrHeightEn;
	}
	//=====
	
	imgBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@".png"]];
	imgInstr = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iN]];
	imgBack.frame = CGRectMake(5, 5, 310, 405);
	imgInstr.frame = CGRectMake(0, -2, 320, instrHeight); //10, 0, 290, 1850
	
	instrScrollView.contentSize = CGSizeMake(290, instrHeight);
	
	instrScrollView.frame = CGRectMake(0, 77, 320, 350); //15, 80, 290, 350
	
	instrScrollView.backgroundColor = [UIColor clearColor];
	instrScrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
	instrScrollView.showsVerticalScrollIndicator = NO;
	
	imgScrollView = [[UIImageView alloc] init];
	imgScrollView.frame = CGRectMake(309, 90, 4, 125);
	imgScrollView.image = [UIImage imageNamed:@"flash_scroll.png"];
	
	[instrScrollView addSubview:imgInstr];
	[self.view addSubview:imgBack];
	[self.view addSubview:instrScrollView];
	[self.view addSubview:imgScrollView];
}


- (void) beginApear:(BOOL) isApear imageView:(UIImageView *)imageView animDuration:(float) duration {
	//begin animations
	imageView.alpha = isApear;
	[UIImageView beginAnimations:nil context:NULL];
	[UIImageView setAnimationDuration:duration];
	//[UIImageView setAnimationBeginsFromCurrentState:YES];
	[UIImageView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIImageView setAnimationRepeatAutoreverses:0];
	[UIImageView setAnimationRepeatCount:1];
	imageView.alpha = !imageView.alpha;
	[UIImageView commitAnimations];
	//end animations
	
}


- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	//scrollViewWill...
	NSLog(@"touch scroll to hide");
	//imgScrollView.hidden = YES;
	if (imgScrollView.alpha == 0) {
		[self beginApear:0 imageView:imgScrollView animDuration:0.5];
	}
	
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	//scrollViewWill...
	float scrollY = instrScrollView.contentOffset.y;
	NSLog(@"touch scroll end, and hidden flash = NO y: %.f", scrollY);
	[self beginApear:1 imageView:imgScrollView animDuration:0.5];
	
}



- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
	//NSLog(@"touch scroll to top and appear hidden = 0");
	
	//=====
	float instrHeight = 0;
	if (iEnRu == 1) {
		instrHeight = 3375;
	} else if (iEnRu == 0) {
		instrHeight = 2670;
	}
	//=====
	
	float flashNewY = 90 + ((350.0 * instrScrollView.contentOffset.y) / instrHeight); //1750
	[imgScrollView setFrame:CGRectMake(imgScrollView.frame.origin.x, flashNewY,
									   imgScrollView.frame.size.width, imgScrollView.frame.size.height)];
}


- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	NSLog(@"ddf touch: %i", decelerate);
	if (!decelerate) {
		[self beginApear:1 imageView:imgScrollView animDuration:0.5];
	}
}

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view {
	NSLog(@"bool touch");
	return 1;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"touch to hide");

}




- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
