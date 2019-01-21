//
//  AlarmViewController.m
//  CycleAlarm
//
//  Created by Symon on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AlarmViewController.h"
#import "ClockViews.h"
#import "GoClockController.h"


CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};


@implementation AlarmViewController
@synthesize myTimeAlarm;

- (NSString *) saveFilePath: (int) poster
{
	NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	if (poster == 1) {
		return [[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"saveTimeAlarm.plist"];
	}
	if (poster == 2) {
		return [[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"saveTimeCycle.plist"];
	}
	return 0;
}

- (void)applicationWillTermiante: (UIApplication *)application {
	NSArray *values = [[NSArray alloc] initWithObjects:myTimeAlarm.date, [NSString stringWithFormat:@"%i", iCycle], nil];
 [values writeToFile:[self saveFilePath:1] atomically:YES];
	[values release];
}




- (void)imageViewApear:(UIImageView *)imageView isApear:(int)isApear {

	imageView.alpha = !isApear;
	
	//begin animations
	[UIImageView beginAnimations:nil context:NULL];
	[UIImageView setAnimationDuration:0.6];
	//[UIImageView setAnimationBeginsFromCurrentState:YES];
	[UIImageView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIImageView setAnimationRepeatAutoreverses:0];
	[UIImageView setAnimationRepeatCount:1];
	imageView.alpha=isApear;
	[UIImageView commitAnimations];	
}



- (IBAction) actApearAlert:(id) Sender {
	NSLog(@"iCycle: %i", iCycle);
	//=language
	NSString *enRu = @"en";
	NSString * languageAllDevice = [[NSLocale preferredLanguages] objectAtIndex:0];
	NSString  *language = [[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode];
	NSString  *countryCode = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
	NSLog(@"language: allLanguage: %@, lang: %@, reg: %@", languageAllDevice, language, countryCode);
	if ([languageAllDevice isEqual:@"ru_Ru"] || [languageAllDevice isEqual:@"ru"] || [languageAllDevice isEqual:@"RU"]
		|| [language isEqual:@"ru_Ru"] || [language isEqual:@"ru"] || [language isEqual:@"RU"] 
		|| [countryCode isEqual:@"ru_Ru"] || [countryCode isEqual:@"ru"] || [countryCode isEqual:@"RU"] ) {
		enRu = @"ru";
	}
	//=
	imgAlertView.image = [UIImage imageNamed:[NSString stringWithFormat:@"alert_%@_%i.png", enRu, iCycle]];
	imgAlertView.frame = CGRectMake(0, 0, 320, 480);
	
	if (imgAlertView.alpha == 1) {
		[self imageViewApear:imgAlertView isApear:0];
	} else if (imgAlertView.alpha == 0) {
		[self imageViewApear:imgAlertView isApear:1];
	}
}


- (IBAction) actCycleChange: (id) sender {
	UIButton *bt = (UIButton *) sender;
//	if (bt.tag == 0) {
//		if (iCycle <= 1) {
//			iCycle = 5;
//		}
//		iCycle -= 1;
//	}
//	if (bt.tag == 1) {
//		if (iCycle >= 4) {
//			iCycle = 0;
//		}
//		iCycle += 1;
//	}
    NSLog(@"tag %d", bt.tag);
    switch (bt.tag) {
        case 1:
            btnAlarm.selected = !btnAlarm.selected;
            if (btnAlarm.isSelected) {NSLog(@"da");
            }else{NSLog(@"nu");}
            break;
        case 2:
            btnMic.selected = !btnMic.selected;
            break;
        case 3:
            btnStatistic.selected = !btnStatistic.selected;
        default:
            break;
    }
    
    if (btnAlarm.isSelected && btnMic.isSelected && btnStatistic.isSelected) {
        iCycle = 4;
    }
    else if (btnMic.isSelected && btnStatistic.isSelected){
        iCycle = 3;
    }else if (btnAlarm.isSelected && btnStatistic.isSelected){
        iCycle = 2;
    }else if (btnAlarm.isSelected){
        iCycle = 1;
    }
//    else{iCycle = 4;
//        btnAlarm.selected = YES;
//        btnMic.selected = YES;
//        btnStatistic.selected = YES;
//    }
//    
    
    
    
    
	//NSLog(@"%i", iCycle);
//	switch (iCycle) {
//        case 1:
//			imgCycleView.image = [UIImage imageNamed:@"imgGoClockViewLightClock1.png"];
//			break;
//		case 2:
//			imgCycleView.image = [UIImage imageNamed:@"imgGoClockViewLightClockStat1.png"];
//			break;
//		case 3:
//			imgCycleView.image = [UIImage imageNamed:@"imgGoClockViewStatSun1.png"];
//			break;
//		case 4:
//			imgCycleView.image = [UIImage imageNamed:@"imgGoClockViewFull1.png"];
//			break; 
//		default:
//			break;
//	}
	
	//=imgApear change
//	if (imgAlertView.alpha == 0) {
//		[self imageViewApear:imgAlertView isApear:0];
//	} else {
//		[self imageViewApear:imgAlertView isApear:!imgAlertView.alpha];
//	}
//	[self actApearAlert:nil];
	//=
}



- (IBAction) actAlarmStartThird: (id) sender {
	
	[self applicationWillTermiante:nil];
		
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateStyle = NSDateFormatterMediumStyle;
	NSString * text = [NSString stringWithFormat:@"%@", [df stringFromDate:myTimeAlarm.date]];
	

	[df setDateFormat:@"HH"];	
	int hourS = [[df stringFromDate:myTimeAlarm.date] intValue];
	
	[df setDateFormat:@"mm"];
	int minS = [[df stringFromDate:myTimeAlarm.date] intValue];	
	
		
	[df setDateFormat:@"HH"];	
	int hourD = [[df stringFromDate:[NSDate date]] intValue];	
	
	[df setDateFormat:@"mm"];
	int minD = [[df stringFromDate:[NSDate date]] intValue];	
	
	int hA = hourS;	
	if(hourS >= 12){ // convert to AM/PM
		if(hourS != 12){
			hA = hourS - 12;
		}
	}
	else{
		if(hourS == 0){
			hA = 12;
		}
	}
	NSString *hAs = [NSString stringWithFormat:@"%i", hA];
	NSString *minAs = [NSString stringWithFormat:@"%i", minS];
	
	if (hA <= 9) {
		hAs = [NSString stringWithFormat:@"0%i", hA];
	}
	if (minS <= 9) {
		minAs = [NSString stringWithFormat:@"0%i", minS];
	}
	
	
	lAlarm.text = [NSString stringWithFormat:@"%@:%@", hAs, minAs];

	NSLog(@"\n heiii week \n");	
	NSLog(@"\n picker date: %@ \n time: %@\n hours: %d\n min: %d\n", myTimeAlarm.date, text, hourS, minS);	

	[df release];	
	
	if (hourD == hourS && minD==minS) {
		
	} else {
		
			
		
		GoClockController *h=[[GoClockController alloc] initWithNibName:@"GoClockController" bundle:[NSBundle mainBundle]];
		h.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
		h.hourS = hourS;
		h.minS = minS;
		h.iCycle = iCycle;
		h.i4View = iCycle;

		[self presentModalViewController:h animated:YES];
		
		[h release];
		
		
		
		

	}
	
	
	

}



// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/




// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	   [super viewDidLoad];
	NSLog(@"viewDidLoad ============== alarm");

	imgAlertView.alpha = 0;		
	myTimeAlarm.backgroundColor = [UIColor clearColor];
	//[(UIView*)[[myTimeAlarm subviews] objectAtIndex:0] setAlpha:0.2f];
	
	//timeAlarmView.frame = CGRectMake(0, 0, 320, 480);
	timeAlarmView.hidden = YES;
	[self.view addSubview:timeAlarmView];
	
	NSString *myPath = [self saveFilePath:1];
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:myPath];
	
	if (fileExists)
	{
		NSArray *values = [[NSArray alloc] initWithContentsOfFile:myPath];
		//myText.text = [values objectAtIndex:0];
		myTimeAlarm.date = [values objectAtIndex:0];
		NSString *tS =  [NSString stringWithFormat:@"%@", [values objectAtIndex:1]];
		iCycle = [tS intValue];
		[values release];
		
	}
	else {
		NSLog(@"\n file isn't\n");
	}
    btnAlarm.selected = YES;
    btnMic.selected = NO;
    btnStatistic.selected = NO;
	if (!iCycle) {iCycle = 4;}
	switch (iCycle) {
        case 1:
//			imgCycleView.image = [UIImage imageNamed:@"imgGoClockViewLightClock1.png"];
            btnAlarm.selected = YES;
            btnMic.selected = NO;
            btnStatistic.selected = NO;
			break;
		case 2:
//			imgCycleView.image = [UIImage imageNamed:@"imgGoClockViewLightClockStat1.png"];
            btnAlarm.selected = YES;
            btnMic.selected = NO;
            btnStatistic.selected = YES;
            break;
		case 3:
//			imgCycleView.image = [UIImage imageNamed:@"imgGoClockViewStatSun1.png"];
            btnAlarm.selected = NO;
            btnMic.selected = YES;
            btnStatistic.selected = YES;
			break;
		case 4:
//			imgCycleView.image = [UIImage imageNamed:@"imgGoClockViewFull1.png"];
            btnAlarm.selected = YES;
            btnMic.selected = YES;
            btnStatistic.selected = YES;
			break;
		default:
			break;
	}
	
	//NSString *tdateAM = [myTimeAlarm.date descriptionWithCalendarFormat:@"%p" timeZone:nil locale:nil];
	//NSLog(@"%@", tdateAM);
		
	if ([@"AM" isEqualToString:@"AM"] || [@"PM" isEqualToString:@"PM"]) { // incorect AM detected or 24 h
		iRama24AM.image = [UIImage imageNamed:@"bg_alarm.png"]; //rama24a.png
	} else {
		iRama24AM.image = [UIImage imageNamed:@"alarm_2.png"];
	}
	
	/*	
	NSLocale *frLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"] autorelease];
	NSString *displayNameString = [frLocale displayNameForKey:NSLocaleIdentifier value:@"fr_FR"];
	NSLog(@"displayNameString fr_FR: %@", displayNameString);
	displayNameString = [frLocale displayNameForKey:NSLocaleIdentifier value:@"en_US"];
	NSLog(@"displayNameString en_US: %@", displayNameString);
	
	[myTimeAlarm.locale displayNameForKey:NSLocaleIdentifier value:@"en_US"];
	*/
	
	UIApplication *myApp = [UIApplication sharedApplication];	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(applicationWillTermiante:) 
												 name:UIApplicationWillTerminateNotification
											   object:myApp];
    
	
}



- (void)viewWillAppear:(BOOL)animated {
	NSLog(@"viewWillAppear alarmController");
	int Thirst = [[NSUserDefaults standardUserDefaults] integerForKey:@"TheThirstDateRunThis"];
	if (Thirst == 0) {
		printf("the thirst date load this (Alarm)");
		
		//=
//		[self performSelector:@selector(actApearAlert:) withObject:nil afterDelay:0.5];
//		[self performSelector:@selector(actApearAlert:) withObject:nil afterDelay:6.0];
		//=
		
		[[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"TheThirstDateRunThis"];
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
