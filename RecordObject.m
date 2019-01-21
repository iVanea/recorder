//
//  RecordObject.m
//  CycleAlarm
//
//  Created by Symon on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RecordObject.h"


@implementation RecordObject
@synthesize recorder;

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]



- (void) funcStoprecord10sec {
		if (recorder) {
			[self stopRecording];
		}	
}



- (void) startRecording{
	NSLog(@"startRecording ===================\n");
	/*UIBarButtonItem *stopButton = [[UIBarButtonItem alloc] initWithTitle:@"Stop" style:UIBarButtonItemStyleBordered  target:self action:@selector(stopRecording)];
	self.navigationItem.rightBarButtonItem = stopButton;
	[stopButton release];
	*/
	
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	NSError *err = nil;
	[audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
	if(err){
		NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
		return;
	}
	[audioSession setActive:YES error:&err];
	err = nil;
	if(err){
		NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
		return;
	}
	
	
	
	recordSetting = [[NSMutableDictionary alloc] init];
	
	[recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
	[recordSetting setValue:[NSNumber numberWithFloat:400.0] forKey:AVSampleRateKey]; //44100.0
	[recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
	
	[recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
	[recordSetting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
	[recordSetting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
	
	
	
	// Create a new dated file
	NSDate *now = [NSDate dateWithTimeIntervalSinceNow:0];
	NSString *caldate = [NSString stringWithFormat:@"record_%@", [now description]];
	if (recorderFilePath) {
		[recorderFilePath release];
		recorderFilePath = nil;
	}
	recorderFilePath = [[NSString stringWithFormat:@"%@/%@.caf", DOCUMENTS_FOLDER, caldate] retain];
	
	NSURL *url = [NSURL fileURLWithPath:recorderFilePath];
	err = nil;
	recorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err];
	/*if(!recorder){
		NSLog(@"recorder: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
		UIAlertView *alert =
		[[UIAlertView alloc] initWithTitle: @"Warning"
								   message: [err localizedDescription]
								  delegate: nil
						 cancelButtonTitle:@"OK"
						 otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}*/
	
	//prepare to record
	[recorder setDelegate:self];
	[recorder prepareToRecord];
	recorder.meteringEnabled = YES;
	
	BOOL audioHWAvailable = audioSession.inputIsAvailable;
	/*if (! audioHWAvailable) {
		UIAlertView *cantRecordAlert =
		[[UIAlertView alloc] initWithTitle: @"Warning"
								   message: @"Audio input hardware not available"
								  delegate: nil
						 cancelButtonTitle:@"OK"
						 otherButtonTitles:nil];
		[cantRecordAlert show];
		[cantRecordAlert release]; 
		return;
	}*/
	
	
	
	// start recording =================
	//[recorder recordForDuration:(NSTimeInterval) 10]; // max 10 sec, [recorder record];
	[recorder record];
	[self performSelector:@selector(funcStoprecord10sec) withObject:nil afterDelay:10.0]; // stop recording
	
	[recordSetting release];
	recordSetting = nil;
	
}

- (NSString *) funcReturnFilePath {
	return recorderFilePath;
}

- (void) stopRecording{
	
	[recorder stop];
	
	NSURL *url = [NSURL fileURLWithPath: recorderFilePath];
	NSError *err = nil;
	NSData *audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&err];
	if(!audioData)
		NSLog(@"audio data: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
	//[editedObject setValue:[NSData dataWithContentsOfURL:url] forKey:editedFieldKey];   
	
	//[recorder deleteRecording]; is comment
	
	
	NSFileManager *fm = [NSFileManager defaultManager];
	
	err = nil;
	if(err)
		NSLog(@"File Manager: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
	
	
	[recorder release];
	recorder = nil;
	
	/*UIBarButtonItem *startButton = [[UIBarButtonItem alloc] initWithTitle:@"Record" style:UIBarButtonItemStyleBordered  target:self action:@selector(startRecording)];
	self.navigationItem.rightBarButtonItem = startButton;
	[startButton release];*/
	
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *) aRecorder successfully:(BOOL)flag
{
	
	NSLog (@"audioRecorderDidFinishRecording:successfully:");
	// your actions here
	
}

@end
