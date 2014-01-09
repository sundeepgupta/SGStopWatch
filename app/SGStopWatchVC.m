//
//  SGStopWatchVC.m
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 2013-08-15.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "SGStopWatchVC.h"
#import "SGStopWatch.h"


#define MAX_SECONDS 5999 //99:59



@interface SGStopWatchVC () <SGStopWatchDelegate>
@property (strong, nonatomic) SGStopWatch *stopWatch;
@property (strong, nonatomic) IBOutlet UIButton *pauseButton;
@property (strong, nonatomic) IBOutlet UILabel *clockLabel;
@end


@implementation SGStopWatchVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupStopWatch];
}

- (void)setupStopWatch {
    self.stopWatch = [[SGStopWatch alloc] initWithDelegate:self];
}



#pragma mark - Timer Controls
- (IBAction)pauseButtonPress:(id)sender {
    [self toggleTimer];
}
- (void)toggleTimer {
    STOPWATCH_STATUS status = [self.stopWatch status];
    if (status == RUNNING) {
        [self pauseTimer];
    } else {
        [self startTimerWithStatus:status];
    }
}
- (void)pauseTimer {
    [self.stopWatch pause];
    [self changeButtonToContinueTimer];
}

- (void)startTimerWithStatus:(STOPWATCH_STATUS)status {
    if (status == PAUSED) {
        [self.stopWatch unpause];
    } else { //status is stopped
        [self.stopWatch startFromStopped];
    }
    [self changeButtonToPauseTimer];
}


- (void)changeButtonToContinueTimer {
    [self setPauseButtonImageWithName:@"play.png"];
}
- (void)changeButtonToPauseTimer {
    [self setPauseButtonImageWithName:@"pause.png"];
}
- (void)setPauseButtonImageWithName:(NSString *)name {
    UIImage *image = [UIImage imageNamed:name];
    [self.pauseButton setBackgroundImage:image forState:UIControlStateNormal];
}

- (IBAction)stopButtonPress:(id)sender {
    [self.stopWatch stop];
    [self updateTimerLabel];
    [self changeButtonToContinueTimer];
}



#pragma mark - Stopwatch Delegate
- (void)didUpdateWithSeconds:(NSInteger)seconds {
    [self updateTimerLabel];
}

- (void)updateTimerLabel {
    self.clockLabel.text = [self stringForSeconds:self.stopWatch.seconds];
}

- (NSString *)stringForSeconds:(NSInteger)seconds {
    NSInteger adjustedSeconds = [self adjustedSeconds:seconds];
    NSInteger minutes = [self minutesForSeconds:adjustedSeconds];
    NSInteger remainderSeconds = [self remainderSecondsForSeconds:adjustedSeconds];
    NSString *string = [NSString stringWithFormat:@"%02i:%02i", minutes, remainderSeconds];
    return string;
}
- (NSInteger)adjustedSeconds:(NSInteger)seconds {
    if (seconds < 0) {
        seconds = 0;
    } else if (seconds > MAX_SECONDS) {
        seconds = MAX_SECONDS;
    }
    return seconds;
}
- (NSInteger)minutesForSeconds:(NSInteger)seconds {
    NSInteger minutes = floor(seconds/60);
    return minutes;
}
- (NSInteger)remainderSecondsForSeconds:(NSInteger)seconds {
    NSInteger remainderSeconds = seconds%60;
    return remainderSeconds;
}


@end
