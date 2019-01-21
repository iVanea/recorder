    //
//  StatisticsController.m
//  CycleAlarm
//
//  Created by Symon on 4/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StatisticsController.h"
#import "SteppedScatterPlot.h"

@implementation StatisticsController

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]



- (NSString *) saveFilePath: (int) poster
{
	NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	if (poster == 1) {
		return [[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"saveTimeAlarm.plist"];
	}
	if (poster == 8) {
		return [[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"saveArrayAllStatistics.plist"];
	}
	return 0;
}


- (IBAction) bbFacebook {
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"Copied to Clipboard" 												
						  message:@"The statistics has been COPIED."
						  delegate:self
						  cancelButtonTitle:@"Ok"
						  otherButtonTitles: nil];
	[alert show];	
	[alert release];
	
	[UIPasteboard generalPasteboard].string = @"statistics paste";
	[[UIApplication sharedApplication] openURL: [NSURL URLWithString: @"http://facebook.com"]];
}
- (IBAction) bbTwitter {
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"Copied to Clipboard" 												
						  message:@"The statistics has been COPIED."
						  delegate:self
						  cancelButtonTitle:@"Ok"
						  otherButtonTitles: nil];
	[alert show];	
	[alert release];
	
	[UIPasteboard generalPasteboard].string = @"statistics paste";
	[[UIApplication sharedApplication] openURL: [NSURL URLWithString: @"http://twitter.com"]];
}

- (IBAction) actBackOrClear: (id) sender {
	UIButton *bt = (UIButton *) sender;
	NSLog(@"battun clear or back tag: %i,\n", bt.tag);
	
	switch (bt.tag) {
		case 0:
			clearStatistics.tag = 1;
			iSelStat = 0;
			[clearStatistics setImage:[UIImage imageNamed:@"bStatClear.png"] forState:UIControlStateNormal];
			
			tableNew.hidden = NO;
			bGraph.hidden = YES;
			[tableNewStat removeFromSuperview];
			[tableNewStat release];
			tableNewStat = nil;
			break;
		case 1:
			NSLog(@"clear stat\n");
			// ============ code clear stat
			UIAlertView *alert = [[UIAlertView alloc]
								  initWithTitle:@"Confirm Delete" 												
								  message:@"Are you sure you want to DELETE the All Statistics?"
								  delegate:self
								  cancelButtonTitle:@"Cancel"
								  otherButtonTitles:@"Ok", nil];
			[alert show];	
			[alert release];
			break;
		default:
			break;
	}
	
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if ([actionSheet.title isEqualToString:@"Confirm Delete"]) {
		if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Ok"]) {
			//statistics in file deleted ====
			NSArray *values4 = [[NSArray alloc] initWithContentsOfFile:[self saveFilePath:8]];
			NSMutableArray *values3 = [[NSMutableArray alloc] initWithArray:values4];
			[values3 removeAllObjects];
			
			[values3 writeToFile:[self saveFilePath:8] atomically:YES]; // clear file saveAllStatisics.plist
			
			[values4 release];
			[values3 release];
			values4 = nil;
			values3 = nil;
			
			
			// audio record delete =========
			NSFileManager *fileManager = [NSFileManager defaultManager];
			NSString *str = DOCUMENTS_FOLDER;
			NSArray *arrFlags = [[NSArray alloc] initWithArray:[fileManager contentsOfDirectoryAtPath:[str stringByAppendingPathComponent:@""] error:nil]];
			
			//NSLog(@"arrFlags: %@ \n", arrFlags);
			
			for (int i=0; i<[arrFlags count]; i++) {
				if([[arrFlags objectAtIndex:i] hasPrefix:@"record_"]) {
					NSLog(@"arrFlags: %@ \n", [arrFlags objectAtIndex:i]);
					NSString *str5 = [NSString stringWithFormat:@"%@/%@", DOCUMENTS_FOLDER, [arrFlags objectAtIndex:i]];
					[fileManager removeItemAtPath:[[NSURL fileURLWithPath:str5] path] error:nil]; // remove files temporar
				}
			}
			
			tableNew.hidden = YES;
			[tableNew reloadData];
			[tableNewStat reloadData];
			
			[arrFlags release];
			arrFlags = nil;
			
		}
	}

}

