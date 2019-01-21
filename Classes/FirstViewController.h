//
//  FirstViewController.h
//  CycleAlarm
//
//  Created by Symon on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FirstViewController : UIViewController {

	IBOutlet UITabBarItem *tbiFirst;
	IBOutlet UIButton *bAlarmStart;
	
	
	IBOutlet UIDatePicker *myTimeAlarm;
	
	
}
@property (nonatomic, retain) UIButton *bAlarmStart;

- (IBAction) actAlarmStartFirst: (id) sender;

@end
