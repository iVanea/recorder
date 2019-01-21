    //
//  TestGraph.m
//  CycleAlarm
//
//  Created by Symon on 4/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestGraph.h"


@implementation TestGraph
@synthesize TestGraphView;

- (NSString *) saveFilePath: (int) poster
{
	NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	if (poster == 1) {
		return [[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"saveSensCalibr.plist"];
	}
	return 0;
}


- (void) timeSec {
	iTimeSec += 1;
}



- (void) actTest: (int) sender {
		
		lblSaveX = xAx;
		lblSaveY = yAx;
		lblSaveZ = zAx;
		
		if (!timeNSg) {
			timeNSg = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(fTime) userInfo:nil repeats:YES];
		}
		if (!timeNSMaxg) { //sensibility duration after
			timeNSMaxg = [NSTimer scheduledTimerWithTimeInterval:0.9 target:self selector:@selector(fTimeMax) userInfo:nil repeats:YES];
		}
		
		
}


- (float) boolReturnStage {
	return fSendStage;
	return 0;
}

- (int) boolReturnDeepCycle {
	return iDeepCycle;
	return 0;
}
- (int) boolReturnLightCycle {
	return iLightCycle;
	return 0;
}

- (void) termineTimeStagesNull {
	fSendStage = 0; // null stages every 5 seconds, if stages isEqual 1 (REM)	
	if (myTimerStageNull) {
		[myTimerStageNull invalidate];
		myTimerStageNull = nil;
	}
}