- (IBAction) actClear:(id) sender {
	
	
}


- (IBAction) actGraphController:(id) sender {
	UIButton *bt = (UIButton *) sender;
	NSLog(@"battun tag graph: %i,\n", bt.tag);
	
	GraphController *h=[[GraphController alloc] initWithNibName:@"GraphController" bundle:[NSBundle mainBundle]];
	h.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	h.iIDarrayStat = bt.tag;
	
	[self presentModalViewController:h animated:YES];
	
	[h release];
	
}


- (void) actBstat: (id) sender {
	UIButton *bt = (UIButton *) sender;
	NSLog(@"battun tag: %i,\n", bt.tag);
	iButtIdSelected = bt.tag;
	iSelStat = 1;
	tableNew.hidden = YES;
	bGraph.hidden = NO;
    [bGraph.imageView setImage:[UIImage imageNamed:@"graff.png"]];
	bGraph.tag = bt.tag;
	clearStatistics.tag = 0;
	[clearStatistics setImage:[UIImage imageNamed:@"bStatViewBack.png"] forState:UIControlStateNormal];

	
	
	// start table new stat =====
	tableNewStat = [[UITableView alloc] initWithFrame:CGRectMake(0, 110, 320, 318) style:UITableViewStylePlain ];
	tableNewStat.delegate = self;
	tableNewStat.dataSource = self;
	
	tableNewStat.rowHeight = 36;
	tableNewStat.backgroundColor = [UIColor clearColor];
	tableNewStat.separatorColor = [UIColor clearColor];
	
	[self.view addSubview:tableNewStat];
	[self.view addSubview:clearStatistics];
	[tableNewStat reloadData];
	
	// end table new stat =======
}






- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger index[2];
	[indexPath getIndexes:index];
	printf(" sec = %d\n row = %d\n\n", index[0], index[1]);
	
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
	
	cell.textLabel.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
	
	
	
	if (iSelStat == 0) {
		UIImageView *imgLine = [[UIImageView alloc] init];
		[imgLine setImage:[UIImage imageNamed:@"arrow.png"]];
		imgLine.frame = CGRectMake(286, 4, 28, 28);
		[cell.contentView addSubview:imgLine];
		[imgLine release];
		
		UIView *tView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 36)];
		UIButton *tBut = [[UIButton alloc] init];	
//		[tBut setImage:[UIImage imageNamed:@"stattableBut2.png"] forState:UIControlStateNormal];
		tBut.frame = CGRectMake(0, 0, 320, 36);
		tBut.tag = ([arrayTable count] - indexPath.row - 1); // tag index path select / invert
		//NSLog(@"apth: %@\n", indexPath);
		[tBut addTarget:self action:@selector(actBstat:) forControlEvents:UIControlEventTouchUpInside];
		
		[tView addSubview:tBut];
		[cell addSubview:tView];
		
		[tBut release];
		[tView release];
		
		if (indexPath.row == 0) {
			tImgL = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableStatLine.png"]];
			tImgL.alpha = 0.3;
			tImgL.frame = CGRectMake(0, 0, 320, 3);
			[cell addSubview:tImgL];
			[tImgL release];
		}
		
		tImgL = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableStatLine.png"]];
		tImgL.alpha = 0.3;
		tImgL.frame = CGRectMake(0, 34, 320, 3);
		[cell addSubview:tImgL];
		[tImgL release];
	}
	if (iSelStat == 1) {
		UILabel *tLab = [[UILabel alloc] init];	
		tLab.backgroundColor = [UIColor clearColor];
		tLab.frame = CGRectMake(228, 6, 84, 22);
		tLab.tag = index[1]; // tag index path select
		
		tLab.text = [NSString stringWithFormat:@"%@", [[[arrayTable objectAtIndex:iButtIdSelected] objectAtIndex:0] objectAtIndex:(indexPath.row+1)]];
		//tLab.font = [UIFont fontWithName:@"Gothic" size:19];
		tLab.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
		tLab.font = [UIFont fontWithName:@"Helvetica" size:16];
		tLab.textAlignment = UITextAlignmentCenter;
		[cell addSubview:tLab];

		[tLab release];

		
		if (indexPath.row != 5) {
//			tImgL = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabble_cell_222.png"]];
//			tImgL.alpha = 0.3;
//			tImgL.frame = CGRectMake(0, -5, 320, 39);
//			[cell addSubview:tImgL];
//			[tImgL release];
		}
		
	}

	
	
	
	
	NSString *tempOrig, *tmpStringName;	

	
	switch (iSelStat) {
		case 0:
			tempOrig = @"       ";	
			tmpStringName = [NSString stringWithFormat:@"%@", [[[arrayTable objectAtIndex:([arrayTable count] - indexPath.row - 1)] objectAtIndex:0] objectAtIndex:0]];
			break;
		case 1:
			tempOrig = @"       ";	
			tmpStringName = [NSString stringWithFormat:@"  %@", [arrayTableStat objectAtIndex:indexPath.row]];
			
			break;
		default:
			break;
	}
	
	
	
	cell.textLabel.text = [tmpStringName stringByAppendingString: tempOrig];
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:16];

		
	return cell;
	[cell release];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	//return 20;
	if (section == 0) {
		if (iSelStat == 0) {
		return [arrayTable count];
		}
		if (iSelStat == 1) {
			return [arrayTableStat count];
		}
	}
	if (section == 1) {
		return 1;
	}
	return [arrayTable count];
	return 0;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;	
}






