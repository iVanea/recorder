//
//  RecordObject.h
//  CycleAlarm
//
//  Created by Symon on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface RecordObject : NSObject 
<AVAudioRecorderDelegate>{
	AVAudioRecorder *recorder;
	
	NSMutableDictionary *recordSetting;
	NSString *recorderFilePath;
	
}

@property (nonatomic, retain) AVAudioRecorder *recorder;

- (void) startRecording;
- (void) stopRecording;
- (NSString *) funcReturnFilePath;

@end
