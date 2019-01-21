
#import "DeepSleepPreventer.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@implementation DeepSleepPreventer


@synthesize audioPlayer;
@synthesize preventSleepTimer;

- (id)init {
    if ((self = [super init])) {
		[self setUpAudioSession];
		NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"noSound" ofType:@"wav"];
		NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath];
		self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL
																  error:nil];
		[fileURL release];
		[self.audioPlayer prepareToPlay];
		[self.audioPlayer setVolume:0.0];
	}
    return self;
}

- (void)dealloc {
	[preventSleepTimer release];
	[audioPlayer release];
	[super dealloc];
}
- (void)playPreventSleepSound {
	[self.audioPlayer play];
}


- (void)startPreventSleep {
	self.preventSleepTimer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:0]
													  interval:5.0
														target:self
													  selector:@selector(playPreventSleepSound)
													  userInfo:nil
													   repeats:YES];
	NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
	[runLoop addTimer:self.preventSleepTimer forMode:NSDefaultRunLoopMode];
}


- (void)stopPreventSleep {
	[self.preventSleepTimer invalidate];
	self.preventSleepTimer = nil;
}

- (void)setUpAudioSession {
		AudioSessionInitialize (
			NULL,							// Use NULL to use the default (main) run loop.
			NULL,							// Use NULL to use the default run loop mode.
			NULL,							// A reference to your interruption listener callback function. See “Responding to Audio Session Interruptions” for a description of how to write and use an interruption callback function.
			NULL							// Data you intend to be passed to your interruption listener callback function when the audio session object invokes it.
		);
		OSStatus activationResult = 0;
		activationResult = AudioSessionSetActive(true);
		if (activationResult)
			NSLog(@"AudioSession is active");
		UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;	// Defines a new variable of type UInt32 and initializes it with the identifier 
																		// for the category you want to apply to the audio session.
		AudioSessionSetProperty (
			kAudioSessionProperty_AudioCategory,						// The identifier, or key, for the audio session property you want to set.
			sizeof(sessionCategory),									// The size, in bytes, of the property value that you are applying.
			&sessionCategory											// The category you want to apply to the audio session.
		);
		OSStatus propertySetError = 0;
		UInt32 allowMixing = true;
		propertySetError =	AudioSessionSetProperty (
								kAudioSessionProperty_OverrideCategoryMixWithOthers,	// The identifier, or key, for the audio session property you want to set.
								sizeof(allowMixing),									// The size, in bytes, of the property value that you are applying.
								&allowMixing											// The value to apply to the property.
							);
		if (propertySetError)
			NSLog(@"Error setting kAudioSessionProperty_OverrideCategoryMixWithOthers: %ld", propertySetError);
}

@end