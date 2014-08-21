//
//  FeedStore.h
//  SiteFan
//
//  Created by Wiley Wimberly on 8/18/14.
//  Copyright (c) 2014 Warm Fuzzy Apps, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedStore : NSObject

@property (nonatomic, readonly) NSArray* items;

- (void)fetchWithURL:(NSURL *) url completion:(void (^)(void))completion;

@end
