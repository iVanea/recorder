//
//  Alarm.m
//  CycleAlarm
//
//  Created by Symon on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsController.h"
#import "AddMusicController.h"

@implementation SettingsController
@synthesize bAddMusic, soundPlayer, audioPlayerMusic;



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	return [textField resignFirstResponder];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[txtMin resignFirstResponder];	
}

- (NSString *) saveFilePath: (int) poster
{
	NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	if (poster == 1) {
		return [[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"saveSoundAll.plist"];
	}
	if (poster == 2) {
		return [[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"saveSoundAllsleep.plist"];
	}
	if (poster == 3) {
		return [[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"saveMinutes.plist"];
	}
	return 0;
}


//============save end=============
- (void) startPlayAlarm {
	
	NSString *nSound = lIdmp3.text;
	//======================= start play
	NSLog(@"\n music: %@\n", nSound);
	NSString *soundFolder = @"Sound";
	if (iView == 1) {
		soundFolder = @"SoundSleep";
	}
	if (iView == 2) {
		soundFolder = @"Sound";
	}
	NSString *path = [[NSBundle mainBundle] resourcePath]; 
	path = [path stringByAppendingPathComponent:soundFolder];
	path = [path stringByAppendingPathComponent:nSound];
	path = [NSString stringWithFormat:@"%@", path];
	
	//NSString *path = [[NSBundle mainBundle] pathForResource:@"face1" ofType:@"mp3"];
	self.soundPlayer = nil;
	
	NSLog(@"sdsdpath = %@, %@", path, nSound);
	NSURL *file = [[NSURL alloc] initFileURLWithPath:path];	
	AVAudioPlayer *p = [[AVAudioPlayer alloc] initWithContentsOfURL:file error:nil];
	[file release];	
	self.soundPlayer = p;
	[p release];
	
	[soundPlayer prepareToPlay];
	[soundPlayer setDelegate:self];
	//[self.player setVolume:10.0];
	//======================= end play
}

- (void) startAvPlayAlarm {
	NSURL *tUrl = [NSURL URLWithString:lIdmp3.text];
	self.audioPlayerMusic = nil;
	self.audioPlayerMusic = [AVPlayer playerWithURL:tUrl]; 
	
	NSLog(@"startAvPlayer ============= %@ \n", lIdmp3.text);
}


- (void) bImageChange: (int) poster {
	if (poster == 1) {
		[bSoundAlarm setImage:[UIImage imageNamed:@"btn_awakening_.png"] forState:UIControlStateNormal];
		[bSoundAlarmSleep setImage:[UIImage imageNamed:@"btn_sleep.png"] forState:UIControlStateNormal];
	}
	
	if (poster == 2) {
		[bSoundAlarm setImage:[UIImage imageNamed:@"btn_awakening.png"] forState:UIControlStateNormal];
		[bSoundAlarmSleep setImage:[UIImage imageNamed:@"btn_sleep_.png"] forState:UIControlStateNormal];
	}
}


- (IBAction) actSoundViewController: (id) sender {
	NSLog(@"\n heiii Alarm \n, txtMin rgb: %@", txtMin.textColor.CGColor);	
	
	AddMusicController *h=[[AddMusicController alloc] initWithNibName:@"AddMusicController" bundle:[NSBundle mainBundle]];
	h.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	
	UIButton * bt = (UIButton *)sender;
    NSString *btt = bt.currentTitle;
	if ([btt isEqualToString:@"LOCK"]) {}
	if (bt.tag == 1) {
		h.post = 1;
	}
	if (bt.tag == 2) {
		h.post = 2;
	}
	[self presentModalViewController:h animated:YES];
		
	[h release];
}

- (IBAction) actSoundViewSelf: (id) sender {
	UIButton * bt = (UIButton *)sender;
    NSString *btt = bt.currentTitle;
	
	if (bAddMusic.tag != bt.tag) {
		NSLog(@"tag tag");
		NSString *ss1 = [NSString stringWithFormat:@"%f", sliderSensitive.value];
		NSString *ss2 = [NSString stringWithFormat:@"%f", sliderSensitive.value];
		
		NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSArray *values3 = [[NSArray alloc] initWithContentsOfFile:[[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"saveSens.plist"]];
		NSString *nsKsens1 = [NSString stringWithFormat:@"%@",[values3 objectAtIndex:0]];
		NSString *nsKsens2 = [NSString stringWithFormat:@"%@",[values3 objectAtIndex:1]];
		
		NSArray *values;
		
		if (bt.tag == 2) {
			values = [[NSArray alloc] initWithObjects: ss1, nsKsens2, nil];
			[values writeToFile:[[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"saveSens.plist"] atomically:YES];
		}
		if (bt.tag == 1) {
			values = [[NSArray alloc] initWithObjects: nsKsens1, ss2, nil];
			[values writeToFile:[[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"saveSens.plist"] atomically:YES];
		}
		
		[values release];
		[values3 release];
	}


	
	//===========================
	NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSArray *values3 = [[NSArray alloc] initWithContentsOfFile:[[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"saveSens.plist"]];
	NSString *nsKsens1 = [NSString stringWithFormat:@"%@",[values3 objectAtIndex:0]];
	NSString *nsKsens2 = [NSString stringWithFormat:@"%@",[values3 objectAtIndex:1]];

	[values3 release];	
	//============================
	
	if ([btt isEqualToString:@"LOCK"]) {}
	if (bt.tag == 1) {
		NSLog(@"button 1\n");
		[self bImageChange:1];
		imgMicroView.image = [UIImage imageNamed:@"microViewSoundAWAKENING.png"];
		imgMicroView.frame = CGRectMake(0, 0, 320, 480);
		
		sliderSensitive.value = [nsKsens1 floatValue];//
//		musicMP.volume = sliderSensitive.value;
		
		bAddMusic.tag = 1;
		iView = 1;
		txtMin.hidden = YES;
		
		NSString *myPath3 = [self saveFilePath:1];
		NSArray *values3 = [[NSArray alloc] initWithContentsOfFile:myPath3];
		NSArray *sSound1 = [values3 objectAtIndex:0];
		NSArray *sSound2 = [values3 objectAtIndex:1];
		NSArray *sSound3 = [values3 objectAtIndex:2];
		
		NSString *stringSound1 = [NSString stringWithFormat:@"%@",[sSound2 objectAtIndex:0]];
		NSString *stringSound2 = [NSString stringWithFormat:@"%@",[sSound2 objectAtIndex:1]];
		
		if ([stringSound2 intValue] == 1) {
			/*NSFileManager *fileManager = [NSFileManager defaultManager];
			 NSString *str = [[NSBundle mainBundle] resourcePath];
			 NSArray *arrFlags = [[NSArray alloc] initWithArray:[fileManager contentsOfDirectoryAtPath:[str stringByAppendingPathComponent:@"Sound"] error:nil]];
			 
			 txtMusicName.text  = [arrFlags objectAtIndex:[stringSound1 intValue]];	*/
			NSString *stringSoundx = [sSound1 objectAtIndex:[stringSound1 intValue]-1];
			txtMusicName.text  = [stringSoundx substringToIndex:([stringSoundx length]-4)];
			lIdmp3.text = stringSoundx;
		}
		if ([stringSound2 intValue] == 2) {
			txtMusicName.text = [NSString stringWithFormat:@"%@",[sSound3 objectAtIndex:1]];
			lIdmp3.text = [NSString stringWithFormat:@"%@",[sSound3 objectAtIndex:0]];
		}
		[values3  release];
	}
	if (bt.tag == 2) {
		[self bImageChange:2];
		imgMicroView.image = [UIImage imageNamed:@"microViewSoundSleep.png"];
		imgMicroView.frame = CGRectMake(0, 0, 320, 480);		
		
		sliderSensitive.value = [nsKsens2 floatValue];
//		musicMP.volume = sliderSensitive.value;
		
		iView = 2;
		bAddMusic.tag = 2;
		txtMin.hidden = NO;
		
		NSString *myPath3 = [self saveFilePath:2];
		NSArray *values3 = [[NSArray alloc] initWithContentsOfFile:myPath3];
		NSArray *sSound1 = [values3 objectAtIndex:0];
		NSArray *sSound2 = [values3 objectAtIndex:1];
		NSArray *sSound3 = [values3 objectAtIndex:2];
		
		NSString *stringSound1 = [NSString stringWithFormat:@"%@",[sSound2 objectAtIndex:0]];
		NSString *stringSound2 = [NSString stringWithFormat:@"%@",[sSound2 objectAtIndex:1]];
		
		if ([stringSound2 intValue] == 1) {
			/*NSFileManager *fileManager = [NSFileManager defaultManager];
			NSString *str = [[NSBundle mainBundle] resourcePath];
			NSArray *arrFlags = [[NSArray alloc] initWithArray:[fileManager contentsOfDirectoryAtPath:[str stringByAppendingPathComponent:@"Sound"] error:nil]];
			
			txtMusicName.text  = [arrFlags objectAtIndex:[stringSound1 intValue]];	*/
			NSString *stringSoundx = [sSound1 objectAtIndex:[stringSound1 intValue]-1];
			txtMusicName.text  = [stringSoundx substringToIndex:([stringSoundx length]-4)];
			lIdmp3.text = stringSoundx;
		}
		if ([stringSound2 intValue] == 2) {
			txtMusicName.text = [NSString stringWithFormat:@"%@",[sSound3 objectAtIndex:1]];
			lIdmp3.text = [NSString stringWithFormat:@"%@",[sSound3 objectAtIndex:0]];
		}
		[values3  release]; 
	}
	
	
}






// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	musicMP = [MPMusicPlayerController iPodMusicPlayer];
	iPlay = 0;
	
	
	[sliderSensitive setMinimumTrackImage:[UIImage imageNamed:@"slider_foot.png" ] forState:UIControlStateNormal];
	[sliderSensitive setMaximumTrackImage:[UIImage imageNamed:@"slider_top.png" ] forState:UIControlStateNormal];
	// circle png
	[sliderSensitive setThumbImage:[UIImage imageNamed:@"slider.png" ] forState:UIControlStateNormal];
	
    [super viewDidLoad];
	NSLog(@"viewDidLoad = Settings\n");
	iView = 2;
//    NSLog(@"%@",[[UIFont familyNames] description]);
    
    txtMin.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    txtMusicName.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    
}

- (void) playDelay {
	/*if ([lIdmp3.text hasPrefix:@"ipod-library"]) {
		[self.audioPlayerMusic pause];
	    self.audioPlayerMusic.rate = 0;
	} else {
		[self.soundPlayer stop];
		self.soundPlayer.currentTime = 0.0;
	}*/
	    [self.audioPlayerMusic pause];
	    self.audioPlayerMusic.rate = 0;
	    [self.soundPlayer stop];
		self.soundPlayer.currentTime = 0.0;
	    iPlay = 0;
}
- (IBAction) sliderToMoved {
	NSLog(@"Slider Moved\n");
	musicMP.volume = sliderSensitive.value;
	
	
		if (iPlay == 0) {
			if ([lIdmp3.text hasPrefix:@"ipod-library"]) {
				[self startAvPlayAlarm];
				[self.audioPlayerMusic play];
			} else {
				[self startPlayAlarm];
			    [self.soundPlayer play];
			}
			iPlay = 1;
			[self performSelector:@selector(playDelay) withObject:nil afterDelay:3.0];
		}
}

- (void)viewDidDisappear:(BOOL)animated {
	NSLog(@"DisApear Settings\n");
	// stoped music ===
	[self playDelay];
	// end stoped music ===
	
	
	// Minutes save =========
	/*NSString *myPath5 = [self saveFilePath:3];
	NSArray *values55 = [[NSArray alloc] initWithContentsOfFile:myPath5];
	NSString *sMinutes = [values55 objectAtIndex:0];
	[values55 release];*/
	if ([txtMin.text isEqualToString:@""]) {
		txtMin.text = @"0";
	}
	if ([txtMin.text intValue]>1439) { // 1440 24H
		txtMin.text = @"1439";
	}
	NSArray *valuesSave = [[NSArray alloc] initWithObjects:txtMin.text, nil];
	[valuesSave writeToFile:[self saveFilePath:3] atomically:YES];
	[valuesSave release];
	// Minute save end ======
	
//	musicMP.volume = kSens;
	
	NSString *ss1 = [NSString stringWithFormat:@"%f", sliderSensitive.value];
	NSString *ss2 = [NSString stringWithFormat:@"%f", sliderSensitive.value];
	
	NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSArray *values3 = [[NSArray alloc] initWithContentsOfFile:[[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"saveSens.plist"]];
	NSString *nsKsens1 = [NSString stringWithFormat:@"%@",[values3 objectAtIndex:0]];
	NSString *nsKsens2 = [NSString stringWithFormat:@"%@",[values3 objectAtIndex:1]];
	
	NSArray *values;
	
	if (iView == 1) {
		values = [[NSArray alloc] initWithObjects: ss1, nsKsens2, nil];
		[values writeToFile:[[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"saveSens.plist"] atomically:YES];
	}
	if (iView == 2) {
		values = [[NSArray alloc] initWithObjects: nsKsens1, ss2, nil];
		[values writeToFile:[[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"saveSens.plist"] atomically:YES];
	}
	
	[values release];
	[values3 release];	
}

-(void) viewDidAppear:(BOOL)animated {
	// Minute load ======
	NSString *myPath5 = [self saveFilePath:3];
	NSArray *values55 = [[NSArray alloc] initWithContentsOfFile:myPath5];
	NSString *sMinutes = [values55 objectAtIndex:0];
	if ([sMinutes isEqualToString:@""] || !sMinutes) {
		sMinutes = @"5";
	}
	txtMin.text = sMinutes;
	[values55 release];
	// Minute load end===
	
//	kSens = musicMP.volume;
	//===========================
	NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSArray *values3 = [[NSArray alloc] initWithContentsOfFile:[[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"saveSens.plist"]];
	NSString *nsKsens1 = [NSString stringWithFormat:@"%@",[values3 objectAtIndex:0]];
	NSString *nsKsens2 = [NSString stringWithFormat:@"%@",[values3 objectAtIndex:1]];
	NSLog(@"Snes == = = 1=%@, 2=%@,\n", nsKsens1, nsKsens2);
	/*if (![values3 objectAtIndex:0] || ![values3 objectAtIndex:1]) {
		printf("null nsKsens");
		nsKsens1 = @"0.5";
		nsKsens2 = @"0.5";
	}*/
	if (iView == 1) {
		sliderSensitive.value = [nsKsens1 floatValue];
//		musicMP.volume = sliderSensitive.value;
	}
	if (iView == 2) {
		sliderSensitive.value = [nsKsens2 floatValue];
//		musicMP.volume = sliderSensitive.value;
	}
	[values3 release];	
	//============================
	
	
	if (iView == 2) {
		bAddMusic.tag = 2;
		txtMin.hidden = NO;
		[self bImageChange:2];
				
		NSString *myPath3 = [self saveFilePath:2];
		NSArray *values3 = [[NSArray alloc] initWithContentsOfFile:myPath3];
		NSArray *sSound1 = [values3 objectAtIndex:0];
		NSArray *sSound2 = [values3 objectAtIndex:1];
		NSArray *sSound3 = [values3 objectAtIndex:2];
		
		NSString *stringSound1 = [NSString stringWithFormat:@"%@",[sSound2 objectAtIndex:0]];
		NSString *stringSound2 = [NSString stringWithFormat:@"%@",[sSound2 objectAtIndex:1]];
		
		if ([stringSound2 intValue] == 1) {
			/*NSFileManager *fileManager = [NSFileManager defaultManager];
			 NSString *str = [[NSBundle mainBundle] resourcePath];
			 NSArray *arrFlags = [[NSArray alloc] initWithArray:[fileManager contentsOfDirectoryAtPath:[str stringByAppendingPathComponent:@"Sound"] error:nil]];
			 
			 txtMusicName.text  = [arrFlags objectAtIndex:[stringSound1 intValue]];	*/
			NSString *stringSoundx = [sSound1 objectAtIndex:[stringSound1 intValue]-1];
			txtMusicName.text  = [stringSoundx substringToIndex:([stringSoundx length]-4)];
			lIdmp3.text = stringSoundx;
		}
		if ([stringSound2 intValue] == 2) {
			txtMusicName.text = [NSString stringWithFormat:@"%@",[sSound3 objectAtIndex:1]];
			lIdmp3.text = [NSString stringWithFormat:@"%@",[sSound3 objectAtIndex:0]];

		}
		[values3  release];
		
	}
	
	if (iView == 1) {
		bAddMusic.tag = 1;
		txtMin.hidden = YES;
		[self bImageChange:1];
				
		NSString *myPath3 = [self saveFilePath:1];
		NSArray *values3 = [[NSArray alloc] initWithContentsOfFile:myPath3];
		NSArray *sSound1 = [values3 objectAtIndex:0];
		NSArray *sSound2 = [values3 objectAtIndex:1];
		NSArray *sSound3 = [values3 objectAtIndex:2];
		
		NSString *stringSound1 = [NSString stringWithFormat:@"%@",[sSound2 objectAtIndex:0]];
		NSString *stringSound2 = [NSString stringWithFormat:@"%@",[sSound2 objectAtIndex:1]];
		
		if ([stringSound2 intValue] == 1) {
			/*NSFileManager *fileManager = [NSFileManager defaultManager];
			 NSString *str = [[NSBundle mainBundle] resourcePath];
			 NSArray *arrFlags = [[NSArray alloc] initWithArray:[fileManager contentsOfDirectoryAtPath:[str stringByAppendingPathComponent:@"Sound"] error:nil]];
			 
			 txtMusicName.text  = [arrFlags objectAtIndex:[stringSound1 intValue]];	*/
			NSString *stringSoundx = [sSound1 objectAtIndex:[stringSound1 intValue]-1];
			txtMusicName.text  = [stringSoundx substringToIndex:([stringSoundx length]-4)];
			lIdmp3.text = stringSoundx;
		}
		if ([stringSound2 intValue] == 2) {
			txtMusicName.text = [NSString stringWithFormat:@"%@",[sSound3 objectAtIndex:1]];
			lIdmp3.text = [NSString stringWithFormat:@"%@",[sSound3 objectAtIndex:0]];
		}
		[values3  release];
	}
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
