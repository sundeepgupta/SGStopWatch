//
//  SGStopWatch.h
//  SGStopWatch
//
//  Created by Sundeep Gupta on 2013-08-16.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, STOPWATCH_STATUS) {
    STOPPED,
    PAUSED,
    RUNNING,
};


@protocol SGStopWatchDelegate <NSObject>
@required
- (void)didUpdateWithSeconds:(NSInteger)seconds;
@end


@interface SGStopWatch : NSObject
@property NSInteger seconds;  //TODO: Make readonly publicly
@property (weak, nonatomic) id<SGStopWatchDelegate> delegate;
@property (strong, nonatomic, readonly) NSDate *startDate;
@property (nonatomic, strong) NSString *notificationName;
@property (nonatomic, strong) NSString *notificationInfoKey;

- (instancetype)initWithDelegate:(id<SGStopWatchDelegate>)delegate;
- (instancetype)initWithNotificationName:(NSString *)notificationName notificationInfoKey:(NSString *)notificationInfoKey;
- (void)startFromStopped;
- (void)start;
- (void)pause;
- (void)unpause;
- (void)stop;
- (STOPWATCH_STATUS)status;
@end