- (void) viewWillAppearX:(BOOL)animated {
	//SteppedScatterPlot *h=[[SteppedScatterPlot alloc] initWithNibName:@"SteppedScatterPlot" bundle:[NSBundle mainBundle]];
	//[h release];
	[self.view addSubview:hostingView];
	CPTheme *currentTheme;
	[detailItem renderInView:hostingView withTheme:currentTheme];
	
	NSLog(@" core plot \n");
	
}

- (void) viewWillAppear:(BOOL)animated {
	iSelStat = 0;
	bGraph.hidden = YES;
    [bGraph.imageView setImage:[UIImage imageNamed:@"graff.png"]];
	NSLog(@"will apaear Statistics\n");
	arrayTable = [[NSArray alloc] initWithContentsOfFile:[self saveFilePath:8]];
	arrayTableStat = [[NSArray alloc] initWithObjects:@"Falling asleep", @"Wakeup time", @"Total sleep time", @"Light sleep cycles", @"Deep sleep cycles", @"Noise stimuli", nil];
	
	// start table new =====
	tableNew = [[UITableView alloc] initWithFrame:CGRectMake(0, 110, 320, 313) style:UITableViewStylePlain ];
	tableNew.delegate = self;
	tableNew.dataSource = self;
	
	tableNew.rowHeight = 36;
	tableNew.backgroundColor = [UIColor clearColor];
	tableNew.separatorColor = [UIColor clearColor];
	
	[self.view addSubview:tableNew];
	[self.view addSubview:clearStatistics];
	[tableNew reloadData];
	
	// end table new =======
	
	
	
}



- (void) viewWillDisappear:(BOOL)animated {
	NSLog(@"will dispaear Statistics\n");
}
	
- (void) viewDidDisappear:(BOOL)animated {
	NSLog(@"viewDidDisappear");
	[clearStatistics setImage:[UIImage imageNamed:@"bStatClear.png"] forState:UIControlStateNormal];
	clearStatistics.tag = 1;
	
	[tableNew removeFromSuperview];
	[tableNew release];
	tableNew = nil;
	if (tableNewStat) {
		[tableNewStat removeFromSuperview];
		[tableNewStat release];
		tableNewStat = nil;
	}
	
	
	if (arrayTable) {
		[arrayTable release];
		arrayTable = nil;
	}
	if (arrayTableStat) {
		[arrayTableStat release];
		arrayTableStat = nil;
	}
}








// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	
}

// scrollview start===============

- (CGRect)centeredFrameForScrollView:(UIScrollView *)scroll andUIView:(UIView *)rView {
	CGSize boundsSize = scroll.bounds.size;
    CGRect frameToCenter = rView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    }
    else {
        frameToCenter.origin.x = 0;
    }
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    }
    else {
        frameToCenter.origin.y = 0;
    }
	
	return frameToCenter;
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
	xGR.frame = [self centeredFrameForScrollView:scrollView andUIView:xGR];;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return xGR;
}
// scrollview end===============




















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
