//
//  GraphController.h
//  CycleAlarm
//
//  Created by Symon on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>


#import "GraphView.h"
#import "CycleAlarmAppDelegate.h"


@interface GraphController : UIViewController
<AVAudioPlayerDelegate, UIScrollViewDelegate> {
	CycleAlarmAppDelegate *cycleAlarmDlg;
	AVAudioPlayer *soundPlayer;
	
	IBOutlet UITabBarItem *tbiStatistics;
	IBOutlet UIScrollView *scrollGraphView;
	GraphView *xGR;
	GraphView *xGRn;
	
	
	IBOutlet UIButton *clearStatistics;
	IBOutlet UIButton *bBack;
	IBOutlet UIButton *bCyclesSleep;
	IBOutlet UIButton *bNoiseSleep;
	IBOutlet UIImageView *imgRecordsSleep;
	
	IBOutlet UILabel *lTimeAsleep;
	IBOutlet UILabel *lTimeAlarm;
	
	int iButtIdSelected;
	int selected;
	int selsection;
	
	int iSelStat;
	int iWidthGraph;
	int iCountAllMin;
	int iMinAllsleepDetected;
	
	int iCycleDeep;
	int iCycleLight;
	int iCycleHist;
	int iCount15Min;
	
	int iChangeLevelStat;
	
	int iIDarrayStat;
	int intIDSoundSavePlaying;
	int intIDSoundSavePlayingFinish;
	UIImageView *imgBackView;
	UIImageView *imgBackViewPage;
	
	//IBOutlet UIButton *tBut;
	UIImageView *tImg;
	UIImageView *tImgL;
	
	NSMutableArray *arrayTable;
	NSMutableArray *arrayTableStat;
	NSMutableArray *arrayMutNoiseAddSubView;
	NSMutableArray *arrMutGraphVibration;
	
	NSTimer *timeRecordImage;
	
	
	
}
@property (nonatomic, retain) AVAudioPlayer *soundPlayer;
@property (nonatomic, assign) int iIDarrayStat;

- (void) startPlayAlarm;

- (IBAction) actSleepAndNoiseCycle:(id) sender;
- (IBAction) actBackToStat:(id) sender;

-(IBAction) actTargetPlayAudioGo: (id) sender; 

@end
