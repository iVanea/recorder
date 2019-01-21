//
//  RecorderLoad.h
//  CycleAlarm
//
//  Created by Symon on 5/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecordObject.h"
#import "SCListener.h" // Remember to link to AudioToolbox.framework.

@interface RecorderLoad : NSObject {
	RecordObject *hRecord;
	
	NSTimer *timeListener;
	NSTimer *timeListener5sec;
	NSTimer *timerRecord;
	
	NSDate *dateHist;
	
	NSTimeInterval t1970History;
	NSTimeInterval t1970start;
	
	NSMutableArray *arrMut;
	NSMutableArray *arrMutRecord;
	
	
	float f5sec;
	float fMedia5sec;
	
	float fAverageMax;
	
	int iRecordStoped;
	
	int i5secNum;
	int iRecordBool;
	int iRecordCount;
	float fiMinNum;
	
}
@property (nonatomic, assign) int iRecordStoped;

- (int) funcReturnRecordCount;
- (void) ObjectLoad;
- (void) ObjectUnLoad;
- (NSMutableArray *) funcReturnSaveArrInFile;
- (NSMutableArray *) funcReturnNoisePathNameFileArray;

@end
