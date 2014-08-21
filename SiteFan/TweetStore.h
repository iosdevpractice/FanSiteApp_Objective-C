//
//  TweetStore.h
//  SiteFan
//
//  Created by Wiley Wimberly on 8/18/14.
//  Copyright (c) 2014 Warm Fuzzy Apps, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TweetStore : NSObject

@property (nonatomic, readonly) NSArray* tweets;

- (void)fetchTimelineForUser:(NSString *) username completion:(void (^)(void))completion;

@end
