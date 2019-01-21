//
//  InstructionsController.h
//  CycleAlarm
//
//  Created by Symon on 3/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InstructionsController : UIViewController
<UIScrollViewDelegate>{

	IBOutlet UITabBarItem *tbiInstruction;
	IBOutlet UIScrollView *instrScrollView;
	
	IBOutlet UIImageView *imgInstr;
	IBOutlet UIImageView *imgHeaderView;
	IBOutlet UIImageView *imgBack;
	IBOutlet UIImageView *imgScrollView;
	
	int iEnRu;
}

@end
