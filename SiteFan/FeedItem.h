//
//  FeedItem.h
//  SiteFan
//
//  Created by Wiley Wimberly on 8/18/14.
//  Copyright (c) 2014 Warm Fuzzy Apps, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedItem : NSObject

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSURL *link;
@property (nonatomic, readonly) NSDate *pubDate;
@property (nonatomic, readonly) NSString *guid;

- (instancetype)initWithTitle:(NSString *)title link:(NSURL *)link pubDate:(NSDate *)pubDate guid:(NSString *)guid;

@end
