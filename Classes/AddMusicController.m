//
//  AddMusicController.m
//  CycleAlarm
//
//  Created by Symon on 3/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddMusicController.h"
//#import "TSLibraryImport.h"



@implementation AddMusicController
@synthesize soundPlayer, audioPlayerMusic, post;


- (void)viewWillAppear:(BOOL)animated {
	cycleAlarmDlg = (CycleAlarmAppDelegate *) [[UIApplication sharedApplication] delegate];
	[cycleAlarmDlg.tabBarBottomView performSelector:@selector(setHidden:) withObject:@"1" afterDelay:0.3];
}




//============save =============
- (NSString *) saveFilePath: (int) iPost {
	NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	if (post == 1 || iPost == 1) {
		return [[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"saveSoundAll.plist"];
	}
	if (post == 2 || iPost == 2) {
		return [[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"saveSoundAllsleep.plist"];
	}
	return 0;
}


// return sound
- (NSString *) stringSound {
	//NSLog(@"dssssss5555");
	
	NSString *myPath3 = [self saveFilePath:post];
	NSArray *values3 = [[NSArray alloc] initWithContentsOfFile:myPath3];
	NSArray *sSound3 = [values3 objectAtIndex:0];
	
	NSString *stringSound = [NSString stringWithFormat:@"%@",[sSound3 objectAtIndex:[lIdSound.text intValue]-1]];
	stringSound = [stringSound substringToIndex:([stringSound length]-4)];
	
	[values3  release];
	
	NSLog(@"string sound from array= %@", stringSound);	
	return stringSound;
	//return @"face1";
}
//============save end=============




- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	return [textField resignFirstResponder];
}




// ========================= iPod selection Music ===================
- (IBAction) acTiPodMusic {
	MPMediaPickerController *mediaController = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAny];
	mediaController.delegate = self;
	mediaController.allowsPickingMultipleItems = NO;	
	
	[self presentModalViewController:mediaController animated:YES];
	
	
	
	[mediaController release];
}

- (void)exportAssetAtURL:(NSURL*)assetURL withTitle:(NSString*)title {
	
}

- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection {
	
	if (anAUrl) {[anAUrl release];}
	if (titleMusic) {[titleMusic release];}
	
	source_item = [[mediaItemCollection items]objectAtIndex:0];
	anAUrl = [[NSString stringWithFormat:@"%@", [source_item valueForProperty:MPMediaItemPropertyAssetURL]] retain];
	
	[self.soundPlayer stop];
	self.soundPlayer.currentTime = 0.0;
	
	[self.audioPlayerMusic pause];
	self.audioPlayerMusic.rate = 0;
	
	lSoundPlay.text = @"stoped";

	// stop playing
	lIdSound.text = @"1";
	lSecSound.text = @"2";
	selected = 0;
	selsection = 1;
	iselsectOld = selsection;
	[self audioSoundGo];
	[tableNew reloadData];

	/*NSURL *urlr = [source_item valueForProperty:MPMediaItemPropertyAssetURL];
	 NSString *strr = [NSString stringWithFormat:@"%@", urlr];
	 anAUrl = [NSURL URLWithString:strr];*/
	
	titleMusic = [NSString stringWithFormat:@"%@", [source_item valueForProperty:MPMediaItemPropertyTitle]];
	
	//temp= [temp substringToIndex:([titleMusic length]-4)];
	if ([titleMusic length] >21) {
		titleMusic = [titleMusic substringToIndex:21];
		titleMusic = [NSString stringWithFormat:@"%@...", titleMusic];
	}
	[titleMusic retain];
	lmp3iPod.text = titleMusic;
	
	
	
	
	[mediaPicker dismissModalViewControllerAnimated:YES];
}

- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker {
	lSoundPlay.text = @"stoped";
	
	// stop playing
	lIdSound.text = @"1";
	lSecSound.text = @"2";
	selected = 0;
	selsection = 1;
	iselsectOld = selsection;
	[tableNew reloadData];
	NSLog(@"mediaPicker didCancel: %@,\n", mediaPicker);
	[mediaPicker dismissModalViewControllerAnimated:YES];
	
}
// ========================= end iPod selection Music =================







// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {	
	[super viewDidLoad];
	
	NSLog(@" application path = %@ \n\n", [[NSBundle mainBundle] bundlePath]);
	//========================	
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	//NSArray *files = [fileManager contentsOfDirectoryAtPath:@"Sound" error:NULL];
	NSString *soundFolder;
	if (post == 1) {
		soundFolder = @"SoundSleep";
	}
	if (post == 2) {
		soundFolder = @"Sound";
	}
	NSString *str = [[NSBundle mainBundle] resourcePath];
	NSArray *arrFlags = [[NSArray alloc] initWithArray:[fileManager contentsOfDirectoryAtPath:[str stringByAppendingPathComponent:soundFolder] error:nil]];
	
	/*
	 NSFileManager *fileManager = [NSFileManager defaultManager];
	 NSString *str = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Sound"];
	 //NSString *str = [[NSBundle mainBundle] pathForResource:@"Sound" ofType:@""];
	 NSArray *arrFlags = [fileManager contentsOfDirectoryAtPath:[[NSBundle mainBundle] bundlePath] error:nil];
	 */
	//arrFlags = [[NSBundle mainBundle] pathsForResourcesOfType:nil inDirectory:nil];
	
	NSLog(@" asdfjadjsfklajsfjds\n\n ===== %@ \n\n %d, i= %@", arrFlags, [arrFlags count], lIdSound.text);
	
	NSString *myPath = [self saveFilePath:post];
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:myPath];
	
	if (!fileExists)
	{
        NSLog(@"insnt file viewdildoad addmusiccontroller");
		NSString *itt = [NSString stringWithFormat:@"ipod-library://item/item.mp3?id=1"];
		NSString *itt2 = @"None";
		
		//NSArray *arrFlags2 = [NSArray array];
		NSArray *arrFlags2 = [[NSArray alloc] initWithObjects:@"1", @"1", nil];
		NSArray *arriPod = [[NSArray alloc] initWithObjects:itt, itt2, nil];
		NSArray *valuesS = [[NSArray alloc] initWithObjects:arrFlags, arrFlags2, arriPod, nil]; 
		
		//		for (Byte i=0; i<[valuesS count]; i++) {
		//			[[valuesS objectAtIndex:i] writeToFile:[self saveFilePath:post] atomically:YES];
		//	}
		
		[valuesS writeToFile:[self saveFilePath:post] atomically:YES];
		NSLog(@" count = %d", [valuesS count]);
		
		selected = 0;
		lIdSound.text = @"1";
		lSecSound.text = @"1";
		
		anAUrl = itt;
		titleMusic = itt2;
		
		[arrFlags2 release];
		[arriPod release];
		[valuesS release];
	} else {
		NSArray *values3 = [[NSArray alloc] initWithContentsOfFile:[self saveFilePath:post]];
		NSArray *sSound1 = [values3 objectAtIndex:1];
		NSArray *sSound2 = [values3 objectAtIndex:2];
		
		anAUrl = [NSString stringWithFormat:@"%@",[sSound2 objectAtIndex:0]];
		titleMusic = [NSString stringWithFormat:@"%@",[sSound2 objectAtIndex:1]];
		
		NSString *stringSound1 = [NSString stringWithFormat:@"%@",[sSound1 objectAtIndex:0]];
		NSString *stringSound2 = [NSString stringWithFormat:@"%@",[sSound1 objectAtIndex:1]];
		selected = [stringSound1 intValue]-1;
		selsection = [stringSound2 intValue]-1;
		lIdSound.text = stringSound1;
		lSecSound.text = stringSound2;
		
		[values3 release];
	}
	NSLog(@"ViewDidLoad: %@, %@,\n", anAUrl, titleMusic);
	if ([titleMusic length] >21) {
		titleMusic = [titleMusic substringToIndex:21];
		titleMusic = [NSString stringWithFormat:@"%@...", titleMusic];
	}
	
	[anAUrl retain];
	[titleMusic retain];
	
	arrayTable = [[NSMutableArray alloc] init];
	
	for (int i=0; i<[arrFlags count]; i++) {
		
		//if([[arrFlags objectAtIndex:i] hasPrefix:@"f"]) {
		[arrayTable addObject:[arrFlags objectAtIndex:i]];
		//}
		
		//[arrayTable addObject:[arrFlags objectAtIndex:i]];
		
	}
	//	NSLog(@" arraytable\n\n ===== %@ \n\n %d", arrayTable, [arrayTable count]);
	
	self.view.frame = CGRectMake(0, 0, 320, 480);
	//flagsView.backgroundColor = [UIColor whiteColor];
	
	[arrFlags release];
	
	tableNew = [[UITableView alloc] initWithFrame:CGRectMake(0, 90, 320, 320) style:UITableViewStylePlain ];
	tableNew.delegate = self;
	tableNew.dataSource = self;
	
	//tableNew.frame = CGRectMake(9, 40, 300, 300);
	tableNew.rowHeight = 36;
	//tableNew.backgroundColor = [UIColor colorWithRed:0.247 green:0.247 blue:0.247 alpha:1.0];
	//tableNew.separatorColor = [UIColor colorWithRed:0.376 green:0.376 blue:0.376 alpha:1.0];
	tableNew.separatorColor = [UIColor clearColor];
	tableNew.backgroundColor = [UIColor clearColor];
	
	[self.view addSubview:tableNew];
	[self.view addSubview:returSaveSound];
	[tableNew reloadData];
	
	[tableNew release];
	
	//=========================	
	
	
	
	
	
	//lPlay.hidden = YES;
	//bSave.hidden = YES;
	
	lmp3iPod.text = titleMusic;
	lPlay.text = @"stoped";
}



