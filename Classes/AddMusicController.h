//
//  AddMusicController.h
//  CycleAlarm
//
//  Created by Symon on 3/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "CycleAlarmAppDelegate.h"

@interface AddMusicController : UIViewController
<AVAudioPlayerDelegate, UITableViewDelegate, UITableViewDataSource, MPMediaPickerControllerDelegate> {
	CycleAlarmAppDelegate *cycleAlarmDlg;
	AVAudioPlayer *soundPlayer;
	AVPlayer *audioPlayerMusic;

	MPMusicPlayerController *musicMP;
	
	MPMediaItem *source_item;
	
	NSString *anAUrl;
	NSString *titleMusic;
	
	int selected;
	int selsection;
	int iselsectOld;
	
	int post;
	
	NSArray *arrNsound;
	
	UIImageView *tImg;
	
	IBOutlet UILabel *lSoundPlay;
	IBOutlet UILabel *lIdSound;
	IBOutlet UILabel *lSecSound;
	IBOutlet UILabel *lNameSound;
	
	IBOutlet UIButton *returSaveSound;
	
	IBOutlet UILabel *lPlay;
	
	IBOutlet UIButton *bChangeSound;
	
	NSMutableArray *arrayTable;
	UITableViewCell *cell;
	UITableViewCell *cellSel;
	
	IBOutlet UITableView *tableNew;
	IBOutlet UIView *soundView;
	IBOutlet UILabel *lmp3iPod;
}
@property (nonatomic, retain) AVAudioPlayer *soundPlayer;
@property (nonatomic, retain) AVPlayer *audioPlayerMusic;
@property (nonatomic, assign) int post;

- (IBAction) acTiPodMusic;
- (IBAction) actionChangeSound;
- (IBAction) actionReturnSaveSound: (id) sender;
- (IBAction) actiPodPlay;

@end
