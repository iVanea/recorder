//
//  TestController.h
//  CycleAlarm
//
//  Created by Symon on 3/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <MediaPlayer/MediaPlayer.h>


@interface TestController : UIViewController
<UIAccelerometerDelegate, AVAudioPlayerDelegate> {
	IBOutlet UITabBarItem *tbiTest;
	AVAudioPlayer *Player;
	
	MPMusicPlayerController *musicMP;
	
	UIAccelerometer *accel;
	
	IBOutlet UISlider *sliderSensitivity;
	
	IBOutlet UILabel *lSensibilityTestView;
	IBOutlet UILabel *lSensibilityTestView2;
	
	IBOutlet UIButton *bTestTestView;
	IBOutlet UIButton *btestCancelTestView;
	
	IBOutlet UIButton *bTestUp;
	
	IBOutlet UIImageView *iUpView;
	IBOutlet UIImageView *iHeaderView;
	IBOutlet UIImageView *iBackView;
	IBOutlet UIImageView *iDowndView;
	
	IBOutlet UIImageView *imgRecommView;
	
	NSTimer *timeNS;
	NSTimer *timeNSMax;
	
	int tIntAlertYes;
	int tti;
	int tPlusMax;
	int ttplus;
	
	float kSens;
	float flMedia;
	float flMediaLast;
	
	double f70;
	
	float xAx;
	float yAx;
	float zAx;
	
	IBOutlet UIImageView *iPoint1;
	IBOutlet UIImageView *iPoint2;
	IBOutlet UIImageView *iPoint3;
	IBOutlet UIImageView *iPoint4;
	IBOutlet UIImageView *iPoint5;
	
	IBOutlet UILabel *xax;
	IBOutlet UILabel *yax;
	IBOutlet UILabel *zax;
	
	IBOutlet UILabel *lblSaveX;
	IBOutlet UILabel *lblSaveY;
	IBOutlet UILabel *lblSaveZ;
}
@property (nonatomic, retain) AVAudioPlayer *Player;

- (IBAction) actUp: (id) sender;
- (IBAction) actTest: (id) sender;
- (IBAction) actTestCancel;
- (IBAction) sliderToMoved;





@end