    //
//  TestController.m
//  CycleAlarm
//
//  Created by Symon on 3/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#define RU = ru;
#define EN = en;

#import "TestController.h"
#include <stdlib.h> 

@implementation TestController
@synthesize Player;

- (NSString *) saveFilePath: (int) poster
{
	NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	if (poster == 1) {
		return [[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"saveSensCalibr.plist"];
	}
	return 0;
}

- (void) audioPlayerDidFinishPlaying: (AVAudioPlayer *)
player successfully: (BOOL) completed {
	if (completed == YES) {
		// if soped to finsih:
		
		// replay to finish:
		[self.Player play];
	}

}

- (IBAction) sliderToMoved {
	//sliderSensitivity.value = 0.5;
	//NSLog(@"slider: %f \n", sliderSensitivity.value);
	if (sliderSensitivity.value > 0.02 && sliderSensitivity.value < 0.03) {
		sliderSensitivity.value = 0.02;
	}
	if (sliderSensitivity.value > 0.03 && sliderSensitivity.value < 0.04) {
		sliderSensitivity.value = 0.03;
	}
	if (sliderSensitivity.value > 0.04 && sliderSensitivity.value < 0.05) {
		sliderSensitivity.value = 0.04;
	}
	if (sliderSensitivity.value > 0.05 && sliderSensitivity.value < 0.06) {
		sliderSensitivity.value = 0.05;
	}
	if (sliderSensitivity.value > 0.06 && sliderSensitivity.value < 0.07) {
		sliderSensitivity.value = 0.06;
	}
	if (sliderSensitivity.value > 0.07 && sliderSensitivity.value < 0.07999999) {
		sliderSensitivity.value = 0.07;
	}
	NSLog(@"slider: %f \n", sliderSensitivity.value);
}

- (IBAction) actUp: (id) sender {
	UIButton *bt = (UIButton *) sender;
	CGPoint pos = iBackView.center;
	
	switch (bt.tag) {
		case 0:
			[UIView beginAnimations:nil context:NULL];	
			[UIView setAnimationDuration:0.5];
			pos.y = 107;
			pos.x = iBackView.center.x;
			iBackView.center = pos;	
			[UIView commitAnimations];
			
			[UIView beginAnimations:nil context:NULL];	
			[UIView setAnimationDuration:0.5];
			pos.y = 251;
			pos.x = bTestUp.center.x;
			bTestUp.center = pos;	
			[UIView commitAnimations];
			
			bTestUp.tag = 1;
			//sliderSensitivity.hidden = NO;
			[bTestUp setImage:[UIImage imageNamed:@"bTestUpDown.png"] forState:UIControlStateNormal];
			break;
		case 1:
			[UIView beginAnimations:nil context:NULL];	
			[UIView setAnimationDuration:0.5];
			pos.y = 190;
			pos.x = iBackView.center.x;
			iBackView.center = pos;	
			[UIView commitAnimations];
			
			[UIView beginAnimations:nil context:NULL];	
			[UIView setAnimationDuration:0.5];
			pos.y = 338;
			pos.x = bTestUp.center.x;
			bTestUp.center = pos;	
			[UIView commitAnimations];
			
			bTestUp.tag = 0;
			//sliderSensitivity.hidden = YES;
			[bTestUp setImage:[UIImage imageNamed:@"bTestUp.png"] forState:UIControlStateNormal];
			break;
		default:
			break;
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


- (void) startPlayAlarm {
	/*
	int iIdSound = [lIdSound.text intValue];
	//fIdSound +=1;
	int iPrefix = 0;
	if (iIdSound<10) {iPrefix = 0;} else {iPrefix = 1;}
	NSString *nSound = [NSString stringWithFormat:@"sound%i_%i", iPrefix, iIdSound];
	*/
	NSString *nSound = @"CaptainS";
	
	//======================= start play
	//NSLog(@"\n music: %i\n", iIdSound);
	NSString *path = [[NSBundle mainBundle] pathForResource:nSound
													 ofType:@"wav"];
	NSURL *file = [[NSURL alloc] initFileURLWithPath:path];	
	AVAudioPlayer *p = [[AVAudioPlayer alloc] initWithContentsOfURL:file error:nil];
	[file release];	
	self.Player = nil;
	self.Player = p; 
	[p release];
	
	[Player prepareToPlay];
	[Player setDelegate:self];
	//[self.player setVolume:10.0];
	//======================= end play
	NSLog(@"player test");
}

- (void) pointGray {
	iPoint1.image = [UIImage imageNamed:@"selected"];
	iPoint2.image = [UIImage imageNamed:@"selected"];
	iPoint3.image = [UIImage imageNamed:@"selected"];
	iPoint4.image = [UIImage imageNamed:@"selected"];
	iPoint5.image = [UIImage imageNamed:@"selected"];
	
}

- (IBAction) actTestCancel {
	musicMP.volume = 0.3;
	[self pointGray];
	[self.Player stop];
	self.Player.currentTime = 0.0;
	
	lSensibilityTestView.text = @"0";
	tIntAlertYes = 0;

	if (timeNS) {
	   [timeNS invalidate];
	   timeNS = nil;
	}
	if (timeNSMax) {
		[timeNSMax invalidate];
		timeNSMax = nil;
	}
}


- (IBAction) actTest: (id) sender {
	UIButton *bt = (UIButton *) sender;
	
	if (bt.tag == 0) {

	bt.tag = 1;
	[bt setImage:[UIImage imageNamed:@"bGoClockStop.png"] forState:UIControlStateNormal];	
		
	lblSaveX.text = [NSString stringWithFormat:@"%f", xAx];
	lblSaveY.text = [NSString stringWithFormat:@"%f", yAx];
	lblSaveZ.text = [NSString stringWithFormat:@"%f", zAx];
		
	if (!timeNS) {
		timeNS = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(fTime) userInfo:nil repeats:YES];
		NSLog(@"time Test Ns\n");
	}
	if (!timeNSMax) { //sensibility duration after
		timeNSMax = [NSTimer scheduledTimerWithTimeInterval:0.9 target:self selector:@selector(fTimeMax) userInfo:nil repeats:YES];
		NSLog(@"time Test NsMax\n");
	}
		
	} else {
		[self actTestCancel];
		bt.tag = 0;
		[bt setImage:[UIImage imageNamed:@"calibStart.png"] forState:UIControlStateNormal];	
	}

}

- (void) fTimeMax {

	if (tPlusMax == ttplus) {
		tPlusMax = 0;
		if (tPlusMax == 0) {
			musicMP.volume = 0.3;
			[self pointGray];
			[self.Player stop];
			self.Player.currentTime = 0.0;
		}
		lSensibilityTestView.text = [NSString stringWithFormat:@"%i", tPlusMax];
	}
	ttplus = tPlusMax;
}

- (void) fTime {
	//flMedia = xAx+yAx+zAx;
	
	if (tIntAlertYes <1) {
	}
	else {
		//[self actTest];
		int tii = 0;

		//flMedia = xAx+yAx+zAx;
		//flMediaLast = [lblSaveX.text floatValue] + [lblSaveY.text floatValue] + [lblSaveZ.text floatValue];
		// Max Sensitivity Accelerometer Test 0.02, minimum 0.08, 3g max 0.05

		// invert value slider
		float tSensAcc = 0.10 - sliderSensitivity.value;
		//NSLog(@"se: %f \n", tSensAcc);
		
		if (sqrt(pow(([lblSaveX.text floatValue]-xAx), 2)) > tSensAcc) {
			tii = 1;
		}
		if (sqrt(pow(([lblSaveY.text floatValue]-yAx), 2)) > tSensAcc) {
			tii = 1;
		}
		if (sqrt(pow(([lblSaveZ.text floatValue]-zAx), 2)) > tSensAcc) {
			tii = 1;
		}
		
				 
		if (tii == 1) {
			NSLog(@"\n Alert Alarm X\n");
			
			NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
						
			//NSLog(@"70:%f,\n", (time - f70));
			
			tPlusMax += 1;
			
			
			
			lSensibilityTestView2.text = [NSString stringWithFormat:@"%i", tIntAlertYes];
			
			if ([lSensibilityTestView.text intValue] > 0 && bTestTestView.tag == 1) {
				switch ([lSensibilityTestView.text intValue]) {
					case 1:
						iPoint1.image = [UIImage imageNamed:@"selected_1_"];
						break;
					case 2:
						iPoint1.image = [UIImage imageNamed:@"selected_1_"];
						iPoint2.image = [UIImage imageNamed:@"selected_1_"];
						break;
					case 3:
						iPoint1.image = [UIImage imageNamed:@"selected_1_"];
						iPoint2.image = [UIImage imageNamed:@"selected_1_"];
						iPoint3.image = [UIImage imageNamed:@"selected_1_"];
						break;
					case 4:
						iPoint1.image = [UIImage imageNamed:@"selected_1_"];
						iPoint2.image = [UIImage imageNamed:@"selected_1_"];
						iPoint3.image = [UIImage imageNamed:@"selected_1_"];
						iPoint4.image = [UIImage imageNamed:@"selected_1_"];
						break;
					case 5:
						iPoint1.image = [UIImage imageNamed:@"selected_1_"];
						iPoint2.image = [UIImage imageNamed:@"selected_1_"];
						iPoint3.image = [UIImage imageNamed:@"selected_1_"];
						iPoint4.image = [UIImage imageNamed:@"selected_1_"];
						iPoint5.image = [UIImage imageNamed:@"selected_1_"];
						break;
					default:
						break;
				}
				if ([lSensibilityTestView.text intValue] > 5 && bTestTestView.tag == 1) {
					iPoint1.image = [UIImage imageNamed:@"selected_1_"];
					iPoint2.image = [UIImage imageNamed:@"selected_1_"];
					iPoint3.image = [UIImage imageNamed:@"selected_1_"];
					iPoint4.image = [UIImage imageNamed:@"selected_1_"];
					iPoint5.image = [UIImage imageNamed:@"selected_1_"];
				}
			}
			
			
			
			//sensibility duration after
			if ((time - f70)<0.9) {
				lSensibilityTestView.text = [NSString stringWithFormat:@"%i", tPlusMax];
				musicMP = [MPMusicPlayerController iPodMusicPlayer];
				
				if (tPlusMax == 1) {
					musicMP.volume = 0.3;
					[self startPlayAlarm];
					[self.Player play];
					//[self.Player setVolume:8.0];
				}
				else {
					if ((([lSensibilityTestView.text intValue]/10)+0.3)<=1.0) {
						musicMP.volume = ([lSensibilityTestView.text floatValue]/10)+0.3;
					}
					else {
						musicMP.volume = 1.0;
					}

					//[self.Player setVolume:8.0];
					NSLog(@"volume:%f\n", ([lSensibilityTestView.text floatValue]/10));
				}

			}
			else {
				lSensibilityTestView.text = [NSString stringWithFormat:@"%i", tPlusMax];
				tPlusMax = 0;
				self.Player.currentTime = 0.0;
				//[self.Player setVolume:0.0];
			}
			
			f70  = time;
			

		lblSaveX.text = [NSString stringWithFormat:@"%f", xAx];
		lblSaveY.text = [NSString stringWithFormat:@"%f", yAx];
		lblSaveZ.text = [NSString stringWithFormat:@"%f", zAx];
		
		tIntAlertYes = 0;
		tti = 0;
		tii = 0;
		}
		
	}
//	NSLog(@"fff:%f, \n", sqrt(pow((flMedia-flMediaLast), 2)));
	
	//[myTimer2 invalidate];
	//flMediaLast = xAx+yAx+zAx;
}

- (void) alertGo {

	tIntAlertYes += 1;
	
}



- (void) accelerometer:(UIAccelerometer *) accelerometer
		 didAccelerate:(UIAcceleration *) acceleration
{   
	xAx = acceleration.x;
	yAx = acceleration.y;
	zAx = acceleration.z;
	
	if (xAx>0.5) {
		//	[self.player play];
	}
	
	xAx = (int) (xAx *100); xAx /= 100;	
	yAx = (int) (yAx *100); yAx /= 100;
	zAx = (int) (zAx *100); zAx /= 100;
	
	xax.text = [NSString stringWithFormat:@"X is %f", xAx];
	yax.text = [NSString stringWithFormat:@"Y is %f", yAx];
	zax.text = [NSString stringWithFormat:@"Z is %f", zAx];
	
	float xSave = [lblSaveX.text floatValue];
	float ySave = [lblSaveY.text floatValue];
	float zSave = [lblSaveZ.text floatValue];
	
	xSave = sqrt(pow(xSave, 2));
	ySave = sqrt(pow(ySave, 2));
	zSave = sqrt(pow(zSave, 2));
	
	xAx = sqrt(pow(xAx, 2));
	yAx = sqrt(pow(yAx, 2));
	zAx = sqrt(pow(zAx, 2));		
	
	/*
	 kSens = sliderSensitive.value;
	kSens = (1.0 - kSens);
	if (kSens<0.03) { kSens = 0.03; }
	if (kSens>0.95) { kSens = 0.95; }
	*/
	// max sensibility 0.03, medium 0.08, small 0.12
	kSens = 0.0;
	//NSLog(@"kSens %f", kSens);		
	
	if ([lblSaveX.text isEqualToString:@"SaveX"]) {}  else
	{	
		tti = 0;
		if (sqrt(pow((xSave-xAx), 2)) > kSens) {
			//NSLog(@"\n Alert Alarm X\n");
			//[self alertGo];
			tti = 1;
		}
		if (sqrt(pow((ySave-yAx), 2)) > kSens) {
			//NSLog(@"\n Alert Alarm Y\n");
			//[self alertGo];
			tti = 1;
		}	
		if (sqrt(pow((zSave-zAx), 2)) > kSens) {
			//NSLog(@"\n Alert Alarm Z \n");
			//[self alertGo];
			tti = 1;
		}
		if (tti == 1) {
			    [self alertGo];
		}
	}
	//NSLog(@"\n\n %f, %f, %f", kSens, sqrt(pow((zSave-zAx), 2)), zSave);
	
}







- (void)viewWillAppear:(BOOL)animated {
	//startAlarmPlay
	//[self startPlayAlarm];
	
	//accelerometer
	accel = [UIAccelerometer sharedAccelerometer];
	accel.delegate = self;
	accel.updateInterval = 1.0f/24.0f;
	
	lblSaveX.text = @"SaveX";
	
	//NSDate
	NSDateFormatter *dateformater = [[NSDateFormatter alloc]init];
	[dateformater setDateFormat:@"YYYY"];
	//int yearS = [[dateformater stringFromDate:[NSDate date]] intValue];
	[dateformater release];
	
}

- (void)viewDidLoad {
    [super viewDidLoad];
	NSLog(@"viewDidLoad TestController");
	
	
	//=language
	NSString *enRu = @"en";
	NSString * languageAllDevice = [[NSLocale preferredLanguages] objectAtIndex:0];
	NSString  *language = [[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode];
	NSString  *countryCode = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
	NSLog(@"language: allLanguage: %@, lang: %@, reg: %@", languageAllDevice, language, countryCode);
	if ([languageAllDevice isEqual:@"ru_Ru"] || [languageAllDevice isEqual:@"ru"] || [languageAllDevice isEqual:@"RU"] 
		|| [language isEqual:@"ru_Ru"] || [language isEqual:@"ru"] || [language isEqual:@"RU"] 
		|| [countryCode isEqual:@"ru_Ru"] || [countryCode isEqual:@"ru"] || [countryCode isEqual:@"RU"] ) {
		enRu = @"ru";
	}
	iUpView.image = [UIImage imageNamed:[NSString stringWithFormat:@"iCalibUMBR_%@.png", enRu]];
	iHeaderView.image = [UIImage imageNamed:[NSString stringWithFormat:@"calibration_header_%@.png", enRu]];
	if ([enRu isEqual:@"ru"]) {
		iUpView.frame = CGRectMake(iUpView.frame.origin.x, iUpView.frame.origin.y, 320, 297);
	} else if ([enRu isEqual:@"en"]) {
		iUpView.frame = CGRectMake(iUpView.frame.origin.x, iUpView.frame.origin.y, 320, 279);
	}

	//=
	
	[iBackView addSubview:iUpView];
	bTestUp.frame = CGRectMake(320 , 170, 77, 31);
	iUpView.frame = CGRectMake(0, 45, 320, 265);
	//iDowndView.frame = CGRectMake(0, 0, 0, 0);
	
	[sliderSensitivity setMinimumTrackImage:[UIImage imageNamed:@"slider_foot.png" ] forState:UIControlStateNormal];
	[sliderSensitivity setMaximumTrackImage:[UIImage imageNamed:@"slider_top.png" ] forState:UIControlStateNormal];
	// circle png
	[sliderSensitivity setThumbImage:[UIImage imageNamed:@"slider.png" ] forState:UIControlStateNormal];
	
	NSString *myPath = [self saveFilePath:1];
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:myPath];
	
	
	
	
	
	
	NSString *s = [self IphoneModel];
	
	//standart device reomend
	NSString *stSensCalibr = @"0.04";
	imgRecommView.frame = CGRectMake(320, 273, 16, 10);
	imgRecommView.image = [UIImage imageNamed:@"recommArrow.png"];
	
	
	if ([s isEqualToString:@"iPhone 4"] || [s isEqualToString:@"iPod Touch 4G"] || [s isEqualToString:@"iPhone 4S"])
	{
		stSensCalibr = @"0.08";
		
		imgRecommView.frame = CGRectMake(320, 273, 16, 10);
		imgRecommView.image = [UIImage imageNamed:@"recommArrow.png"];
	}
	
	if ([s isEqualToString:@"iPhone 3G"] || [s isEqualToString:@"iPhone 3GS"] || [s isEqualToString:@"iPod Touch 3G"])
	{
		stSensCalibr = @"0.04";
		imgRecommView.frame = CGRectMake(320, 273, 16, 10);
		imgRecommView.image = [UIImage imageNamed:@"recommArrow.png"];
	}
	if ([s isEqualToString:@"iPod Touch 2G"] || [s isEqualToString:@"iPod Touch 1G"] || [s isEqualToString:@"iPhone 1G"])
	{
		stSensCalibr = @"0.03";
		imgRecommView.frame = CGRectMake(320, 273, 16, 10);
		imgRecommView.image = [UIImage imageNamed:@"recommArrow.png"];
	}
	
	
	
	
	if (!fileExists)
	{
		
		NSArray *valuesS = [[NSArray alloc] initWithObjects: stSensCalibr, nil]; 
		[valuesS writeToFile:[self saveFilePath:1] atomically:YES];
		sliderSensitivity.value = [stSensCalibr floatValue];
		
		[valuesS release];
		valuesS = nil;
	} else {
		NSString *myPath3 = [self saveFilePath:1];
		NSArray *values3 = [[NSArray alloc] initWithContentsOfFile:myPath3];
		NSString *stringSens = [NSString stringWithFormat:@"%@",[values3 objectAtIndex:0]];
		sliderSensitivity.value = [stringSens floatValue];
		
		[values3 release];
		values3 = nil;
	}

}



- (void)viewWillDisappear:(BOOL)animated {
	NSLog(@"disApear Test");
	[self actTestCancel];
	bTestTestView.tag = 0;
	[bTestTestView setImage:[UIImage imageNamed:@"calibStart.png"] forState:UIControlStateNormal];	
	
	bTestUp.tag = 1;
	[self actUp: (UIButton *) bTestUp];
	
	
	//save sensCalibr
	NSString *stSensCalibr = [NSString stringWithFormat:@"%f", sliderSensitivity.value];
	NSArray *valuesS = [[NSArray alloc] initWithObjects: stSensCalibr, nil]; 
	[valuesS writeToFile:[self saveFilePath:1] atomically:YES];
	
	[valuesS release];
	valuesS = nil;
}
-(void) viewDidAppear:(BOOL)animated {
	NSLog(@"didApear Test");
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
