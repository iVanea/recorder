//
//  RecorderLoad.m
//  CycleAlarm
//
//  Created by Symon on 5/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RecorderLoad.h"


@implementation RecorderLoad
@synthesize iRecordStoped;

- (NSString *) saveFilePath: (int) poster
{
	NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	if (poster == 8) {
		return [[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"saveArrayAllStatistics.plist"];
	}
	return 0;
}

- (NSMutableArray *) funcReturnSaveArrInFile {
	//iMinNum += 1;
	
	NSTimeInterval t1970 = [[NSDate date] timeIntervalSince1970];

			NSString *stAverage = [NSString stringWithFormat:@"%0.3f", fAverageMax];
			NSString *siMinNum = [NSString stringWithFormat:@"%f", fiMinNum];
			NSString *st1970 = [NSString stringWithFormat:@"%f", (t1970 - t1970start)];
			
			NSArray *arrT = [[NSArray alloc] initWithObjects: stAverage, st1970, siMinNum, nil];
			
			[arrMut addObject:arrT];
			[arrT release];
	NSLog(@"arrMutNoise: %@, \n", arrMut);
		
	return arrMut;
}

- (NSMutableArray *) funcReturnNoisePathNameFileArray {
	return arrMutRecord;
}

- (void) funcListener5sec {
	//AudioQueueLevelMeterState *levels = [[SCListener sharedListener] levels];
	//Float32 peak = levels[0].mPeakPower;
	//Float32 average = levels[0].mAveragePower;
	
	//[[[SCListener sharedListener] retain] listen];
	//AudioQueueLevelMeterState *levels = [[SCListener sharedListener] levels];
	//Float32 average = levels[0].mAveragePower;
	
	Float32 average = [[SCListener sharedListener] averagePower];
	
	//Float32 average = levels[0].mAveragePower;
		
	i5secNum += 1;
	f5sec += average;
	if (i5secNum >= 12) {
		fMedia5sec = average / i5secNum;
		i5secNum = 0;
		f5sec = 0;
		
		[timeListener5sec invalidate];
		timeListener5sec = nil;
		
		timeListener = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(funcListener) userInfo:nil repeats:YES]; // new timer verify to record
	}
	
	NSLog(@"listener: %f, average: %f,\n", [[SCListener sharedListener] averagePower], average);	
}

- (void) funcRecordNil {
	/*if (iRecordBool == 1) {
		[hRecord stopRecording]; // stop recording && save in to Documents Directory
	}*/
	
	if (hRecord && iRecordBool == 1) { // add name filePath record in array && time
		if ([hRecord.recorder isRecording]) {
			[hRecord stopRecording];
			
			//remove temporar audiop record after cancel clock alarm
			NSFileManager *fm = [NSFileManager defaultManager];
			NSURL *url = [NSURL fileURLWithPath: [hRecord funcReturnFilePath]];
			[fm removeItemAtPath:[url path] error:nil]; // remove files temporar
		}
		
			NSTimeInterval t1970 = [[NSDate date] timeIntervalSince1970];
			NSString *sTime = [NSString stringWithFormat:@"%f", (t1970 - t1970start)];
			NSString *sNameSavePath = [NSString stringWithFormat:@"%@", [hRecord funcReturnFilePath]];
			NSArray *arrTrec = [[NSArray alloc] initWithObjects: sNameSavePath, sTime, nil];
			
			[arrMutRecord addObject: arrTrec];
			
			[arrTrec release];
			NSLog(@"arrMutRecord add target url\n");
			
			iRecordCount += 1; // NOISE STIMULI + ICOUNT
		
	}
	
	if (timerRecord) {
		[timerRecord invalidate];
		timerRecord = nil;
	}
	if (hRecord) {
		[hRecord release];
		hRecord = nil;
	}
	iRecordBool = 0;
}
- (void) funcListener {
//	AudioQueueLevelMeterState *levels = [[SCListener sharedListener] levels];
	//Float32 peak = levels[0].mPeakPower;
	//Float32 average = levels[0].mAveragePower;
	Float32 average = [[SCListener sharedListener] averagePower];
	
	fiMinNum += 0.5;
	
	NSTimeInterval t1970 = [[NSDate date] timeIntervalSince1970];
	
	
	if (average > (fMedia5sec + 0.0)) { //average > media level mirophone
		
		if (average > fAverageMax) {
			fAverageMax = average;
		}
		
		/*
		if ((t1970 - t1970History) >= 60.0) { //timehistory > 60 sec to addobject in aaray whith level & time
			NSString *stAverage = [NSString stringWithFormat:@"%0.3f", fAverageMax];
			NSString *siMinNum = [NSString stringWithFormat:@"%f", fiMinNum];
			NSString *st1970 = [NSString stringWithFormat:@"%f", (t1970 - t1970start)];
			
			NSArray *arrT = [[NSArray alloc] initWithObjects: stAverage, st1970, siMinNum, nil];
			
			[arrMut addObject:arrT];
			[arrT release];
			
			t1970History = t1970;
			fAverageMax = 0.0;
		}
		*/
		//////////////////////////////////////
		
		if ( fabs( [dateHist timeIntervalSinceNow] ) >= 60.0) { //timehistory > 60 sec to addobject in aaray whith level & time
			NSString *stAverage = [NSString stringWithFormat:@"%0.3f", fAverageMax];
			NSString *siMinNum = [NSString stringWithFormat:@"%f", fiMinNum];
			NSString *st1970 = [NSString stringWithFormat:@"%f", (t1970 - t1970start)];
			
			NSArray *arrT = [[NSArray alloc] initWithObjects: stAverage, st1970, siMinNum, nil];
			
			[arrMut addObject:arrT];
			[arrT release];
			
			if (dateHist) {
				[dateHist release];
				dateHist = nil;
			}
			
			dateHist = [[NSDate date] retain];
			fAverageMax = 0.0;
		 }
		 
		//////////////////////////////////////
	}	

	
	
	// record audio ================ 
	float fAverageLimit = 0.10; // standard 0.07 for record voice
	if (fMedia5sec <= 0.2) { // if fmedia > 0.3 => no record
		
		
		if (fMedia5sec >= 0.10) {
			fAverageLimit = fMedia5sec + ((fMedia5sec * 50) / 100);
		}
		else {
			fAverageLimit = 0.10;
		}

		
				
		if (average > fAverageLimit && iRecordBool == 0 && iRecordStoped != 1) { //iRecordStoped != 1; sends from goClocker stop last 30 sec remaining for no records
			hRecord = [[RecordObject alloc] init];
			[hRecord startRecording]; // start recording && save in to Documents Directory
			//[hRecord stopRecording]; // stop recording && save in to Documents Directory
			iRecordBool = 1;
			//iRecordCount += 1; // iRecordCount += 1; exist in funcNillRecord stoped
			
			timerRecord = [NSTimer scheduledTimerWithTimeInterval:14 target:self selector:@selector(funcRecordNil) userInfo:nil repeats:NO];
			
			
		}
	
	}
	//end record audio =============
}