- (void) funcDetermineCyclesAlarmGo: (NSArray *) arrSender {
	NSArray *values3 = [[NSArray alloc] initWithArray:(NSArray *) arrSender];
	
	//NSLog(@"\n\n MASIV stat Test send:\n %@\n\n", values3);
	NSString *sTime1970minus = @"0";
	//NSString *sTime1970minusOld = @"0";
	int itMin = 0;
	int itMinOld = 0;
	float itCycleMin = 0;
	float fiNarry = 0;
	
	NSMutableArray *arrMutMinimum = [[NSMutableArray alloc] init];
	
	for (int i = 0; i < [values3 count]; i++) {
		NSArray *tarray;
		tarray = [values3 objectAtIndex:i];

		
		//NSString *sVibr = [NSString stringWithFormat:@"%@", [tarray objectAtIndex:3]];
		sTime1970minus = [NSString stringWithFormat:@"%@", [tarray objectAtIndex:5]];
		//float iVibr = ([sVibr floatValue]*3)/5;
		itMin = [[NSString stringWithFormat:@"%@", [tarray objectAtIndex:5]] intValue];

		int iMinMinOld = (itMin - itMinOld);
		
		if (iMinMinOld <= 60) {
			if (itCycleMin == 1.01) {
				itCycleMin = 0;
			}
			itCycleMin += 1;
			
			if (itCycleMin >= 5) {
				itCycleMin = 5;
			}
			
			
		} else {
			float fiMin = (float) (iMinMinOld) / 60;
			float ftadd = (itCycleMin*3)/5;
			NSLog(@"min:  %0.2f, %0.2f, %i,\n", fiMin, ftadd, iMinMinOld);
			
			
			NSArray *tAarr = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%0.2f", fiMin], [NSString stringWithFormat:@"%0.2f", ftadd], [NSString stringWithFormat:@"%i", iMinMinOld], nil];
			[arrMutMinimum addObject: tAarr];
			
			[tAarr release];
			tAarr = nil;
			

			itCycleMin = 1.01;	
		}
		
		
		
		itMinOld = itMin;
		
	}// for end
	
	
	//new cycle
	//[xGR addX:3 y:-1 z:-1]; // one the 1 stage point start
	float ffMin = 0;
	float ffdAd = 0;
	float ffMinSec = 0;
	
	float fPlus = 0;
	float fbreak = 0;
	float fStage = 3;
	float fStagei = 0;
	
	for (int i = 0; i < [arrMutMinimum count]; i++) {
		NSArray *tAr = [arrMutMinimum objectAtIndex:i];
		ffMin = [[tAr objectAtIndex:0] floatValue];
		ffdAd = [[tAr objectAtIndex:1] floatValue];
		ffMinSec = [[tAr objectAtIndex:2] floatValue];
		ffMinSec = ffMinSec / 60;
		
		NSLog(@"ffMinSec: %f\n", ffMinSec);
		tAr = nil;
		
		float tf = 0;
		if (ffMinSec>=7 && ffMinSec<=90 && tf!=1 && (fStage == 1 || fStage == 3)) {
			fbreak = 1;
			tf = 1;
		}
		
		if (ffMinSec>=1 && ffMinSec<=20 && tf!=1 && (fStage == 3 || fStage == 2)) {
			fbreak = 0;
			tf = 1;
		} 
		
		if (ffMinSec>=20 && ffMinSec<=180 && tf!=1 && (fStage == 2 || fStage == 1)) {
			fbreak = 2;
			tf = 1;
		}
		
		
		
		
		if (fbreak==0 && (fStage == 3 || fStage == 2)) {
			NSLog(@"the 1 stage\n");
			fStage = 1;
			fStagei = 4-fStage;
			for (int i = 0; i < ffMinSec; i++) {
				//[xGR addX:fStagei y:-1 z:-1];
			}
		}
		
		if (fbreak==1 && (fStage == 1 || fStage == 3)) {
			NSLog(@"the 2 stage\n");
			iLightCycle += 1;
			if (ffMinSec>15) { iDeepCycle += 1; } // plus deepCycle interior 2 stage
			fStage = 2;
			fStagei = 4-fStage;
			for (int i = 0; i < ffMinSec; i++) {
				if (ffMinSec>15) { // (stage 2) / stage 1 && stage 1 ===== 30 min interval max => 2stage 1 && 2
					if (i >= (ffMinSec / 3.5) && i <= (ffMinSec - (ffMinSec / 3.5))) {
						//[xGR addX:3 y:-1 z:-1];
					} else {
						//[xGR addX:fStagei y:-1 z:-1];
					}
				} else {
					//[xGR addX:fStagei y:-1 z:-1];
				}
				
				
				
			}
			
		}
		
		if (fbreak==2 && (fStage == 2 || fStage == 1)) {
			NSLog(@"the 3 stage\n");
			iDeepCycle += 1;
			fStage = 3;
			fStagei = 4-fStage;
			for (int i = 0; i < ffMinSec; i++) {
				//[xGR addX:fStagei y:-1 z:-1];
			}
		}
		
		
		
		
		fiNarry += 1;
		fPlus += ffMinSec;
	}
	
	NSLog(@"Stage = %f, fSendStage: %f \n", fStage, fSendStage);
	
	
	if (fStage == 1) {
		if (myTimerStageNull) {
			[myTimerStageNull invalidate];
			myTimerStageNull = nil;
		}
		myTimerStageNull = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(termineTimeStagesNull) userInfo:nil repeats:NO];
	}
	fSendStage = fStage;
	
	[values3 release];
	[arrMutMinimum release];
	arrMutMinimum = nil;
	values3 = nil;
}





