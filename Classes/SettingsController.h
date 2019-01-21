//
//  Alarm.h
//  CycleAlarm
//
//  Created by Symon on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface SettingsController : UIViewController 
<AVAudioPlayerDelegate>
{		
	AVAudioPlayer *soundPlayer;
	AVPlayer *audioPlayerMusic;
	
    IBOutlet UITabBarItem *tbiSettings;
	MPMusicPlayerController *musicMP;
	
	IBOutlet UIImageView *imgMicroView;
	
	IBOutlet UIButton *bSoundAlarm;
	IBOutlet UIButton *bSoundAlarmSleep;
	IBOutlet UIButton *bAddMusic;
		
	IBOutlet UILabel *txtMusicName;
	IBOutlet UITextField *txtMin;
	
	int iView;
	int iPlay;
	float kSens;
	
	IBOutlet UILabel *lIdmp3;
	IBOutlet UISlider *sliderSensitive;
	
	
		
		
}
@property (nonatomic, retain) AVAudioPlayer *soundPlayer;
@property (nonatomic, retain) AVPlayer *audioPlayerMusic;
@property (nonatomic, retain) UIButton *bAddMusic;

- (IBAction) actSoundViewController: (id) sender;
- (IBAction) actSoundViewSelf: (id) sender;
- (IBAction) sliderToMoved;

@end
