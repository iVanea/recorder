//
//  StatisticsController.h
//  CycleAlarm
//
//  Created by Symon on 4/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"
#import "GraphController.h"
#import "PlotItem.h"

@interface StatisticsController : UIViewController
<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITabBarItem *tbiStatistics;
	IBOutlet UIScrollView *scrollGraphView;
	GraphView *xGR;

	// core plot
	PlotItem                    *detailItem;
	UIView                      *hostingView;
	
	
	
	
	IBOutlet UIButton *bGraph;
	IBOutlet UIButton *clearStatistics;
	int iButtIdSelected;
	int selected;
	int selsection;
	
	int iSelStat;
	
	//IBOutlet UIButton *tBut;
	UIImageView *tImg;
	UIImageView *tImgL;
	
	NSMutableArray *arrayTable;
	NSMutableArray *arrayTableStat;
	UITableViewCell *cell;
	UITableViewCell *cellSel;
	
	IBOutlet UITableView *tableNew;
	IBOutlet UITableView *tableNewStat;
}

- (IBAction) actBstat: (id) sender;
- (IBAction) actBackOrClear: (id) sender;
- (IBAction) actClear: (id) sender;
- (IBAction) actGraphController:(id) sender;

- (IBAction) bbTwitter;
- (IBAction) bbFacebook;

@end
