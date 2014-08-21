//
//  FeedItem.m
//  SiteFan
//
//  Created by Wiley Wimberly on 8/18/14.
//  Copyright (c) 2014 Warm Fuzzy Apps, LLC. All rights reserved.
//

#import "FeedItem.h"

@implementation FeedItem

- (instancetype)initWithTitle:(NSString *)title link:(NSURL *)link pubDate:(NSDate *)pubDate guid:(NSString *)guid {
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _title = [title copy];
    _link = link;
    _pubDate = pubDate;
    _guid = [guid copy];
    
    return self;
}

@end