- (int) funcReturnRecordCount {
	return iRecordCount;	
}



- (void) stopRecordInitAudioTemp {
	
	[hRecord stopRecording]; // stop recording && save in to Documents Directory
	
	NSFileManager *fm = [NSFileManager defaultManager];
	NSURL *url = [NSURL fileURLWithPath: [hRecord funcReturnFilePath]];
	[fm removeItemAtPath:[url path] error:nil]; // remove files temporar
	
	[hRecord release];
	hRecord = nil;
}



- (void) funcTime5SecAfeterDelay1Sec {
		
		
	
	
	
	timeListener5sec = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(funcListener5sec) userInfo:nil repeats:YES]; // every 5 sec in 1 min
		
	

}



- (void) ObjectLoad {
	[self performSelector:@selector(funcTime5SecAfeterDelay1Sec) withObject:nil afterDelay:0.0]; // every 5 sec in 1 min
	
	// iRecord BOOL 1 or 0 (0 - is stop, posible record)
	iRecordBool = 0;
	// iRecordCount 0 count of records in fuul time
	iRecordCount = 0;
	
	// create nstime1970 start
	t1970start = [[NSDate date] timeIntervalSince1970];
	dateHist = [[NSDate date] retain];
	
	// create array for noise && array noise Record
	arrMut = [[NSMutableArray alloc] init];
	arrMutRecord = [[NSMutableArray alloc] init];
	
	
	
	
	
	
	// Start listening.
	[[SCListener sharedListener] listen];
	//[[SCListener sharedListener] performSelector:@selector(listen) withObject:nil afterDelay:0.1];
	
	
	
	
	////////////for sound work in listing mod///////////////
	hRecord = [[RecordObject alloc] init];
	[hRecord startRecording]; // start recording && save in to Documents Directory
	// stop record in 0.1 sec
	[self performSelector:@selector(stopRecordInitAudioTemp) withObject:nil afterDelay:0.1];
	////////////end for sound work in listing mod///////////////
	
	
	
	
	

	
	
	
	
	
	
	
	//hRecord = [[RecordObject alloc] init];
	//[hRecord startRecording]; // start recording && save in to Documents Directory
	//[hRecord stopRecording]; // stop recording && save in to Documents Directory
	//[hRecord release];
}


- (void) ObjectUnLoad {
	if ([[SCListener sharedListener] isListening]) {
		NSLog(@"LISTENER ISLISTENING go to stop and release\n");
		[[SCListener sharedListener] stop]; // stop listener
		//[[SCListener sharedListener] dealloc];
		//[[SCListener sharedListener] release];
		//[SCListener sharedListener] = nil;
	}
	/*if ([SCListener sharedListener]) {
		[[SCListener sharedListener] release];
	}*/
	
		
	[self funcRecordNil]; // nil record start or stoped or timer invalidate
	
	if (hRecord) {
		[hRecord.recorder stop];
		hRecord.recorder = nil;
		[hRecord release];
		hRecord = nil;
	}
	
	
	
	if (timeListener) {
		[timeListener invalidate];
		timeListener = nil;
	}
	if (timeListener5sec) {
		[timeListener5sec invalidate];
		timeListener5sec = nil;
	}
	
	if (arrMut) {
		[arrMut release];
		arrMut = nil;
	}
	if (arrMutRecord) {
		[arrMutRecord release];
		arrMutRecord = nil;
	}

}



@end