- (void) startPlayAlarm {
	
	NSString *nSound = [NSString stringWithFormat:@"%@", [self stringSound]];
	//======================= start play
	NSLog(@"\n music: %@\n", nSound);
	NSString *soundFolder = @"Sound";
	if (post == 1) {
		soundFolder = @"SoundSleep";
	}
	if (post == 2) {
		soundFolder = @"Sound";
	}
	
	NSString *path = [[NSBundle mainBundle] resourcePath]; 
	path = [path stringByAppendingPathComponent:soundFolder];
	path = [path stringByAppendingPathComponent:nSound];
	path = [NSString stringWithFormat:@"%@.mp3", path];
	
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
	NSURL *tUrl = [NSURL URLWithString:anAUrl];
	self.audioPlayerMusic = nil;
	self.audioPlayerMusic = [AVPlayer playerWithURL:tUrl]; 
	
	NSLog(@"startAvPlayer ============= %@ \n", anAUrl);
}

- (void) audioSoundGo {
	if ([lSoundPlay.text isEqualToString:@"stoped"]) {
		if ([lSecSound.text isEqualToString:@"1"]) {
			[self startPlayAlarm];
			[self.soundPlayer play];
		}
		if ([lSecSound.text isEqualToString:@"2"]) {
			[self startAvPlayAlarm];
			[self.audioPlayerMusic play];
		}
		
		
		lSoundPlay.text = @"play";	
		NSLog(@"\n sound play: %@, \n", lSoundPlay.text);
	}
}



- (void) audioPlayerDidFinishPlaying: (AVAudioPlayer *)
player successfully: (BOOL) completed {
	if (completed == YES && [lSoundPlay.text isEqualToString:@"play"]) {
		// if soped to finsih:
		//lPlay.text = @"stoped";
		
		// replay to finish:
		[self.soundPlayer play];
	}
}

- (IBAction) actionSave: (id) sender {
	
}

