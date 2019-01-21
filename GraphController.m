//
//  GraphController.m
//  CycleAlarm
//
//  Created by Symon on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GraphController.h"


@implementation GraphController
@synthesize iIDarrayStat, soundPlayer;


- (NSString *) saveFilePath: (int) poster
{
	NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	if (poster == 1) {
		return [[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"saveTimeAlarm.plist"];
	}
	if (poster == 8) {
		return [[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"saveArrayAllStatistics.plist"];
	}
	return 0;
}


- (IBAction) actBackToStat:(id) sender {
	[self dismissModalViewControllerAnimated:YES];
	cycleAlarmDlg.tabBarBottomView.hidden = NO;
}

- (IBAction) actSleepAndNoiseCycle:(id) sender {
	UIButton * bt = (UIButton *)sender;
	switch (bt.tag) {
		case 0:
			xGR.hidden = NO;
			xGRn.hidden = NO;
			[bCyclesSleep setImage:[UIImage imageNamed:@"sleep_cycles_.png"] forState:UIControlStateNormal];
			[bNoiseSleep setImage:[UIImage imageNamed:@"noice.png"] forState:UIControlStateNormal];
			break;
		case 1:
			xGR.hidden = YES;
			xGRn.hidden = NO;
			[bCyclesSleep setImage:[UIImage imageNamed:@"sleep_cycles.png"] forState:UIControlStateNormal];
			[bNoiseSleep setImage:[UIImage imageNamed:@"noice_.png"] forState:UIControlStateNormal];
			break;
		default:
			break;
			/*
			 case 0:
			 xGR.hidden = NO;
			 //xGRn.hidden = NO;
			 [bCyclesSleep setImage:[UIImage imageNamed:@"Gsleep_cycles_on.png"] forState:UIControlStateNormal];
			 //[bNoiseSleep setImage:[UIImage imageNamed:@"Gnoises_off.png"] forState:UIControlStateNormal];
			 bCyclesSleep.tag = 2;
			 break;
			 case 1:
			 //xGR.hidden = YES;
			 xGRn.hidden = NO;
			 //[bCyclesSleep setImage:[UIImage imageNamed:@"Gsleep_cycles_off.png"] forState:UIControlStateNormal];
			 [bNoiseSleep setImage:[UIImage imageNamed:@"Gnoises_on.png"] forState:UIControlStateNormal];
			 bNoiseSleep.tag = 3;
			 break;
			 case 2:
			 xGR.hidden = YES;
			 //xGRn.hidden = NO;
			 [bCyclesSleep setImage:[UIImage imageNamed:@"Gsleep_cycles_off.png"] forState:UIControlStateNormal];
			 //[bNoiseSleep setImage:[UIImage imageNamed:@"Gnoises_off.png"] forState:UIControlStateNormal];
			 bCyclesSleep.tag = 0;
			 break;
			 case 3:
			 //xGR.hidden = YES;
			 xGRn.hidden = YES;
			 //[bCyclesSleep setImage:[UIImage imageNamed:@"Gsleep_cycles_off.png"] forState:UIControlStateNormal];
			 [bNoiseSleep setImage:[UIImage imageNamed:@"Gnoises_off.png"] forState:UIControlStateNormal];
			 bNoiseSleep.tag = 1;
			 break;
			 default:
			 break;
			 */
	}
}











-(void) funcTimeRecordImageViewAnimation {
		
	if (imgRecordsSleep.image == [UIImage imageNamed:@"records.png"]) {
		imgRecordsSleep.image = [UIImage imageNamed:@"records_.png"];
	} else {
		imgRecordsSleep.image = [UIImage imageNamed:@"records.png"];
	}

		
}

















- (void) stopAllMelody {

	[self.soundPlayer stop];
	self.soundPlayer.currentTime = 0.0;
	
}








- (void) audioPlayerDidFinishPlaying: (AVAudioPlayer *)
player successfully: (BOOL) completed {
	NSLog(@"intIDSoundSavePlaying: %i\n", intIDSoundSavePlaying);
	
	if (completed == YES) {
		// if soped to finsih:
		
		
		if ((intIDSoundSavePlayingFinish - intIDSoundSavePlaying ) >= 0) {
			
			// replay to finish:
			[self startPlayAlarm];
			[self.soundPlayer play];
			
			
		} else { // stop animation recording
			if (timeRecordImage) {
				[timeRecordImage invalidate];
				timeRecordImage = nil;
				imgRecordsSleep.image = [UIImage imageNamed:@"records.png"];
			}
		}

		
		
		
		
	}
	
}











- (void) startPlayAlarm {
	NSArray *values4 = [[NSArray alloc] initWithContentsOfFile:[self saveFilePath:8]];
	NSArray *values6 = [[NSArray alloc] initWithArray:[[values4 objectAtIndex:iIDarrayStat] objectAtIndex:3]]; // for noise array all
	
	NSString *nSound = [NSString stringWithFormat:@"%@", [[values6 objectAtIndex:intIDSoundSavePlaying] objectAtIndex:0]];
	
	[values4 release];
	[values6 release];
	
	values4 = nil;
	values6 = nil;
	
	
	
	
	//======================= start play
	NSLog(@"\n music: %@\n", nSound);
	
	//NSString *path = [[NSBundle mainBundle] resourcePath]; 
	NSString *path = [NSString stringWithFormat:@"%@", nSound];
	
	//NSString *path = [[NSBundle mainBundle] pathForResource:@"face1" ofType:@"mp3"];
	self.soundPlayer = nil;
	
	NSLog(@"sdsdpath = %@, %@", path, nSound);
	NSURL *file = [[NSURL alloc] initFileURLWithPath:path];	
	AVAudioPlayer *p = [[AVAudioPlayer alloc] initWithContentsOfURL:file error:nil];
	[file release];	
	self.soundPlayer = p;
	[p release];
	
	[soundPlayer prepareToPlay];
	[soundPlayer setDelegate:self];
	//[self.player setVolume:10.0];
	//======================= end play
	
	intIDSoundSavePlaying = intIDSoundSavePlaying + 1;
}













- (void) goSoundRecordPlay: (int) iSender1 soundTwo: (int) iSender2 {
	if (!timeRecordImage) {
		timeRecordImage = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(funcTimeRecordImageViewAnimation) userInfo:nil repeats:YES];
	}
	NSLog(@"SoundRecord Start: %i, Finish: %i\n", iSender1, iSender2);
	intIDSoundSavePlaying = iSender1;
	intIDSoundSavePlayingFinish = iSender2;
	
	[self stopAllMelody];
	
	[self startPlayAlarm];
	[soundPlayer play];
}











-(IBAction) actTargetPlayAudioGo: (id) sender {
	UIButton * bt = (UIButton *)sender;
	NSLog(@"play go butt: %i CurrentTitle: %@\n", bt.tag, bt.currentTitle);
	
	int iCountArray = [arrayMutNoiseAddSubView count];
	
	int iStartSoundID = [[arrayMutNoiseAddSubView objectAtIndex:bt.tag] intValue];
	
	
	
	if (iCountArray > (bt.tag + 1)) {
		int iFinishSoundID = [[arrayMutNoiseAddSubView objectAtIndex:(bt.tag+1)] intValue];
		
		
		[self goSoundRecordPlay:iStartSoundID soundTwo:(iFinishSoundID-1)]; // next id not play => -1
		
	} else {
		[self goSoundRecordPlay:iStartSoundID soundTwo:([bt.currentTitle intValue])];
	}

		


}











- (void) viewWillAppear:(BOOL)animated {
			
	NSArray *values4 = [[NSArray alloc] initWithContentsOfFile:[self saveFilePath:8]];
	NSArray *values1 = [[NSArray alloc] initWithArray:[[values4 objectAtIndex:iIDarrayStat] objectAtIndex:0]]; // for graph time AM PM
	NSArray *values3 = [[NSArray alloc] initWithArray:[[values4 objectAtIndex:iIDarrayStat] objectAtIndex:1]]; // for graph vibration
	NSArray *values2 = [[NSArray alloc] initWithArray:[[values4 objectAtIndex:iIDarrayStat] objectAtIndex:2]]; // for graph noise
	NSArray *values5 = [[NSArray alloc] initWithArray:[[values4 objectAtIndex:iIDarrayStat] objectAtIndex:0]]; // for noise...
	NSArray *values6 = [[NSArray alloc] initWithArray:[[values4 objectAtIndex:iIDarrayStat] objectAtIndex:3]]; // for noise array all
	
	lTimeAsleep.text = [NSString stringWithFormat:@"%@", [values1 objectAtIndex:1]];
	lTimeAlarm.text = [NSString stringWithFormat:@"%@", [values1 objectAtIndex:2]];
	
	if ([[NSString stringWithFormat:@"%@", [values1 objectAtIndex:6]] intValue] > 0) { // image record or no record, if exist nosie record
		imgRecordsSleep.image = [UIImage imageNamed:@"records.png"];
	} else {
		imgRecordsSleep.image = [UIImage imageNamed:@"no_records.png"];
	}

	//time detected in minutes transform:
	NSString *temp = [NSString stringWithFormat:@"%@", [values1 objectAtIndex:3]];
	int itTmin = [[temp substringFromIndex:3] intValue];
	int itThour = [[temp substringToIndex:2] intValue];
	iMinAllsleepDetected = (itThour * 60) + (itTmin);
	NSLog(@"temp all min: %i, hour: %i, min %i,\n", iMinAllsleepDetected, itThour, itTmin);
	//temp= [temp substringToIndex:([temp length]-4)];
	
	//	temp = [[[temp substringToIndex:1] capitalizedString]  stringByAppendingString:[temp substringFromIndex:1]] ;
	temp = [temp  capitalizedString] ;
	temp = [temp stringByReplacingOccurrencesOfString:@"_" withString:@" "];
	
	
	[values1 release];
	[values4 release];
	values1 = nil;
	values4 = nil;
	
	iWidthGraph = (int)(iMinAllsleepDetected * 1.08); // 1600 max for 24 h (px) , 1.08
	//iWidthGraph = 10;

	if (iWidthGraph < 10) {
		iWidthGraph = 10;
	}
	//[values3 writeToFile:[[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"saveArrayStatPrime1.plist"] atomically:YES];
	//[values3 writeToFile:[[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"saveArrayStatPrime2.plist"] atomically:YES];
	//[values3 writeToFile:[[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"saveArrayStatPrime3.plist"] atomically:YES];
	//[values3 writeToFile:[[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"saveArrayStatPrime4.plist"] atomically:YES];
	//[values3 writeToFile:[[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"saveArrayStatPrime5.plist"] atomically:YES];
	
	
	//iWidthGraph = 1600;
	
	
	
	
	imgBackView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Gback_center.png"]];
	imgBackView.layer.transform = CATransform3DMakeRotation (1.57, 0, 0, 1);
//    if (IS_IPHONE_5) {
        imgBackView.frame = CGRectMake(40, 0, 244, 570);
//    }else{
//        imgBackView.frame = CGRectMake(40, 0, 244, 480);} // 34. 247
	[self.view addSubview:imgBackView];
	
		
	lTimeAsleep.layer.transform = CATransform3DMakeRotation (1.57, 0, 0, 1);
	lTimeAlarm.layer.transform = CATransform3DMakeRotation (1.57, 0, 0, 1);

	scrollGraphView = [[UIScrollView alloc]init];
	scrollGraphView.frame = CGRectMake(-55, 81, 470, 300);
	//xGR.layer.transform = CATransform3DMakeRotation (1.7, 0, 0, 1);
	scrollGraphView.layer.transform = CATransform3DMakeRotation (1.57, 0, 0, 1);
	
	scrollGraphView.contentSize = CGSizeMake(iWidthGraph, 300);
	scrollGraphView.delegate = self;
	
	//graph vibration ===
	xGR = [[GraphView alloc] initWithFrame:CGRectMake(1, 116, iWidthGraph, 0)]; //600, 0 , 1600 max for 24 h
	xGR.autoresizingMask =  UIViewAutoresizingNone;
	xGR.backgroundColor = [UIColor clearColor];
	
	// graph noise ======
	xGRn = [[GraphView alloc] initWithFrame:CGRectMake(0, 200, iWidthGraph, 0)]; //600, 0 
	xGRn.autoresizingMask =  UIViewAutoresizingNone;
	xGRn.backgroundColor = [UIColor clearColor];
	
	scrollGraphView.backgroundColor = [UIColor clearColor];
	
	scrollGraphView.bounces = NO; // scroll stoped in finish

	//[[UIAccelerometer sharedAccelerometer] setDelegate:self]; 
	[xGR setIsAccessibilityElement:YES];
	//[xGR setAccessibilityLabel:NSLocalizedString(@"x", @"")];
	
		
		
	
	
	// statiscs graph for noise ===================================================
	float fNoise = 0;
	float fNoiseGraph = 0;
	float fNoiseHist = 0;
	for (int i = ([values2 count]-1); i >= 0; i--) {
		NSArray *arrNoise = [NSArray arrayWithArray:[values2 objectAtIndex:i]];
		fNoise = [[NSString stringWithFormat:@"%@", [arrNoise objectAtIndex:0]] floatValue]; // original
		fNoiseGraph = [[NSString stringWithFormat:@"%@", [arrNoise objectAtIndex:0]] floatValue]*20; // no original, graph
		if (fNoiseGraph > 3) { // very high = > 3.0 max
			fNoiseGraph = 3;
		}
		[xGRn addX:-6 y:fNoiseGraph z:-6]; // one the 1 stage point start
		
		if (fNoise > fNoiseHist) {
			fNoiseHist = fNoise;
		}
	}
	
	NSLog(@"fNoise: %f,\n" , fNoiseHist);
	
	
	
	
	// button play all on graph ===============
	NSLog(@"VALUES5-6: %i, values5: %@\n", [[values5 objectAtIndex:6] intValue], values5);
	
	if ([[values5 objectAtIndex:6] intValue] > 0) { // if number record is > 0 => addsubview button records
		arrayMutNoiseAddSubView = [[NSMutableArray alloc] init];
		int iButTagSave = 0;
		int intIplus = 0;
		
		for (int i = 0; i < ([[values5 objectAtIndex:6] intValue]); i++) {
			//UIView *tView = [[UIView alloc] initWithFrame:CGRectMake((250 + (i*3)), 7, 36, 38)];
			UIButton *tBut = [[UIButton alloc] init];	
			[tBut setImage:[UIImage imageNamed:@"Gvolume_left.png"] forState:UIControlStateNormal];
			
			
			//([[values6 objectAtIndex:i] intValue] / 60)
			int itMinI = ([[[values6 objectAtIndex:i] objectAtIndex:1] floatValue] / 60) / 1.05; // 1.07
			//int itMinI = i * 15;
			
			//tBut.frame = CGRectMake((34 + itMinI), 68, 15, 15);
			tBut.frame = CGRectMake((34 + itMinI), 255, 15, 41);
			//tBut.tag = i; // tag index
			[tBut setTitle:[NSString stringWithFormat:@"%i", ([[values5 objectAtIndex:6] intValue] - 1)] forState:normal];
			
			[tBut addTarget:self action:@selector(actTargetPlayAudioGo:) forControlEvents:UIControlEventTouchUpInside];
			
			//[tView addSubview:tBut];
			//[xGRn addSubview:tView];
			
			//xGRn.userInteractionEnabled = YES;
			if (i == 0) {
				[scrollGraphView addSubview:tBut];
				iButTagSave = i;
				[arrayMutNoiseAddSubView addObject:[NSString stringWithFormat:@"%i", i]];
				tBut.tag = intIplus;
				intIplus += 1;
			}
			
			float fSecButRecord = [[[values6 objectAtIndex:i] objectAtIndex:1] floatValue];
			float fSecButRecordSave = [[[values6 objectAtIndex:iButTagSave] objectAtIndex:1] floatValue];
			
			if (i > 0 && (fSecButRecord - fSecButRecordSave) > 900) {
				[scrollGraphView addSubview:tBut];
				iButTagSave = i;
				[arrayMutNoiseAddSubView addObject:[NSString stringWithFormat:@"%i", i]];
				tBut.tag = intIplus;
				intIplus += 1;
			} 

			
			
			[tBut release];
			//[tView release];
		}			
	//end button play all on graph ============	
		
	}
	// end statiscs graph for noise ===================================================
	
	
	
	
	
	
	/*
	// stat line ===	
	
	GraphView *xGRl = [[GraphView alloc] initWithFrame:CGRectMake(1, 240, iWidthGraph, 0)]; //600, 0 , 1600 max, for 24 h, (1, 116, iWidGraph, 0)
	xGRl.autoresizingMask =  UIViewAutoresizingNone;
	xGRl.backgroundColor = [UIColor clearColor];
	
	
	for (int i = 0; i < iMinAllsleepDetected; i++) { // i < iCountAllMin
		[xGRl addX:-6 y:1 z:-6];
	}
	
	[scrollGraphView addSubview:xGRl];
	// stat line ===	
	*/
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
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
	
	
	
	////////////////////////
	NSMutableArray *mutTempValues3 = [NSMutableArray arrayWithArray:values3];
	[mutTempValues3 addObject:[NSArray arrayWithObjects:@"", @"", @"", @"", @"", @"", nil]];
	
	
	
	
	mutTempValues3 = nil;
	///////////////////////
	
	
	
	NSMutableArray *arrMutMinimum = [[NSMutableArray alloc] init];
	arrMutGraphVibration = [[NSMutableArray alloc] init];
	
	for (int i = 0; i < [values3 count]; i++) {
		NSArray *tarray = [values3 objectAtIndex:i];
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
					[arrMutGraphVibration addObject:[NSString stringWithFormat:@"%d", 3]];
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
		[xGR addX:fTa y:-20 z:-20];
		
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
	//end statiscs graph for statisss vibration ===================================================
	
	

	
	
	[scrollGraphView addSubview:xGR];
	[scrollGraphView addSubview:xGRn];
	[self.view addSubview:scrollGraphView];
			
	imgBackViewPage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Gback_page7.png"]];

	imgBackViewPage.layer.transform = CATransform3DMakeRotation (1.57, 0, 0, 1);

    imgBackViewPage.frame = CGRectMake(0, 0, 320, 480);

	[self.view addSubview:imgBackViewPage];
	
	[self.view addSubview:bBack];
	[self.view addSubview:bCyclesSleep];
	[self.view addSubview:bNoiseSleep];
	[self.view addSubview:imgRecordsSleep];
	[self.view addSubview:lTimeAsleep];
	[self.view addSubview:lTimeAlarm];
	
	
	[values2 release];
	[values3 release];
	[values5 release];
	[values6 release];
	[arrMutMinimum release];
	[arrMutGraphVibration release];
	arrMutGraphVibration = nil;
	arrMutMinimum = nil;
	values3 = nil;
	values2 = nil;
	values5 = nil;
	values6 = nil;
	
	
	cycleAlarmDlg = (CycleAlarmAppDelegate *) [[UIApplication sharedApplication] delegate];
	[cycleAlarmDlg.tabBarBottomView performSelector:@selector(setHidden:) withObject:@"1" afterDelay:0.3];
}

- (void) viewWillDisappear:(BOOL)animated {
	NSLog(@"viewWillDisappear");
}

- (void) viewDidDisappear:(BOOL)animated {
	NSLog(@"viewDidDisappear");
	[xGR removeFromSuperview];
	[xGRn removeFromSuperview];
	[scrollGraphView removeFromSuperview];
	[imgBackView removeFromSuperview];
	
	[bCyclesSleep removeFromSuperview];
	[bNoiseSleep removeFromSuperview];
	[imgRecordsSleep removeFromSuperview];
	[lTimeAsleep removeFromSuperview];
	[lTimeAlarm removeFromSuperview];
	
	[imgBackView release];
	[imgBackViewPage release];
	
	[arrayMutNoiseAddSubView release];
	
	imgBackView = nil;
	imgBackViewPage = nil;
	scrollGraphView = nil;
	xGR = nil;
	xGRn = nil;
	
	arrayMutNoiseAddSubView = nil;
	
	
	
	[self stopAllMelody];
	if (soundPlayer) {
		[soundPlayer release];
		soundPlayer = nil;
	}
	
	if (timeRecordImage) {
		[timeRecordImage invalidate];
		timeRecordImage = nil;
	}
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
