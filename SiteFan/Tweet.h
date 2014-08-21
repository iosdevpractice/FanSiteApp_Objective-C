//
//  Tweet.h
//  SiteFan
//
//  Created by Wiley Wimberly on 8/18/14.
//  Copyright (c) 2014 Warm Fuzzy Apps, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : NSObject

@property (nonatomic, readonly) NSString *text;
@property (nonatomic, readonly) NSDate *createdDate;
@property (nonatomic, readonly) NSURL *url;
@property (nonatomic, readonly) NSString *tweetId;

- (instancetype)initWithText:(NSString *)text createdDate:(NSDate *)createdDate url:(NSURL *)url tweetId:(NSString *)tweetId;

@end
