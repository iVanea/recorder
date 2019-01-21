//
//  FirstViewController.m
//  CycleAlarm
//
//  Created by Symon on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"


@implementation FirstViewController
@synthesize bAlarmStart;

- (NSString *) saveFilePath
{
	NSArray *pathArray =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"saveTimeAlarm.plist"];
}

- (void)applicationWillTermiante: (UIApplication *)application {
	NSArray *values = [[NSArray alloc] initWithObjects:myTimeAlarm.date, nil];
	[values writeToFile:[self saveFilePath] atomically:YES];
	[values release];
}


- (IBAction) actAlarmStartFirst: (id) sender{
	
	NSLog(@"\n heiii \n");	
	
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit| NSWeekCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
	NSDate *date = [NSDate date];
	NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];

	
	
	NSInteger second = [dateComponents second];
	
	 NSDateFormatter *dateformater = [[NSDateFormatter alloc]init];
	 [dateformater setDateFormat:@"YYYY"];
	 int yearS = [[dateformater stringFromDate:[NSDate date]] intValue];
	
	 [dateformater setDateFormat:@"MM"];
	 int monthS = [[dateformater stringFromDate:[NSDate date]] intValue];
	
	 [dateformater setDateFormat:@"HH"];	
	 int hourS = [[dateformater stringFromDate:[NSDate date]] intValue];	
	
	 [dateformater setDateFormat:@"mm"];
	 int minS = [[dateformater stringFromDate:[NSDate date]] intValue];	
	
	[dateformater setDateFormat:@"LLLL"];
	NSString *lS = [dateformater stringFromDate:[NSDate date]];	
	
	[dateformater setDateFormat:@"w"];
	NSString *fS = [dateformater stringFromDate:[NSDate date]];	
	
	
	NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
	
	 NSLog(@"1970: %f,\n month: %d\n hour: %d,\n min: %d,\n Year: %d,\n sec: %d,\n f: %@,\n l: %@,\n", time, monthS, hourS, minS, yearS, second, fS, lS);
}



/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/







// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	NSString *myPath = [self saveFilePath];
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:myPath];
	
	if (fileExists)
	{
		NSArray *values = [[NSArray alloc] initWithContentsOfFile:myPath];
		//myText.text = [values objectAtIndex:0];
		myTimeAlarm.date = [values objectAtIndex:0];
		[values release];
	}
	
	UIApplication *myApp = [UIApplication sharedApplication];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(applicationWillTermiante:) 
												 name:UIApplicationWillTerminateNotification
											   object:myApp];
	
    [super viewDidLoad];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
