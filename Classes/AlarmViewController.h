//
//  AlarmViewController.h
//  CycleAlarm
//
//  Created by Symon on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//needs: AVFoundation.framework
#import <AVFoundation/AVAudioSession.h>

//needs: AudioToolbox.framework
#import <AudioToolbox/AudioToolbox.h>

#import <QuartzCore/QuartzCore.h>


@interface AlarmViewController : UIViewController {
	IBOutlet UITabBarItem *tbiAlarm;
	IBOutlet UIButton *bAlarmThird;
	
    IBOutlet UIButton *btnMic;
    IBOutlet UIButton *btnAlarm;
    IBOutlet UIButton *btnStatistic;
    
    
	
	IBOutlet UIButton *bStop;
	IBOutlet UIButton *bMelody;
	IBOutlet UILabel *lAlarm;
	
	IBOutlet UIDatePicker *myPickerView;
	IBOutlet UIDatePicker *myTimeAlarm;
    IBOutlet UISlider *volumeSlider;
	
	IBOutlet UIView *timeAlarmView;
	
	NSTimer *myTimer2;
	IBOutlet UIImageView *imgDog;
//	IBOutlet UIImageView *imgCycleView;
    IBOutlet UIView *viewHelpInfo;
	int iCycle;
	
	UILabel *label;
	UIDatePicker *datePicker;
	
	IBOutlet UIImageView *iRama24AM;
	
	IBOutlet UIImageView *imgBack;
	IBOutlet UIImageView *imgLightView;
	IBOutlet UIImageView *imgFullCycleView;
	IBOutlet UIImageView *imgAlarmClockView;
	
	IBOutlet UIImageView *imgAlertView;
		
	
}
@property (nonatomic, retain) UIDatePicker *myTimeAlarm;

- (IBAction) buttonInfo: (id) sender;
- (IBAction) buttonBack: (id) sender;
- (IBAction) actAlarmStartThird: (id) sender;
- (IBAction) actCycleChange: (id) sender;
- (IBAction) actApearAlert:(id) Sender;

@end