- (IBAction) actionReturnSaveSound: (id) sender {
	UIButton * bt = (UIButton *)sender;
    NSString *btt = bt.currentTitle;
	[arrayTable release];
	if ([btt isEqualToString:@"cancelSaveSound"]) {
		lSoundPlay.text = @"stoped";
		[self.soundPlayer stop];
		self.soundPlayer.currentTime = 0.0;
		[self.audioPlayerMusic pause];
		self.audioPlayerMusic.rate = 0;
		self.soundPlayer = nil;
		self.audioPlayerMusic = nil;
		//[tableNew reloadData];
		[self dismissModalViewControllerAnimated:YES];
		cycleAlarmDlg.tabBarBottomView.hidden = NO;
	}
	if ([btt isEqualToString:@"saveSound"]) {
		lSoundPlay.text = @"stoped";
		[self.soundPlayer stop];
		self.soundPlayer.currentTime = 0.0;
		[self.audioPlayerMusic pause];
		self.audioPlayerMusic.rate = 0;
		self.soundPlayer = nil;
		self.audioPlayerMusic = nil;
		
		//====== array sound select && save
		NSArray *values3 = [[NSArray alloc] initWithContentsOfFile:[self saveFilePath:post]];
		NSArray *sSound0 = [values3 objectAtIndex:0];
		//NSArray *sSound1 = [values3 objectAtIndex:1];
		//NSArray *sSound2 = [values3 objectAtIndex:2];
		
		//NSString *stringSound1 = [NSString stringWithFormat:@"%@",[sSound1 objectAtIndex:0]];
		//NSString *stringSound2 = [NSString stringWithFormat:@"%@",[sSound1 objectAtIndex:1]];
		//stringSound2 = [stringSound2 substringToIndex:([stringSound2 length]-4)];
		
		
		NSArray *arrFlags2 = [[NSArray alloc] initWithObjects:lIdSound.text, lSecSound.text, nil];
		NSArray *arrFlags3 = [[NSArray alloc] initWithObjects:anAUrl, titleMusic, nil];
		
		NSArray *valuesS1 = [[NSArray alloc] initWithObjects:sSound0, arrFlags2, arrFlags3, nil]; 
		[valuesS1 writeToFile:[self saveFilePath:post] atomically:YES];
		NSLog(@"MSSIV:%@, ====== anurl %@, tilemusic %@, \n", valuesS1, anAUrl, titleMusic);
		
		[arrFlags2 release];
		[arrFlags3 release];
		[valuesS1 release];
		[values3  release];
		//====== end array sound select && save
		
		NSLog(@"\n saved sound \n");		
		NSLog(@"dfsfds: %@, string:%@ \n", lIdSound.text, [self stringSound]);
		cycleAlarmDlg.tabBarBottomView.hidden = NO;
		[self dismissModalViewControllerAnimated:YES];
	}
}

- (IBAction) actionChangeSound {
	selected = [[self stringSound] intValue]-1;
	lIdSound.text = [self stringSound];
	NSLog(@"\n stringSound %@\n",[self stringSound]);
	[tableNew reloadData];
  	soundView.hidden = NO;
}

- (IBAction) actiPodPlay {
	if (tImg) {
		[tImg removeFromSuperview];
		[tImg release];
		tImg = nil;
	}
	selected = 0;
	selsection = 1;
	iselsectOld = selsection;
	lIdSound.text = @"1";
	lSecSound.text = @"2";
	
	
	if ([lSoundPlay.text isEqualToString:@"stoped"]) {
		[self audioSoundGo];
	}
	// no corect, because up lbltext = play;
	//if ([lSoundPlay.text isEqualToString:@"play"]) {
	else {
	    [self.soundPlayer stop];
	    self.soundPlayer.currentTime = 0.0;
		
		[self.audioPlayerMusic pause];
		self.audioPlayerMusic.rate = 0;
	    // stop playing
	    lSoundPlay.text = @"stoped";
	}
	[tableNew reloadData];
}









- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	
	cell = nil;
		
	if (cell != nil){ 
		for (UIView *view in [cell.contentView subviews]) {
			[view removeFromSuperview];
		}
	}
	else
		cell = [ [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	//cell.backgroundColor = [UIColor clearColor];
	//cell.backgroundView.backgroundColor = [UIColor clearColor];
	
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
	
	UIImageView *imgLine = [[UIImageView alloc] init];
	[imgLine setImage:[UIImage imageNamed:@"table_cel.png"]];
	imgLine.frame = CGRectMake(0, -4, 320, 43);
	[cell addSubview:imgLine];
	[imgLine release];
	
	
	
	if (selected == indexPath.row && selsection == indexPath.section) { 
		cell.imageView.image = [UIImage imageNamed:@"playing.png"];
		cell.textLabel.textColor = [UIColor colorWithRed:2.0/255.0 green:128.0/255.0 blue:217.0/255.0 alpha:1.0];
		
		if (tImg) {
			[tImg removeFromSuperview];
			[tImg release];
			tImg = nil;
		}
		
		tImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iSelected.png"]];
		tImg.frame = CGRectMake(260, 10, 20, 20);
		[cell addSubview:tImg];
		
		if (![self.soundPlayer isPlaying] && selsection == 0) {
			cell.imageView.image = [UIImage imageNamed:@"stoped.png"];
		}
		if ([lSoundPlay.text isEqualToString:@"stoped"] && selsection == 1) {
			cell.imageView.image = [UIImage imageNamed:@"stoped.png"];
		}
		
	}
	else {
		cell.imageView.image = [UIImage imageNamed:@"stoped.png"];
		cell.textLabel.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
		
	}
	
		
	NSUInteger index[2];
	[indexPath getIndexes:index];
	
	printf(" sec = %d\n row = %d\n\n", index[0], index[1]);
	
	NSString *tmpStringName;
	NSString *tempOrig;
	NSString *temp;
	// if section 1 else 2
	if (index[0] == 0) {
		NSString *temp = [arrayTable objectAtIndex:indexPath.row];	
		//temp = [temp substringFromIndex:6];
		temp= [temp substringToIndex:([temp length]-4)];	
		tempOrig = temp;	
		tmpStringName = @"       ";
	}
	if (index[0] == 1) {
		//NSString *temp = [arrayTable objectAtIndex:indexPath.row];	
		//temp = [temp substringFromIndex:6];
		//temp= [temp substringToIndex:([temp length]-4)];	
		//temp = @"sound form iPod";
		temp = titleMusic;
		tempOrig = temp;	
		tmpStringName = @"";
		if (indexPath.row == 1) {
			temp = @"add from iPod";
			tempOrig = temp;	
			tmpStringName = @"";
		}
		if (indexPath.row == 0) {
			temp = [NSString stringWithFormat:@"iPod: %@", temp];
			tempOrig = temp;	
			tmpStringName = @"       ";
		}
	}
		
	cell.textLabel.text = [tmpStringName stringByAppendingString: tempOrig];
	
	//cell.textLabel.font = [UIFont boldSystemFontOfSize: 16];
	
	
	
	return cell;
	[temp release];
	[cell release];
}
/*
 // cell height
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 return 50.0;
 }*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	//return 2;
	if (section == 0) {
		return [arrayTable count];
	}
	if (section == 1) {
		return 1;
	}
	return [arrayTable count];
	return 0;
}

/*- (NSString *)tableView:(UITableView *)tableView 
titleForHeaderInSection:(NSInteger)section
{
	if ( section == 0 ) return @"Standart Melody";
	if ( section == 1 ) return @"From iPod Melody";
	return @"Other";
}*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;	
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
	/*NSLog(@"\n indexPath: %@, \n", indexPath);
	
	NSUInteger index[2];
	[indexPath getIndexes:index];	
	printf("2 sec = %d\n row = %d\n\n", index[0], index[1]);
	
			*/	
	if (indexPath.row == selected && indexPath.section == selsection) {
				
		UITableViewCell *line = [tableView cellForRowAtIndexPath:indexPath];
		line.imageView.image = [UIImage imageNamed:@"stoped.png"];
		
		if (![self.soundPlayer isPlaying] ) {
			[tableView reloadData];
		}
		
			[tableView reloadData];
		
	} else {
		/*if (tImg) {
			[tImg removeFromSuperview];
			[tImg release];
			tImg = nil;
		}
		UITableViewCell *Tline = [tableView cellForRowAtIndexPath:indexPath];
		tImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iSelected.png"]];
		tImg.frame = CGRectMake(260, 15, 20, 20);
		[Tline addSubview:tImg];*/
		
		
			
		iselsectOld = selsection;
		selected = indexPath.row;
		selsection = indexPath.section;
		//cellSel.imageView.image = [UIImage imageNamed:@"bEnter.png"];
		//cellSel.textLabel.textColor = [UIColor whiteColor];
		//[tableView reloadData];
	}
	[tableView reloadData];
		
	//cellSel.textLabel.textColor = [UIColor whiteColor];
	//cellSel.imageView.image = [UIImage imageNamed:@"bEnter.png"];
	
	//cellSel = [tableView cellForRowAtIndexPath:indexPath];
	
    //cellSel.textLabel.textColor = [UIColor blackColor];
	//cellSel.imageView.image = [UIImage imageNamed:@"bHigh.png"];
	
	NSLog(@"\n label: %@, idsound: %d, selecOld: %i \n", lSoundPlay.text, indexPath.row, iselsectOld);
	
	
	if ((indexPath.row+1) != [lIdSound.text intValue] || ((indexPath.section) != iselsectOld))
	{
		[self.soundPlayer stop];
	    self.soundPlayer.currentTime = 0.0;
		[self.audioPlayerMusic pause];
		self.audioPlayerMusic.rate = 0;
	    // stop playing
	    lSoundPlay.text = @"stoped";
	 	NSLog(@"trrrrrr=====================================\n");
		iselsectOld=selsection;
	} 
	
	
	/*	
	 if ((indexPath.row+1) != [lIdSound.text intValue] && indexPath.section != iselsectOld)
	 {
	 
	 [self.soundPlayer stop];
	 self.soundPlayer.currentTime = 0.0;
	 // stop playing
	 lSoundPlay.text = @"stoped";
	 
	 NSLog(@"trrrrrr=====================================\n");
	 } */
	
	
	lIdSound.text = [NSString stringWithFormat:@"%d", indexPath.row+1];
	lSecSound.text = [NSString stringWithFormat:@"%d", indexPath.section+1];
	
	/*if ([cellSel.textLabel.text isEqualToString:@"ipod-library://item/item.mp3?id=1"]) {
		
	}*/
	if (indexPath.row == 1 && indexPath.section == 1) {
		[self acTiPodMusic];
	} else {

		if ([lSoundPlay.text isEqualToString:@"stoped"]) {
		[self audioSoundGo];
		}
	    // no corect, because up lbltext = play;
	    //if ([lSoundPlay.text isEqualToString:@"play"]) {
	    else {
	    [self.soundPlayer stop];
	    self.soundPlayer.currentTime = 0.0;
		
		[self.audioPlayerMusic pause];
		self.audioPlayerMusic.rate = 0;
	    // stop playing
	    lSoundPlay.text = @"stoped";
	    }
	}
}











- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	NSLog(@"dis mis ================= mis\n");
}


- (void)dealloc {
    [super dealloc];
	
	/*if (tImg) {
	 [tImg removeFromSuperview];
	 [tImg release];
	 tImg = nil;
	 }
	 [tableNew removeFromSuperview];
	 [returSaveSound removeFromSuperview];
	 */
	
	//if (arrayTable) {[arrayTable release];}
	if (anAUrl != NULL && anAUrl != nil) {[anAUrl release];}
	if (titleMusic != NULL && titleMusic != nil) {[titleMusic release];}
	/*if (tImg != NULL && tImg != nil) {[tImg release];}
	if (source_item != NULL && source_item != nil) {[source_item release];}
	if (cellSel != NULL && cellSel != nil) {[cellSel release];}
	if (cell != NULL && cell != nil) {[cell release];}*/

	NSLog(@"dis mis ================= mis2\n");
}

@end