- (void) fTimeMax {
	
	if (tPlusMax == ttplus) {
		tPlusMax = 0;
		if (tPlusMax == 0) {
			//musicMP.volume = 0.3;
		}
		lSensibilityTestView = tPlusMax;
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
		
		// tSensAcc is in didloadObject from file sesn.plist...
		//float tSensAcc = 0.02;
		
		if (sqrt(pow((lblSaveX-xAx), 2)) > tSensAcc) {
			tii = 1;
		}
		if (sqrt(pow((lblSaveY-yAx), 2)) > tSensAcc) {
			tii = 1;
		}
		if (sqrt(pow((lblSaveZ-zAx), 2)) > tSensAcc) {
			tii = 1;
		}
		
		
		if (tii == 1) {
			NSLog(@"\n Alert Alarm X\n");
			
			NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
			
			//NSLog(@"70:%f,\n", (time - f70));
			
			tPlusMax += 1;
			/*
			array[1];
			vibration array +1 count +1 array[2];
			if count array 10 write array in file
			*/	
			
						
			nsNvibr = @"0";
							
			lSensibilityTestView2 = tIntAlertYes;
			
			if (lSensibilityTestView > 0) {
				switch ((int)lSensibilityTestView) {
					case 1:
						nsNvibr = @"1";
						break;
					case 2:
						nsNvibr = @"2";
						break;
					case 3:
						nsNvibr = @"3";
						break;
					case 4:
						nsNvibr = @"4";
						break;
					case 5:
						 nsNvibr = @"5";
						break;
					default:
						break;
				}
				if (lSensibilityTestView > 5) {
					nsNvibr = @"5";
				}
			}
			
			
			NSDateFormatter *df = [[NSDateFormatter alloc] init];
			df.dateStyle = NSDateFormatterMediumStyle;
			
			[df setDateFormat:@"HH"];	
			int hourD = [[df stringFromDate:[NSDate date]] intValue];	
			
			[df setDateFormat:@"mm"];
			int minD = [[df stringFromDate:[NSDate date]] intValue];
			
			[df setDateFormat:@"ss"];
			int secD = [[df stringFromDate:[NSDate date]] intValue];
			
			[df setDateFormat:@"HH:mm:ss"];
			NSString *nsTime = [df stringFromDate:[NSDate date]];
			
			NSString *nsH = [NSString stringWithFormat:@"%i", hourD];
			NSString *nsM = [NSString stringWithFormat:@"%i", minD];
			NSString *nsS = [NSString stringWithFormat:@"%i", secD];
			
			//int iGosaveInArray = 0;
			//NSTimeInterval tNsTime1970minusOld = nsTime1970minus;
			
			//nsTime1970minus = [NSString stringWithFormat:@"%d", [[NSDate date] timeIntervalSince1970]];
			nsTimeSec = [NSString stringWithFormat:@"%i", iTimeSec];
						
			
			/*
			 // read the option data from the plist
			 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			 NSString *documentsDirectory = [paths objectAtIndex:0];
			 NSString *thePath = [documentsDirectory stringByAppendingPathComponent:@"GunzillaOption.plist"];
			 
			 NSMutableDictionary *optionList=[NSMutableDictionary dictionaryWithContentsOfFile:thePath];
			 opt_gravity = [[optionList valueForKey:@"Opt_gravity"] retain];
			 opt_aksel_camera = [[optionList valueForKey:@"Opt_aksel_camera"] retain];
			 opt_front_camera = [[optionList valueForKey:@"Opt_front_camera"] retain];
			 */
			
			
			
			
			if (iTenArray>=50) {
				NSLog(@"aarayPLus %i > 10", iTenArray);
				NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
				[arrayTable writeToFile:[[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"saveArrayStat.plist"] atomically:YES];
				[arrayTable release];
				arrayTable = nil;
				iTenArray = 0;
			}
			iTenArray += 1;
			
			arrayPlus = [[NSArray alloc] initWithObjects: nsH, nsM, nsS, nsNvibr, nsTime, nsTimeSec, nil];
						
			/*for (int i = 0; i < iCount; i++) {
			 NSArray *arr = [values3 objectAtIndex:0]];
			 
			 }*/
			if (arrayTable) {
				    NSArray *tArrays = [arrayTable objectAtIndex:([arrayTable count]-1)];
				//NSLog(@"dssss %i\n", [[tArrays objectAtIndex:3] intValue]);	
				
					if (([nsTimeSec intValue] - [[tArrays objectAtIndex:5] intValue])<5) {
						if ([[tArrays objectAtIndex:3] intValue]<[nsNvibr intValue]) {
							[arrayTable removeObjectAtIndex:([arrayTable count]-1)];
							[arrayTable addObject:arrayPlus];
							NSLog(@"remove last object\n");
						}
					} else {
						[arrayTable addObject:arrayPlus];
						NSLog(@"add object\n");
					}
				
				//if ((nsTime1970minus - tNsTime1970minusOld)<5) {}
				
			} else {
				NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
				NSArray *values3 = [[NSArray alloc] initWithContentsOfFile:[[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"saveArrayStat.plist"]];
				arrayTable = [[NSMutableArray alloc] initWithArray:values3];
				[arrayTable addObject:arrayPlus];
			
				
			
				
			
			/*for (int i=0; i<([values3 count]); i++) {
				if ([values3 objectAtIndex:i]) {
					NSLog(@"arr = old:%@ \n", [NSString stringWithFormat:@"%@", [values3 objectAtIndex:i]]);
					[arrayTable addObject:[values3 objectAtIndex:i]];
				}
				
				if (([values3 count]) == i) {
					NSLog(@"arrayPlus");
					[arrayTable addObject:arrayPlus];
				}
			}*/
				
			[values3 release];
			} // else
			
			// self fucntion save stage cycle
			if (arrayTable) {
				[self funcDetermineCyclesAlarmGo:arrayTable];
			}
			
			
			[arrayHistPlus release];
			arrayHistPlus = [[NSArray alloc] initWithArray:arrayPlus];
			
			[df release];
			[arrayPlus release];
		
			
			
			
			
			//sensibility duration after
			if ((time - f70)<0.9) {
				lSensibilityTestView = tPlusMax;
				musicMP = [MPMusicPlayerController iPodMusicPlayer];
				
				if (tPlusMax == 1) {
					//musicMP.volume = 0.3;
				}
				else {
					if (((lSensibilityTestView/10)+0.3)<=1.0) {
						//musicMP.volume = ([lSensibilityTestView.text floatValue]/10)+0.3;
					}
					else {
						//musicMP.volume = 1.0;
					}
					
					//[self.Player setVolume:8.0];
					//NSLog(@"volume:%f\n", ([lSensibilityTestView.text floatValue]/10));
				}
				
			}
			else {
				lSensibilityTestView = tPlusMax;
				tPlusMax = 0;
				//[self.Player setVolume:0.0];
			}
			
			f70  = time;
			
			
			lblSaveX = xAx;
			lblSaveY = yAx;
			lblSaveZ = zAx;
			
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
	
	xax = xAx;
	yax = yAx;
	zax = zAx;
	
	float xSave = lblSaveX;
	float ySave = lblSaveY;
	float zSave = lblSaveZ;
	
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
	
	if (lblSaveX == 10101010) {}  else
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


// Object load NSObject
- (void)objectDidLoad {
	NSLog(@"ViewDidLoad TestGraph");
	
	arrayHistPlus = [[NSArray alloc] init];
	
	iLightCycle = 0;
	iDeepCycle = 0;
	
//	NSArray *tArr = NULL;
	NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSArray *values3 = [[NSArray alloc] initWithContentsOfFile:[[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"saveArrayStat.plist"]];
	NSMutableArray *arrTable = [[NSMutableArray alloc] initWithArray:values3];
	[arrTable removeAllObjects];	
	[arrTable writeToFile:[[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"saveArrayStat.plist"] atomically:YES];
	
	iTimeSec = 0;	
	myTimerSecg = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeSec) userInfo:nil repeats:YES];
	
	nsTimeFirst = [[NSDate date] timeIntervalSince1970];
	//startAlarmPlay
	//[self startPlayAlarm];
	
	//accelerometer
	accel = [UIAccelerometer sharedAccelerometer];
	accel.delegate = self;
	accel.updateInterval = 1.0f/24.0f;
	
	lblSaveX = 10101010;
	
	//self.view = TestGraphView;
	
	// goo accelerometer
	[self actTest:1];
	
	//NSDate
	NSDateFormatter *dateformater = [[NSDateFormatter alloc]init];
	[dateformater setDateFormat:@"YYYY"];
	//int yearS = [[dateformater stringFromDate:[NSDate date]] intValue];
	[dateformater release];
	
	
	//slider Sensitivity Calibration accelerometer
	NSString *myPath35 = [self saveFilePath:1];
	NSArray *values35 = [[NSArray alloc] initWithContentsOfFile:myPath35];
	NSString *stringSens5 = [NSString stringWithFormat:@"%@",[values35 objectAtIndex:0]];
	tSensAcc = 0.10 - [stringSens5 floatValue];
	
	[values35 release];
	values35 = nil;
	
}

			
- (void) TestGraphCancel {
	
	NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	if (arrayHistPlus) {
		[arrayTable addObject:arrayHistPlus];
	}
	
	if (arrayTable) {
		//determine cycle for return to GoClockALARM TO SAVE in file arrayAll
		[self determineCycles];
	}	else {
		iDeepCycle = 0;
		iLightCycle = 0;
	}

	[arrayTable writeToFile:[[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"saveArrayStat.plist"] atomically:YES];
	

	
	lSensibilityTestView = 0;
	tIntAlertYes = 0;
	
	if (timeNSg) {
		[timeNSg invalidate];
		timeNSg = nil;
	}
	if (timeNSMaxg) {
		[timeNSMaxg invalidate];
		timeNSMaxg = nil;
	}
}			
			
						
			
			

// didOnLoad All alloc nil remove invalidate...
- (void)didLoadAllDealoc {
	if (myTimerSecg) {
		[myTimerSecg invalidate];
	}
	if (arrayTable) {
		[arrayTable release];
		arrayTable = nil;
	}		
		
	
	if (arrayTable) {
		[arrayTable release];
	}
	
	if (arrayHistPlus) {
		[arrayHistPlus release];
		arrayHistPlus = nil;
	}
}



- (void)dealloc {
    [super dealloc];
	
}











//////...




























- (void) determineCycles {
	NSLog(@" =====determineCycles======, array: %@ \n", arrayTable);

	
	// statiscs graph for statisss vibration ===================================================
	//NSLog(@"\n\n MASIV stat:\n %@\n\n", values3);
	NSString *sTime1970minus = @"0";
	//NSString *sTime1970minusOld = @"0";
	int itMin = 0;
	int itMinOld = 0;
	float itCycleMin = 0;
	float fiNarry = 0;
	
	float fAllMin = 0;
	iChangeLevelStat = 2; // level 2 for every minutes vibration time long is level 2 || 3
	
	
	
	
	
	NSMutableArray *arrMutMinimum = [[NSMutableArray alloc] init];
	arrMutGraphVibration = [[NSMutableArray alloc] init];
	
	for (int i = 0; i < [arrayTable count]; i++) {
		NSArray *tarray = [arrayTable objectAtIndex:i];
		//NSString *sVibr = [NSString stringWithFormat:@"%@", [tarray objectAtIndex:3]];
		sTime1970minus = [NSString stringWithFormat:@"%@", [tarray objectAtIndex:5]];
		//float iVibr = ([sVibr floatValue]*3)/5;
		itMin = [[NSString stringWithFormat:@"%@", [tarray objectAtIndex:5]] intValue];
		
		int iMinMinOld = (itMin - itMinOld);
		
		if (iMinMinOld <= 60) {
			if (itCycleMin == 1.01) {
				itCycleMin = 0;
			}
			itCycleMin += 1;
			
			if (itCycleMin >= 5) {
				itCycleMin = 5;
			}
			//[xGR addX:2 y:-20 z:-20]; // real add
			//[arrMutGraphVibration addObject:[NSString stringWithFormat:@"%i", 3]];
			
		} else {
			float fiMin = (float) (iMinMinOld) / 60;
			float ftadd = (itCycleMin*3)/5;
			NSLog(@"min:  %0.2f, %0.2f, %i,\n", fiMin, ftadd, iMinMinOld);
			if (fiMin >= 15) {
				iChangeLevelStat = 3;
			} 
			
			if (fiMin >= 15) {
				iCount15Min += 1;
			} 
			
			fAllMin += fiMin;
			
			NSArray *tAarr = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%0.2f", fiMin], [NSString stringWithFormat:@"%0.2f", ftadd], [NSString stringWithFormat:@"%i", iMinMinOld], nil];
			[arrMutMinimum addObject: tAarr];
			
			[tAarr release];
			tAarr = nil;
			
			//vibration cycle
			/*
			 if (fiMin < 1) {
			 fiMin = 1;
			 }
			 for (int i = 0; i < fiMin; i++) {
			 [xGR addX:0.0 y:-1 z:-1];
			 //NSLog(@"%f\n", 0.2);
			 }
			 for (int i = 0; i < 3; i++) {
			 [xGR addX:ftadd y:-1 z:-1];
			 //NSLog(@"%f\n", iVibr);
			 }*/
			itCycleMin = 1.01;	
		}
		
		
		
		itMinOld = itMin;
		
	}// for end
	
	
	
	int iBoolFlash15Min = 0;
	/*
	 if ((iMinAllsleepDetected / 30.0) > (iCount15Min)) {
	 iBoolFlash15Min = 15;
	 } else {
	 iBoolFlash15Min = 15;
	 }*/
	
	iBoolFlash15Min = 15;
	//NSLog(@"fAllmin: %f ==== iMinAllsleep: %i, iMinAllcycle: %f, iCount15Min: %i\n", fAllMin, iMinAllsleepDetected, (iMinAllsleepDetected / 30.0), iCount15Min );
	
	//new cycle
	//[xGR addX:3 y:-20 z:-20]; // one the 1 stage point start // real add
	[arrMutGraphVibration addObject:[NSString stringWithFormat:@"%i", 3]];
	float ffMin = 0;
	float ffdAd = 0;
	float ffMinSec = 0;
	
	float fPlus = 0;
	float fbreak = 0;
	float fStage = 3;
	float fStagei = 0;
	
	float fIfElse = 0;
	
	for (int i = 0; i < [arrMutMinimum count]; i++) {
		NSArray *tAr = [arrMutMinimum objectAtIndex:i];
		ffMin = [[tAr objectAtIndex:0] floatValue];
		ffdAd = [[tAr objectAtIndex:1] floatValue];
		ffMinSec = [[tAr objectAtIndex:2] floatValue];
		ffMinSec = ffMinSec / 60;
		
		NSLog(@"ffMinSec: %f\n", ffMinSec);
		tAr = nil;
		
		float tf = 0;
		if (ffMinSec>=7 && ffMinSec<=90 && tf!=1 && (fStage == 1 || fStage == 3)) { // <=90 or 50, but 90 very good
			fbreak = 1;
			tf = 1;
			fIfElse = 1;
		}
		
		if (ffMinSec>=1 && ffMinSec<=20 && tf!=1 && (fStage == 3 || fStage == 2)) {
			fbreak = 0;
			tf = 1;
			fIfElse = 1;
		} 
		
		if (ffMinSec>=30 && ffMinSec<=180 && tf!=1 && (fStage == 2 || fStage == 1)) {
			fbreak = 2;
			tf = 1;
			fIfElse = 1;
		}
		
		
		// if verey 1 min is vibration => line stage 3 in fminsec
		if (fIfElse == 0) {
			
			for (int i = 0; i < ffMinSec; i++) {
				
				/*
				 if (ffMinSec>10) { // (stage 2) / stage 1 && stage 1 ===== 30 min interval max => 2stage 1 && 2
				 if (i >= (ffMinSec / 3.5) && i <= (ffMinSec - (ffMinSec / 3.5))) {
				 //[xGR addX:1 y:-20 z:-20]; // real add
				 [arrMutGraphVibration addObject:[NSString stringWithFormat:@"%i", 2]];
				 } else {
				 //[xGR addX:fStagei y:-20 z:-20]; // real add
				 [arrMutGraphVibration addObject:[NSString stringWithFormat:@"%f", 3]];						
				 }
				 
				 }
				 */
				
				//[xGR addX:3 y:-20 z:-20]; // real add
				[arrMutGraphVibration addObject:[NSString stringWithFormat:@"%i", iChangeLevelStat]]; ////////////////////////////////// change value to graphic optimal watch (2 || 3)
				
			}
			
		}
		fIfElse = 0;
		
		
		
		if (fbreak==0 && (fStage == 3 || fStage == 2)) {
			NSLog(@"the 1 stage\n");
			fStage = 1;
			fStagei = 4-fStage;
			for (int i = 0; i < ffMinSec; i++) {
				if (i >= (ffMinSec / 3.5) && i <= (ffMinSec - (ffMinSec / 3.5))) {
					//[xGR addX:3 y:-20 z:-20]; //real add
					[arrMutGraphVibration addObject:[NSString stringWithFormat:@"%f", fStagei]];
				} else {
					//[xGR addX:fStagei y:-20 z:-20]; // real add
					[arrMutGraphVibration addObject:[NSString stringWithFormat:@"%f", fStagei]];
				}
				
			}
		}
		
		if (fbreak==1 && (fStage == 1 || fStage == 3)) {
			NSLog(@"the 2 stage\n");
			fStage = 2;
			fStagei = 4-fStage;
			int iIfinter = 0;
			
			for (int i = 0; i < ffMinSec; i++) {
				if (ffMinSec>iBoolFlash15Min) { // (stage 2) / stage 1 && stage 1 ===== 30 min interval max => 2stage 1 && 2
					if (i >= (ffMinSec / 3.5) && i <= (ffMinSec - (ffMinSec / 3.5))) {
						//[xGR addX:1 y:-20 z:-20]; // real add
						[arrMutGraphVibration addObject:[NSString stringWithFormat:@"%i", 1]];
					} else {
						//[xGR addX:fStagei y:-20 z:-20]; // real add
						[arrMutGraphVibration addObject:[NSString stringWithFormat:@"%f", fStagei]];						
					}
				} else {
					//[xGR addX:fStagei y:-20 z:-20]; // real add
					[arrMutGraphVibration addObject:0];
				}
				iIfinter = 1;
				//[xGR addX:fStagei y:-1 z:-1];
				
				
			}
			
			
			if (ffMinSec>iBoolFlash15Min) { iCycleDeep += 1; iCycleLight += 1; iIfinter = 0;}
			
			if (iIfinter == 1) {
				iCycleLight += 1;
			}
			
		}
		
		if (fbreak==2 && (fStage == 2 || fStage == 1)) {
			NSLog(@"the 3 stage\n");
			fStage = 3;
			fStagei = 4-fStage;
			iCycleDeep += 1;
			for (int i = 0; i < ffMinSec; i++) {
				//[xGR addX:fStagei y:-20 z:-20]; // real add
				[arrMutGraphVibration addObject:[NSString stringWithFormat:@"%f", fStagei]];
			}
		}
		
		
		
		fiNarry += 1;
		fPlus += ffMinSec;
		
	}
	
	// for the last vibration put special to finish level 3
	//[xGR addX:3 y:-20 z:-20]; // real add
	[arrMutGraphVibration addObject:[NSString stringWithFormat:@"%i", 3]];
	
	NSLog(@"count vibration: %i, iCycleLight: %i, iCycleDeep: %i\n", [arrMutGraphVibration count], iCycleLight, iCycleDeep);
	float fTa = 0.0;
	float fTaHist = 0.0;
	iCycleLight = 0;
	for (int k = ([arrMutGraphVibration count]-1); k >= 0; k--) {
		fTa = [[NSString stringWithFormat:@"%@", [arrMutGraphVibration objectAtIndex:k]] floatValue];
		//[xGR addX:fTa y:-20 z:-20];
		
		if (fTa == 2 && fTaHist != fTa) {
			iCycleLight += 1;
		}
		
		fTaHist = fTa;
	}
	
	if (iChangeLevelStat == 2) {
		iCycleLight = (int) (iCycleLight / 1.0);
	}
	if (iChangeLevelStat == 3) {
		iCycleLight = (int) (iCycleLight / 2.0);
	}
	NSLog(@"cycleLightNew: %i\n", iCycleLight);
	
	
	[arrMutGraphVibration release];
	[arrMutMinimum release];
	
	arrMutGraphVibration = nil;
	arrMutMinimum = nil;
	//end statiscs graph for statisss vibration ===================================================
	
	
	
	
	///////////determine cycles to go returnCycleinteger for Deep && Light cycle
	iDeepCycle = iCycleDeep;
	iLightCycle = iCycleLight;
	//iDeepCycle = 2;
	//iLightCycle = 3;
	NSLog(@"NSLOG: deep: %i light: %i\n", iDeepCycle, iLightCycle);
}




@end
