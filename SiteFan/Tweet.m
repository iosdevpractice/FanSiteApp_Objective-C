//
//  Tweet.m
//  SiteFan
//
//  Created by Wiley Wimberly on 8/18/14.
//  Copyright (c) 2014 Warm Fuzzy Apps, LLC. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (instancetype)initWithText:(NSString *)text createdDate:(NSDate *)createdDate url:(NSURL *)url tweetId:(NSString *)tweetId
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _text = [text copy];
    _createdDate = createdDate;
    _url = url;
    _tweetId = tweetId;
    
    return self;
}

@end
