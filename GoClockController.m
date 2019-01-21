//
//  GoClockController.m
//  CycleAlarm
//
//  Created by Symon on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GoClockController.h"
//#import "ClockViews.h"
#include <stdlib.h> 

@implementation GoClockController
@synthesize hourS, minS, iCycle, i4View, soundPlayer, audioPlayerMusic;

- (void)viewWillAppear:(BOOL)animated {
	cycleAlarmDlg = (CycleAlarmAppDelegate *) [[UIApplication sharedApplication] delegate];
	[cycleAlarmDlg.tabBarBottomView performSelector:@selector(setHidden:) withObject:@"1" afterDelay:0.3];
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // display in 12HR/24HR (i.e. 11:25PM or 23:25) format according to User Settings
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *current = [dateFormatter stringFromDate:today];
    [dateFormatter release];
    currentTime.text = current;

}


- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    return newImage;
}

-(UIImage*)imageFromString:(NSString*)str {
	UIImage *image;
	UIGraphicsBeginImageContext(CGSizeMake([str length]*18, 18));
	
	for (int i=0,s=0;i<[str length];s+=18,i++){
		if (/*[str characterAtIndex:i-1]=='1'*/ i == 2) {
			s+=2;
		}
		if (i == 3) {
			s-=12;
		}
		image = [UIImage imageNamed:[NSString stringWithFormat:@"%cl.png",[str characterAtIndex:i]]];
		//image = [self imageWithImage:image scaledToSize:CGSizeMake(image.size.width / 2.0, image.size.height / 2.0)];
		[image drawAtPoint:CGPointMake(s,0)];
		NSLog(@"%cl.png", [str characterAtIndex:i]);
	}
	
	UIImage *number = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return number;
	
}

