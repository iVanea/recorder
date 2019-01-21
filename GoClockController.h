//
//  GoClockController.h
//  CycleAlarm
//
//  Created by Symon on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
//needs: AVFoundation.framework
#import <AVFoundation/AVAudioSession.h>

//needs: AudioToolbox.framework
#import <AudioToolbox/AudioToolbox.h>

#import <QuartzCore/QuartzCore.h>

//#import "ClockViews.h"
#import "TestGraph.h"
#import "RecorderLoad.h"
#import "CycleAlarmAppDelegate.h"

@interface GoClockController : UIViewController 
<AVAudioPlayerDelegate, MPMediaPickerControllerDelegate> {
	CycleAlarmAppDelegate *cycleAlarmDlg;
	AVAudioPlayer *soundPlayer;
	AVPlayer *audioPlayerMusic;	
	MPMusicPlayerController *musicMP;	
	MPMediaItem *source_item;
	TestGraph *hTest;
	RecorderLoad *recorderFileHLoad;
	
	NSTimer *timerMinSleepEnd;
	NSTimer *timeSlowVolume;
	NSTimer *timerAlertAlarm2;
	
	float fSlowVolume;
	float senderHistVolume;
	
	int iSnoozeMin;
	int i4View;
	
	NSTimeInterval t1970start;
	
	IBOutlet UIButton *bStop;
	IBOutlet UIButton *bMelody;
	IBOutlet UIButton *bContinue;
	IBOutlet UIButton *bStoped;
	IBOutlet UIButton *bSnooze;
	IBOutlet UILabel *lAlarm;
	
    IBOutlet UILabel *currentTime;
	NSString *sSoundSleep;
	NSString *lSmp3;
	IBOutlet UILabel *lSoundPlay;
	
	NSString *stringDateStart;
	NSString *stringHmStart;
	NSDate *dateStart3;
	
	IBOutlet UIView *timeAlarmView;
	IBOutlet UIImageView *blackView;
	
	UIImageView *tImgCircle;
//	ClockViews *clockView;
	UIImageView *tImgClock;
	
	NSTimer *myTimer2;
	NSTimer *timerBlack;
	IBOutlet UIImageView *imgDog;
	IBOutlet UIImageView *imgCycleView;
	
	int iCycle;
	int iAlarmNfile;
	int hourS, minS;
	int iOptimal4ViewBool;
	
	int iiGoSaveinFile;
	
	float fVolume;
	
	UILabel *label;
	UIDatePicker *datePicker;
	
	IBOutlet UIImageView *imgBack;
	IBOutlet UIImageView *imgLightView;
	IBOutlet UIImageView *imgFullCycleView;
	IBOutlet UIImageView *imgAlarmClockView;
}
@property (nonatomic, assign) int hourS, minS, iCycle, i4View;
@property (nonatomic, retain) AVAudioPlayer *soundPlayer;
@property (nonatomic, retain) AVPlayer *audioPlayerMusic;

- (IBAction) actStopAlarm: (id) sender;
- (IBAction) actStopMelody: (id) sender;

- (void) stopAllMelody;
- (void) audioSoundGo;


@end
