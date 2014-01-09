//
//  SGStopWatch.m
//  SGStopWatch
//
//  Created by Sundeep Gupta on 2013-08-16.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "SGStopWatch.h"


#define SECONDS_INTERVAL 1


@interface SGStopWatch()
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic, readwrite) NSDate *startDate;
@property (strong, nonatomic) NSDate *pauseDate;
@end


@implementation SGStopWatch

#pragma mark - Init Methods
- (instancetype)initWithDelegate:(id<SGStopWatchDelegate>)delegate {
    self = [self init];
    self.delegate = delegate;
    return self;
}

- (instancetype)initWithNotificationName:(NSString *)notificationName notificationInfoKey:(NSString *)notificationInfoKey {
    self = [self init];
    self.notificationName = notificationName;
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self resetSeconds];
    }
    return self;
}



#pragma mark - Setup
- (void)resetSeconds {
    self.seconds = -1;
}

- (void)startFromStopped {
    [self initializeTimer];
    [self saveStartDate];
}
- (void)initializeTimer {
    self.timer = [NSTimer timerWithTimeInterval:SECONDS_INTERVAL target:self selector:@selector(updateSeconds) userInfo:nil repeats:YES];
    NSRunLoop *currentRunLoop = [NSRunLoop currentRunLoop];
    [currentRunLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)saveStartDate {
    self.startDate = [NSDate date];
}



#pragma mark - Controls
- (void)start {
    STOPWATCH_STATUS status = [self status];
    if (status == PAUSED) {
        [self unpause];
    } else {
        [self startFromStopped];
    }
}

- (void)pause {
    [self destroyTimer];
    self.pauseDate = [NSDate date];
}

- (void)unpause {
    [self setupStartDateForUnpause];
    [self initializeTimer];
}
     
- (void)setupStartDateForUnpause {
    NSDate *currentDate = [NSDate date];
    NSDate *adjustedStartDate = [currentDate dateByAddingTimeInterval:-self.seconds];
    self.startDate = adjustedStartDate;
}

- (void)stop {
    [self destroyTimer];
    [self resetSeconds];
}
- (void)destroyTimer {
    [self.timer invalidate];
    self.timer = nil;
}


- (STOPWATCH_STATUS)status {
    STOPWATCH_STATUS status;
    if (self.seconds == -1) {
        status = STOPPED;
    } else if (!self.timer) {
        status = PAUSED;
    } else {
        status = RUNNING;
    }
    return status;
}



#pragma mark - Update time
- (void)updateSeconds {
    NSTimeInterval secondsElasped = -[self.startDate timeIntervalSinceNow];
    self.seconds = round(secondsElasped);

    if ([self notifactionInfoIsValid]) {
        [self postNotification];
    }

    if (self.delegate) {
        [self callDelegate];
    }

}

- (BOOL)notifactionInfoIsValid {
    BOOL isValid = NO;
    if ([self isValidString:self.notificationName]  &&  [self isValidString:self.notificationInfoKey]) {
        isValid = YES;
    }
    return isValid;
}
- (BOOL)isValidString:(NSString *)string {
    BOOL isValid = NO;
    if ([string isKindOfClass:[NSString class]]  &&  string.length > 0) {
        isValid = YES;
    }
    return isValid;
}

- (void)postNotification {
    NSDictionary *info = [self notificationInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:self.notificationName object:self userInfo:info];
}

- (void)callDelegate {
    if (self.delegate) {
        [self.delegate didUpdateWithSeconds:self.seconds];
    }
}

- (NSDictionary *)notificationInfo {
    NSNumber *secondsNumber = [NSNumber numberWithInteger:self.seconds];
    NSDictionary *info = @{self.notificationInfoKey:secondsNumber};
    return info;
}




@end