- (NSString *) saveFilePath: (int) poster
{
	NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	if (poster == 1) {
		return [[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"saveTimeAlarm.plist"];
	}
	if (poster == 2) {
		return [[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"saveTimeCycle.plist"];
	}
	if (poster == 3) {
		return [[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"saveTimeCycle.plist"];
	}
	if (poster == 5) {
		return [[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"saveSoundAll.plist"];
	}
	if (poster == 4) {
		return [[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"saveSoundAllsleep.plist"];
	}
	if (poster == 6) {
		return [[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"saveMinutes.plist"];
	}
	if (poster == 7) {
		return [[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"saveArrayStat.plist"];
	}
	if (poster == 8) {
		return [[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"saveArrayAllStatistics.plist"];
	}
	return 0;
}

- (void) audioPlayerDidFinishPlaying: (AVAudioPlayer *)
player successfully: (BOOL) completed {
	if (completed == YES) {
		// if soped to finsih:
		
		// replay to finish:
		[self.soundPlayer play];
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
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
	if ([platform isEqualToString:@"iPad2,1"])      return @"iPad2";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    return platform;
}


- (void) timeMinEnd {
	if (timerMinSleepEnd) {
	[timerMinSleepEnd invalidate];
	timerMinSleepEnd = nil;
	}
	[self stopAllMelody];
}

- (void) showAlarm {
		
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateStyle = NSDateFormatterMediumStyle;
	//NSString * text = [NSString stringWithFormat:@"%@", [df stringFromDate:myTimeAlarm.date]];
	//i4View = 2; // because is send in h.i4View = icycle
	// 4 view alarm clock, 4 = all, 1 = fixclock, 2 = fix && optimal asleep, 3 = optimal && noise
	int iggoAlarm = 1; 
	

	[df setDateFormat:@"HH"];	
	int hourD = [[df stringFromDate:[NSDate date]] intValue];	
	
	[df setDateFormat:@"mm"];
	int minD = [[df stringFromDate:[NSDate date]] intValue];
	NSTimeInterval tTt1970Now = [[NSDate date] timeIntervalSince1970];
	
	
	
	
	
	//============f===============
	if (recorderFileHLoad) {
		
		if (hourD == hourS && ((minS - minD) == 1)) {
			recorderFileHLoad.iRecordStoped = 1; // 1 == stop; post iRecordStoped for no record in las minute for no bad (10 sec records)
			NSLog(@"1 no posible record, beacuse remaining the last 1 minutes");
		}
		if (((hourS - hourD) == 1) && (minS == 0) && (minD==59)) {
			recorderFileHLoad.iRecordStoped = 1; // 1 == stop; post iRecordStoped for no record in las minute for no bad (10 sec records)
			NSLog(@"2 no posible record, beacuse remaining the last 1 minutes");
		}
	
	}
	//============f===============

	
		
	//NSTimeInterval tt1970present = [[NSDate date] timeIntervalSince1970];
	//NSLog(@"i4view selected: %i\n", i4View);
	
	if ((tTt1970Now - t1970start) >= (60*30)) { //if all time the clock is biggest 60 min, => go optimal4VIew is corect to asleep
		iOptimal4ViewBool = 1;
		NSLog(@"(tTt1970Now - t1970start) >= (60*30) go to asleep (optimal time)\n");
	}
	
	
	
	// =================================== verify 4 view ===
	if ((i4View == 4 || i4View == 2 || i4View == 3) && iOptimal4ViewBool == 1) { //iOptimal4ViewBool == 1, => is ok, to all time is biggest 60 min, go verify optimal to asleep 
		
		/*if ((tt1970present - t1970start) < (60 * 30)) {
			if ([hTest boolReturnStage] == 1) {
				iggoAlarm = 0;
			}
		}*/
		
		// hours 30 min -> verify stage
		if ((hourS - hourD) == 0) {
			if ((minS-minD)<=30) { 
				if ([hTest boolReturnStage] == 1) {
					iggoAlarm = 0;
					NSLog(@"(hourS - hourD) == 0\n");
				}
			}
		}
		
	    if ((hourS - hourD) == 1) {
			if (((60-minD)+minS)<=30) {
				if ([hTest boolReturnStage] == 1) {
					iggoAlarm = 0;
					NSLog(@"(hourS - hourD) == 1\n");
				}
			}
	    }
		
		if ((hourS - hourD) == -1) {
				if ([hTest boolReturnStage] == 1) {
					iggoAlarm = 0;
					NSLog(@"(hourS - hourD) == -1\n");
				}
	    }
		/*if ((tTt1970Now - t1970start) < (60*30)) { //if small 30 min from start no igoalarm = 0;
			iggoAlarm = 1;
		}*/
	}
	
	if ((i4View == 4 || i4View == 1 || i4View == 2) && i4View != 3) {
		// watch fix
		if ((hourD == hourS && minD==minS)) {
			iggoAlarm = 0;
		}
	}
	// =================================== verify 4 view ===
		
	
	if (iiGoSaveinFile == 1) {
		iggoAlarm = 1; // not alarm echo ))
	}
	
	// save in file ===========================================
	if (iggoAlarm == 0 || iiGoSaveinFile == 1)
	{	
		if (iiGoSaveinFile != 1) {
			// testGraph stop
			[hTest TestGraphCancel];
			[hTest didLoadAllDealoc];
		}
		
		
		NSString *deepC = [NSString stringWithFormat:@"%i", [hTest boolReturnDeepCycle]];
		NSString *lightC = [NSString stringWithFormat:@"%i", [hTest boolReturnLightCycle]];
		NSString *noiseC;
		NSLog(@"post gegin boolReturn Cycle, deep: %@, light: %@\n", deepC, lightC);
		if (recorderFileHLoad) {
			noiseC = [NSString stringWithFormat:@"%i", [recorderFileHLoad funcReturnRecordCount]];
		} else {
			noiseC = [NSString stringWithFormat:@"%i", 0];
		}

		
		
		// time start end =========
		NSDateFormatter *df = [[NSDateFormatter alloc] init];
		df.dateStyle = NSDateFormatterMediumStyle;
		
		[df setDateFormat:@"LLLL dd, yyyy"];	
		NSString *stringDateStartEnd = [df stringFromDate:[NSDate date]];
		[df setDateFormat:@"HH:mm"];
		NSString *stringHmStartEnd = [df stringFromDate:[NSDate date]];
		NSLog(@"Time2 %@, %@\n", stringDateStartEnd, stringHmStartEnd);
		
		NSTimeInterval t1970end = [[NSDate date] timeIntervalSince1970];
	    NSTimeInterval tIntervalDateSec = t1970end - t1970start;
		
		NSString *thAs = [NSString stringWithFormat:@"%d", (int)(tIntervalDateSec / 3600)];
		NSString *tminAs = [NSString stringWithFormat:@"%0.0f", ((tIntervalDateSec / 60)  - ((int)(tIntervalDateSec / 3600) * 60))];
		
		if ([thAs intValue] <= 9) {
			thAs = [NSString stringWithFormat:@"0%i", [thAs intValue]];
		}
		if ([tminAs intValue] <= 9) {
			tminAs = [NSString stringWithFormat:@"0%i", [tminAs intValue]];
		}
		
		NSString *tIntervalResult = [NSString stringWithFormat:@"%@:%@", thAs, tminAs];
		NSLog(@"time1970: %0.0f, %0.0f,\n", t1970end, t1970start);
		[df release];
		// time startend =========
		
		// save arr ====================
		NSMutableArray *arrNoise;
		NSMutableArray *arrNoiseFile;
		
		
		
		int iBoolNorRecord = 0;
		NSString *s = [self IphoneModel];
		
		if ([s isEqualToString:@"iPhone 1G"] || [s isEqualToString:@"iPod Touch 2G"] || [s isEqualToString:@"iPod Touch 3G"]  || [s isEqualToString:@"Simulator5"])
		{
			NSLog(@" no record no microphone model\n");
			iBoolNorRecord = 1; // no record, because not exist mic
			
		} 
			
		
		if ((i4View == 4 || i4View == 3) && iBoolNorRecord == 0) {
			arrNoise = [[NSMutableArray alloc] initWithArray:[recorderFileHLoad funcReturnSaveArrInFile]];
			arrNoiseFile = [[NSMutableArray alloc] initWithArray:[recorderFileHLoad funcReturnNoisePathNameFileArray]];
			[recorderFileHLoad ObjectUnLoad];
			
			[recorderFileHLoad release];
			recorderFileHLoad = nil;
		} else {
			arrNoise = [[NSMutableArray alloc] init]; // noise statistics
			arrNoiseFile = [[NSMutableArray alloc] init]; // noise statistics file recording 
		}
		
		
		
		NSArray *values3 = [[NSArray alloc] initWithContentsOfFile:[self saveFilePath:7]];
		//NSLog(@"all elements: %@, %@, %@, %@, %@, %@, %@, \n", stringDateStart, stringHmStart, stringHmStartEnd, tIntervalResult, lightC, deepC, noiseC);
		NSArray *ttarrd = [[NSArray alloc] initWithContentsOfFile:[self saveFilePath:8]];
		NSMutableArray *arrMutAll = [[NSMutableArray alloc] initWithArray:ttarrd];
		/*if (arrMutAll == NULL) {
		 [arrMutAll removeAllObjects];
		 }*/
		// in array exist: Marth 1, 2011; start 22:00; end 7:00; interval 8:00; light 5; deep 4; noise 5; 		
		NSArray *arrSaveInFile = [[NSArray alloc] initWithObjects:stringDateStart, stringHmStart, stringHmStartEnd, tIntervalResult, lightC, deepC, noiseC, nil];	
		NSArray *arr4Save = [[NSArray alloc] initWithObjects:arrSaveInFile, values3, arrNoise, arrNoiseFile, nil];
		
		[arrMutAll addObject:arr4Save];	
		//NSLog(@"arraysave: %@, arayMut: %@,\n", arr4Save, arrMutAll);
		
		if ([stringHmStartEnd isEqualToString:stringHmStart]) { } else {
			[arrMutAll writeToFile:[self saveFilePath:8] atomically:YES];
		}
		
		
		[arrNoise release];
		[arrNoiseFile release];
		[values3 release];
		[ttarrd release];
		[arrMutAll release];
		[arrSaveInFile release];
		[arr4Save release];
		
		[stringDateStart release];
		[stringHmStart release];
		
		arrNoise = nil;
		arrNoiseFile = nil;
		values3 = nil;
		ttarrd = nil;
		arrMutAll = nil;
		arrSaveInFile = nil;
		arr4Save = nil;
		// save arr end =================
	}
	// end save in file =======================================
	
	
	
	
	
	if (iggoAlarm == 0) {
					
		NSLog(@"ALARM !!! %d:%d", hourS, minS);
		bStoped.hidden = NO;
		bContinue.hidden = YES;
		bSnooze.hidden = NO;
		bStop.hidden = YES;
		bStoped.tag = 5;
		bSnooze.tag = 3;
		
		
		
		// time sleep 20 minutes end invalidate stop melody
		if (timerMinSleepEnd) {
			[timerMinSleepEnd invalidate];
			timerMinSleepEnd = nil;
		}
		[self stopAllMelody];
		
		
		//==================================my code new
	
		iAlarmNfile = 5;
		//[self audioSoundGo];
		[self performSelector:@selector(audioSoundGo) withObject:nil afterDelay:0.8];

		//==================================my code new end
		
		if (myTimer2) {
			[myTimer2 invalidate];
			myTimer2 = nil;
		}
		
		
		//myTimeAlarm.hidden = NO;
		//bAlarmThird.hidden = NO;
		//volumeSlider. = NO;
		//self.view.hidden = NO;
		//self.tabBarController.tabBar.hidden = NO;
		
		//timeAlarmView.hidden = YES;
		//[self dismissModalViewControllerAnimated:NO];
	}	
		
	[df release];	
}


- (void) goClockView {
	
	switch (iCycle) {
		case 1:
			imgFullCycleView.image = [UIImage imageNamed:@"imgGoClockViewLightClock.png"];
			break;
		case 2:
			imgFullCycleView.image = [UIImage imageNamed:@"imgGoClockViewLightClockStat.png"];
			break;
		case 3:
			imgFullCycleView.image = [UIImage imageNamed:@"imgGoClockViewStatSun.png"];
			break;
		case 4:
			imgFullCycleView.image = [UIImage imageNamed:@"imgGoClockViewFull.png"];
			break; 
		default:
			break;
	}
	
	
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateStyle = NSDateFormatterMediumStyle;
	//NSString * text = [NSString stringWithFormat:@"%@", [df stringFromDate:myTimeAlarm.date]];
	
	/*
	[df setDateFormat:@"HH"];	
	int hourS = [[df stringFromDate:myTimeAlarm.date] intValue];
	
	[df setDateFormat:@"mm"];
	int minS = [[df stringFromDate:myTimeAlarm.date] intValue];	
	
	
	[df setDateFormat:@"HH"];	
	int hourD = [[df stringFromDate:[NSDate date]] intValue];	
	
	[df setDateFormat:@"mm"];
	int minD = [[df stringFromDate:[NSDate date]] intValue];	
	*/
	int hA = hourS;	
	if(hourS >= 12){ // convert to AM/PM
		if(hourS != 12){
			hA = hourS - 12;
		}
	}
	else{
		if(hourS == 0){
			hA = 12;
		}
	}
	NSString *hAs = [NSString stringWithFormat:@"%i", hA];
	NSString *minAs = [NSString stringWithFormat:@"%i", minS];
	
	if (hA <= 9) {
		hAs = [NSString stringWithFormat:@"0%i", hA];
	}
	if (minS <= 9) {
		minAs = [NSString stringWithFormat:@"0%i", minS];
	}
	
	
	lAlarm.text = [NSString stringWithFormat:@"%@:%@", hAs, minAs];
	NSString *sCharReplace = [lAlarm.text stringByReplacingOccurrencesOfString:@":" withString:@"d"];
	imgAlarmClockView.image = [self imageFromString:sCharReplace];
	
	NSLog(@"\n uraaaaa   heiii week \n");	
//	NSLog(@"\n picker hours: %d\n min: %d\n", hourS, minS);	
	
	[df release];
	
	
	// go clock
	myTimer2 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showAlarm) userInfo:nil repeats:YES];

	
	
	
	//timeAlarmView.frame = CGRectMake(0, -20, 320, 480);
	
//	tImgClock = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iGoClock.png"]];
//	tImgClock.frame = CGRectMake(29, 84, 266, 266);		
	//tImgCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"igCircle.png"]];
	//tImgCircle.frame = CGRectMake(140, 198, 41, 41);	
	
//	clockView = [[ClockViews alloc] initWithFrame:CGRectMake(0,29,320,427)];
	//[timeAlarmView addSubview:imgBack];
//	[timeAlarmView addSubview:tImgClock];
//    [timeAlarmView addSubview:clockView];
	
	//[timeAlarmView addSubview:tImgCircle];
	
	//[timeAlarmView addSubview:imgLightView];
	[timeAlarmView addSubview:bStop];
	[timeAlarmView addSubview:bMelody];
	[timeAlarmView addSubview:bStoped];
	[timeAlarmView addSubview:bContinue];
	[timeAlarmView addSubview:bSnooze];
	//[timeAlarmView addSubview:imgAlarmClockView];
	[timeAlarmView addSubview:imgFullCycleView];
	[timeAlarmView addSubview:lAlarm];
	
	imgBack.frame = CGRectMake(0, 0, 320, 480);
	
//	[tImgClock release];
	//[tImgCircle release];
	
//    [clockView start];
//    [clockView release];
//	
}


- (void) alertAlarm2 {
	NSLog(@"ALARM 2!!! %d:%d", hourS, minS);
	bStoped.hidden = NO;
	bContinue.hidden = YES;
	bSnooze.hidden = NO;
	bStop.hidden = YES;
	bStoped.tag = 5;
	bSnooze.tag = 3;
	

	[self stopAllMelody];
	
	iAlarmNfile = 5;
	[self performSelector:@selector(audioSoundGo) withObject:nil afterDelay:0.8];
	
}

- (void) stopAllMelody {
	[self.audioPlayerMusic pause];
	self.audioPlayerMusic.rate = 0;
	[self.soundPlayer stop];
	self.soundPlayer.currentTime = 0.0;

	musicMP.volume = fVolume;
}

- (IBAction) actStopAlarm: (id) sender {
	UIButton *bt = (UIButton *) sender;
	// [self touchesBegan:nil withEvent:nil]; // if need necesary
	
	switch (bt.tag) {
		case 0:
			bStoped.hidden = NO;
			bContinue.hidden = NO;
			bStop.hidden = YES;
			break;
		case 1:
			bStoped.hidden = YES;
			bContinue.hidden = YES;
			bStop.hidden = NO;
			break;
		case 2:
			// testGraph stop
			[hTest TestGraphCancel];
			[hTest didLoadAllDealoc];
			
			// save in test graph Up, => sava in arrayAllstatistics
			iiGoSaveinFile = 1;			
			[self showAlarm];
			[self stopAllMelody];
			
			
			if (myTimer2) {
				[myTimer2 invalidate];
			}
			if (timeSlowVolume) {
				[timeSlowVolume invalidate];
				timeSlowVolume = nil;
			}
			if (timerMinSleepEnd) {
				[timerMinSleepEnd invalidate];
				timerMinSleepEnd = nil;
			}
			if (timerAlertAlarm2) {
				[timerAlertAlarm2 invalidate];
				timerAlertAlarm2 = nil;
			}
			[self stopAllMelody];
			
			// block ecran YES
			[UIApplication sharedApplication].idleTimerDisabled = NO; // touch ins'nt to no display & programm off
			[UIDevice currentDevice].proximityMonitoringEnabled = NO; // display/screen off
			
			[self dismissModalViewControllerAnimated:YES];
			cycleAlarmDlg.tabBarBottomView.hidden = NO;
			break;
		// snooze before stop Alarm!!!	
		case 3: //bSnooze
			bStoped.hidden = YES;
			bContinue.hidden = YES;
			bStop.hidden = NO;
			bSnooze.hidden = YES;
			bStop.tag = 4;
			
			//stop music to go sleep
			[self stopAllMelody];
			
			
			
			//nsdateformat to covert lablyAlarm plus snooze minutes
			NSDateFormatter *df = [[NSDateFormatter alloc] init];
			df.dateStyle = NSDateFormatterMediumStyle;
			
			[df setDateFormat:@"HH"];	
			int hourD = [[df stringFromDate:[NSDate date]] intValue];	
			
			[df setDateFormat:@"mm"];
			int minD = [[df stringFromDate:[NSDate date]] intValue];
			
			if((minD+iSnoozeMin)>=60){
				minD = minD + iSnoozeMin - 60;
				hourD += 1;
			} else {
				minD = minD + iSnoozeMin;
			}

			
			int hA = hourD;	
			if(hourD >= 12){ // convert to AM/PM
				if(hourD != 12){
					hA = hourD - 12;
				}
			}
			else{
				if(hourD == 0){
					hA = 12;
				}
			}
			NSString *hAs = [NSString stringWithFormat:@"%i", hA];
			NSString *minAs = [NSString stringWithFormat:@"%i", minD];
			if (hA <= 9) {
				hAs = [NSString stringWithFormat:@"0%i", hA];
			}
			if (minD <= 9) {
				minAs = [NSString stringWithFormat:@"0%i", minD];
			}
			lAlarm.text = [NSString stringWithFormat:@"%@:%@", hAs, minAs];
			NSString *sCharReplace = [lAlarm.text stringByReplacingOccurrencesOfString:@":" withString:@"d"];
			imgAlarmClockView.image = [self imageFromString:sCharReplace];
			
			
	
			 // snooze 9 min timer go
			if (!timerAlertAlarm2) {
			timerAlertAlarm2 = [NSTimer scheduledTimerWithTimeInterval:(60.0*iSnoozeMin) target:self selector:@selector(alertAlarm2) userInfo:nil repeats:YES];
			}
			break;
		case 4: //bStop
			bStoped.hidden = NO;
			bContinue.hidden = NO;
			bStop.hidden = YES;
			bSnooze.hidden = YES;
			bStoped.tag = 5;
			break;
		case 5: //bstoped all to exit alarm
			bStoped.hidden = YES;
			bContinue.hidden = YES;
			bSnooze.hidden = YES;
			bStop.hidden = NO;
			
			if (timeSlowVolume) {
				[timeSlowVolume invalidate];
				timeSlowVolume = nil;
			}
			if (timerMinSleepEnd) {
				[timerMinSleepEnd invalidate];
				timerMinSleepEnd = nil;
			}
			if (timerAlertAlarm2) {
				[timerAlertAlarm2 invalidate];
				timerAlertAlarm2 = nil;
			}
			[self stopAllMelody];
			
			// block ecran YES
			[UIApplication sharedApplication].idleTimerDisabled = NO; // touch ins'nt to no display & programm off
			[UIDevice currentDevice].proximityMonitoringEnabled = NO; // display/screen off
			
			[self dismissModalViewControllerAnimated:YES];
			cycleAlarmDlg.tabBarBottomView.hidden = NO;
			break;
		default:
			break;
	}
}

- (void) startPlayAlarm {
	
	NSString *nSound = [NSString stringWithFormat:@"%@", sSoundSleep];
	//======================= start play
	NSLog(@"\n music: %@\n", nSound);
	NSString *soundFolder = @"Sound";
	if (iAlarmNfile == 5) {
		soundFolder = @"SoundSleep";
	}
	if (iAlarmNfile == 4) {
		soundFolder = @"Sound";
	}
	
	NSString *path = [[NSBundle mainBundle] resourcePath]; 
	path = [path stringByAppendingPathComponent:soundFolder];
	path = [path stringByAppendingPathComponent:nSound];
	path = [NSString stringWithFormat:@"%@", path];
	///var/mobile/Applications/6958B5BB-3B29-4D6E-8ACD-36AB3E6D5A09/CycleAlarm.app/SoundSleep/BE BOP JAZZY.mp3
	//NSString *path = [[NSBundle mainBundle] pathForResource:@"face1" ofType:@"mp3"];
	self.soundPlayer = nil;
	
	NSLog(@"iAlarmNfile: %i, sdsdpath = %@, %@", iAlarmNfile, path, nSound);
	NSURL *file = [[NSURL alloc] initFileURLWithPath:path];	
	AVAudioPlayer *p = [[AVAudioPlayer alloc] initWithContentsOfURL:file error:nil];
	[file release];	
	self.soundPlayer = p;
	[p release];
	
	[soundPlayer prepareToPlay];
	[soundPlayer setDelegate:self];
	//[self.player setVolume:10.0];
	//======================= end play
}

- (void) startAvPlayAlarm {
	NSLog(@"Avplayer play clock music: %@, \n", lSmp3);
	NSURL *tUrl = [NSURL URLWithString:lSmp3];
	self.audioPlayerMusic = nil;
	self.audioPlayerMusic = [AVPlayer playerWithURL:tUrl]; 
}

- (void) tSlowVolume: (float) sender {
	//NSLog(@"sender: %f, sHist: %f\n", sender, senderHistVolume);
	if (sender > 0.00001) {
		senderHistVolume = sender;
	} 
	
	if (!timeSlowVolume) {
		fSlowVolume = 0.00;
		timeSlowVolume = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(tSlowVolume:) userInfo:nil repeats:YES];
	}
	fSlowVolume += 0.01;
	musicMP.volume = fSlowVolume;
	//NSLog(@"DownSender: %f, sHist: %f\n", sender, senderHistVolume);
	if (fSlowVolume >= senderHistVolume) {
		[timeSlowVolume invalidate];
		timeSlowVolume = nil;
		NSLog(@"at 0.0 Volume to %f is stoped in %i sec, sendHistory sec: %f\n", fSlowVolume, (int)(fSlowVolume*200), senderHistVolume);
	}
}

- (void) audioSoundGo {
	
	NSArray *pathArrayS = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSArray *valuesS = [[NSArray alloc] initWithContentsOfFile:[[pathArrayS objectAtIndex:0] stringByAppendingPathComponent:@"saveSens.plist"]];
	NSString *nsKsens1S = [NSString stringWithFormat:@"%@",[valuesS objectAtIndex:0]];
	NSString *nsKsens2S = [NSString stringWithFormat:@"%@",[valuesS objectAtIndex:1]];
	NSLog(@"\nsens===== : %@, %@\n", nsKsens1S, nsKsens2S);
	//[[NSUserDefaults standardUserDefaults] setFloat:2.23 forKey:@"alarmVolume"];
	//[[NSUserDefaults standardUserDefaults] floatForKey:@"alarmVolume"];
	
	if (iAlarmNfile == 4) {
		printf("iAlarmNfile = 4, musicMP.volume: %.0f\n", [nsKsens2S floatValue]);
		musicMP.volume = [nsKsens2S floatValue];
	}
	if (iAlarmNfile == 5) {
		printf("iAlarmNfile = 5, musicMP.volume: %.0f\n", [nsKsens1S floatValue]);
		if (timeSlowVolume) {
			[timeSlowVolume invalidate];
			timeSlowVolume = nil;
		}
		[self tSlowVolume: [nsKsens1S floatValue]];
	}
	NSString *myPath3 = [self saveFilePath:iAlarmNfile];
	NSArray *values3 = [[NSArray alloc] initWithContentsOfFile:myPath3];
	NSArray *sIndex = [values3 objectAtIndex:1];
	NSString *strSoundSelected = [NSString stringWithFormat:@"%@",[sIndex objectAtIndex:0]];
	NSString *strSelected = [NSString stringWithFormat:@"%@",[sIndex objectAtIndex:1]];
	
	NSArray *sIndex2 = [values3 objectAtIndex:2];
	lSmp3 = [NSString stringWithFormat:@"%@",[sIndex2 objectAtIndex:0]];
	
	NSArray *sIndex3 = [values3 objectAtIndex:0];
	sSoundSleep = [[NSString stringWithFormat:@"%@",[sIndex3 objectAtIndex:[strSoundSelected intValue]-1]] retain];
		
	if (/*[lSoundPlay.text isEqualToString:@"stoped"]*/ 1 == 1) {
		if ([strSelected intValue] == 1) {
			[self startPlayAlarm];
			[self.soundPlayer play];
			printf("strSelected = 1, startPlayAlarm = play\n");
		}
		if ([strSelected intValue] == 2) {
			[self startAvPlayAlarm];
			[self.audioPlayerMusic play];
			printf("strSelected = 2, startPlayAlarm = play\n");
		}
		//lSoundPlay.text = @"play";	
		//NSLog(@"\n sound play clock: %@, \n", lSoundPlay.text);
	}
	[values3  release];
}

- (IBAction) actStopMelody: (id) sender {
	UIButton *bt = (UIButton *) sender;
	NSLog(@"actStopMelody bt.tag: %i,", bt.tag);
	switch (bt.tag) {
		case 0:
			[bMelody setImage:[UIImage imageNamed:@"bGoClockMelodyEnabled.png"] forState:UIControlStateNormal];
			iAlarmNfile = 4;
			[self audioSoundGo];
			bMelody.tag = 1;
			break;
		case 1:
			[bMelody setImage:[UIImage imageNamed:@"bGoClockMelodyDisabled.png"] forState:UIControlStateNormal];
			[self.audioPlayerMusic pause];
			//self.audioPlayerMusic.rate = 0;
			[self.soundPlayer stop];
			//self.soundPlayer.currentTime = 0.0;
			bMelody.tag = 0;
			break;
		default:
			break;
	}

}

- (void) blackViewApear {
	if (blackView != nil && blackView.alpha == 0.0) {
		[blackView removeFromSuperview];
		blackView = nil;
	}
//	if (blackView == nil) {
//	blackView = [[UIImageView alloc] initWithFrame:CGRectMake(-29, -84, 320, 480)];
//		blackView.image = [UIImage imageNamed:@"GoClockBlackView.png.png"];
//		blackView.alpha = 0.0;
//	[tImgClock addSubview:blackView];
//		//begin animations
//		[UIImageView beginAnimations:nil context:NULL];
//		[UIImageView setAnimationDuration:5.5];
//		//[UIImageView setAnimationBeginsFromCurrentState:YES];
//		[UIImageView setAnimationCurve:UIViewAnimationCurveEaseOut];
//		[UIImageView setAnimationRepeatAutoreverses:0];
//		[UIImageView setAnimationRepeatCount:1];
//		blackView.alpha=1.0;
//		[UIImageView commitAnimations];
//		//end animations
//	[blackView release];
//	}
	
	if (bSnooze.hidden == YES) {
	// dor button contiue && stoped
	bStoped.hidden = YES;
	bContinue.hidden = YES;
	bStop.hidden = NO;
	} else {
		
	}

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if (blackView != nil && blackView.alpha == 1) {
		NSLog(@"touch");
		blackView.alpha=1.0;
		//begin animations
		[UIImageView beginAnimations:nil context:NULL];
		[UIImageView setAnimationDuration:5.5];
		//[UIImageView setAnimationBeginsFromCurrentState:YES];
		[UIImageView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[UIImageView setAnimationRepeatAutoreverses:0];
		[UIImageView setAnimationRepeatCount:1];
		blackView.alpha=0.0;
		[UIImageView commitAnimations];
		//end animations
		
	}
	if (timerBlack) {
		[timerBlack invalidate];
	}
	timerBlack = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(blackViewApear) userInfo:nil repeats:YES];
}

- (void) replayAudioMp3 {
	NSLog(@"Avplayer replay \n");
	[self audioSoundGo];
	//[self startAvPlayAlarm];
	//[self.audioPlayerMusic play];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	senderHistVolume = 0;
	iiGoSaveinFile = 0; // save or not in file all statistics
	
	
	//record audio =======
	int iBoolNorRecord = 0;
	NSString *s = [self IphoneModel];
	
	if ([s isEqualToString:@"iPhone 1G"] || [s isEqualToString:@"iPod Touch 2G"] || [s isEqualToString:@"iPod Touch 3G"]  || [s isEqualToString:@"Simulator5"])
	{
		NSLog(@" no record no microphone model didLoad\n");
		iBoolNorRecord = 1; // no record, because not exist mic
		
	} 
	
	
	if ((i4View == 4 || i4View == 3) && iBoolNorRecord == 0) { // if 14view is noise or not
		recorderFileHLoad = [[RecorderLoad alloc] init];
		[recorderFileHLoad ObjectLoad];
	}
	//end record audio ===
	
	
	
	// time start =================================================
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateStyle = NSDateFormatterMediumStyle;
	
	[df setDateFormat:@"LLLL dd, yyyy"];	
	stringDateStart = [[df stringFromDate:[NSDate date]] retain];
	[df setDateFormat:@"HH:mm"];
	stringHmStart = [[df stringFromDate:[NSDate date]] retain];
	NSLog(@"Time %@, %@\n", stringDateStart, stringHmStart);
	
	// interval between datestart and date curent	
	t1970start = [[NSDate date] timeIntervalSince1970];
	
	[df release];
	// time start =================================================
	
	NSLog(@"i4view: %i, \n", i4View);
	//minutes snoozes
	iSnoozeMin = 9;
	
	// block ecran no
	[UIApplication sharedApplication].idleTimerDisabled = YES; // touch ins'nt to no display & programm off
	[UIDevice currentDevice].proximityMonitoringEnabled = YES; // display/screen off
	
	if (1 == 1) {
		NSLog(@"go TestGraph controller\n");
		//TestGraph *h=[[TestGraph alloc] initWithNibName:@"TestGraph" bundle:[NSBundle mainBundle]];
		hTest=[[TestGraph alloc] init];
		[hTest objectDidLoad];		
		
		// no view viewvid
		//h.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
		//[self presentModalViewController:h animated:YES];
		//h.view.hidden = YES;
		[hTest actTest:1];
		//[h release];
	}	
		
	timerBlack = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(blackViewApear) userInfo:nil repeats:YES];
	
	musicMP = [MPMusicPlayerController iPodMusicPlayer];
	fVolume = musicMP.volume;
	bMelody.tag = 1;
	lSoundPlay.text = @"stoped";
	bStoped.hidden = YES;
	bStoped.hidden = YES;
	[self goClockView];
	
	NSString *myPath3 = [self saveFilePath:6];
	NSArray *values3 = [[NSArray alloc] initWithContentsOfFile:myPath3];
	NSString *sMinutes = [NSString stringWithFormat:@"%@",[values3 objectAtIndex:0]];
	if ([sMinutes intValue] != 0) {
		timerMinSleepEnd = [NSTimer scheduledTimerWithTimeInterval:([sMinutes intValue]*60.0) target:self selector:@selector(timeMinEnd) userInfo:nil repeats:NO];
		iAlarmNfile = 4;
		[self audioSoundGo];
	}
	[values3 release];
	
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(replayAudioMp3) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
	
	
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
    [currentTime release];
    currentTime = nil;
    [super viewDidUnload];
	[UIApplication sharedApplication].idleTimerDisabled = NO;
	[UIDevice currentDevice].proximityMonitoringEnabled = NO;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [currentTime release];
    [super dealloc];
}


@end
