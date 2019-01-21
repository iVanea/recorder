//
//  TestGraph.h
//  CycleAlarm
//
//  Created by Symon on 4/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>


@interface TestGraph : NSObject
<UIAccelerometerDelegate> {
	IBOutlet UITabBarItem *tbiTest;
	
	MPMusicPlayerController *musicMP;
	
	UIAccelerometer *accel;
	
	//IBOutlet UIView *TestGraphView;
	
	float lSensibilityTestView;
	float lSensibilityTestView2;
	
	IBOutlet UIButton *bTestTestView;
	IBOutlet UIButton *btestCancelTestView;
	
	NSArray *arrayPlus;
	NSArray *arrayHistPlus;
	NSMutableArray *arrayTable;
	NSMutableArray *arrMutGraphVibration;
	
	NSTimer *myTimerSecg;
	NSTimer *myTimerStageNull;
	
	NSString *nsTimeSec;
	NSTimeInterval nsTimeFirst;
	NSTimer *timeNSg;
	NSTimer *timeNSMaxg;
	
	NSString *nsNvibr;
	
	int iTimeSec;
	
	int iCycleDeep;
	int iCycleLight;
	
	int iChangeLevelStat;
	int iCount15Min;
	
	int tIntAlertYes;
	int tti;
	int tPlusMax;
	int ttplus;
	
	int iTenArray;
	int iLightCycle;
	int iDeepCycle;
		
	float tSensAcc;
	
	float kSens;
	float flMedia;
	float flMediaLast;
	float fSendStage;
	
	double f70;
	
	float xAx;
	float yAx;
	float zAx;
	
	IBOutlet UIImageView *iPoint1;
	IBOutlet UIImageView *iPoint2;
	IBOutlet UIImageView *iPoint3;
	IBOutlet UIImageView *iPoint4;
	IBOutlet UIImageView *iPoint5;
	
	 float xax;
	 float yax;
	 float zax;
	
	 float lblSaveX;
	 float lblSaveY;
	 float lblSaveZ;
}
@property (nonatomic, retain) UIView *TestGraphView;

- (void) actTest: (int) sender;
- (IBAction) actTestCancel;
- (float) boolReturnStage;
- (int) boolReturnDeepCycle;
- (int) boolReturnLightCycle;
- (void) determineCycles;


	
@end
