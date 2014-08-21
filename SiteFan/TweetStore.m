//
//  TweetStore.m
//  SiteFan
//
//  Created by Wiley Wimberly on 8/18/14.
//  Copyright (c) 2014 Warm Fuzzy Apps, LLC. All rights reserved.
//

#import <Social/Social.h>
#import <Accounts/Accounts.h>

#import "TweetStore.h"
#import "Tweet.h"
#import "SimpleAlert.h"

@interface TweetStore ()

@property (nonatomic, copy) void (^completion)(void);
@property (nonatomic, strong) NSMutableArray *privateItems;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) ACAccountStore *accountStore;

@end

@implementation TweetStore

#pragma mark - Accessors

- (NSArray *)tweets {
    return [self.privateItems copy];
}

- (NSMutableArray *)privateItems {
    if (!_privateItems) {
        _privateItems = [[NSMutableArray alloc] init];
    }
    return _privateItems;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"EEE MMM dd HH:mm:ss ZZ yyyy";
    }
    return _dateFormatter;
}

- (ACAccountStore *)accountStore {
    if (!_accountStore) {
        _accountStore = [[ACAccountStore alloc] init];
    }
    return _accountStore;
}

#pragma mark - Helpers

- (BOOL)userHasAccessToTwitter
{
    return [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
}

#pragma mark - Public Methods

- (void)fetchTimelineForUser:(NSString *) username completion:(void (^)(void))completion
{
    self.completion = completion;
    
    if (![self userHasAccessToTwitter]) {
        [SimpleAlert showAlertWithTitle:@"Twitter Access" message:@"Twitter access is unavailable."];
        return;
    }
    
    ACAccountType *twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [self.accountStore requestAccessToAccountsWithType:twitterAccountType options:NULL completion:^(BOOL granted, NSError *error) {
        
        if (!granted) {
            [SimpleAlert showAlertWithTitle:@"Error" message:[error localizedDescription]];
            return;
        }
        
        NSArray *twitterAccounts = [self.accountStore accountsWithAccountType:twitterAccountType];
        NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/user_timeline.json"];
        NSDictionary *params = @{@"screen_name": username,
                                 @"include_rts": @"1",
                                 @"trim_user": @"1",
                                 @"count": @"20"};
        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:url parameters:params];
        
        [request setAccount:[twitterAccounts lastObject]];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            if (!responseData) {
                [SimpleAlert showAlertWithTitle:@"Error" message:@"No response data."];
                return;
            }
            if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                NSError *jsonError;
                NSArray *timelineData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
                if (timelineData) {
                    NSLog(@"response: %@", urlResponse);
                    NSLog(@"content: %@", timelineData);
                    for (NSDictionary *entry in timelineData) {
                        
                        NSString *text = [[entry[@"text"] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
                        NSDate *created = [self.dateFormatter dateFromString:entry[@"created_at"]];
                        NSString *tweetId = entry[@"id_str"];
                        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/%@/status/%@", username, tweetId]];
                        Tweet *tweet = [[Tweet alloc] initWithText:text createdDate:created url:url tweetId:tweetId];
                        [self.privateItems addObject:tweet];
                    }
                    if (completion) {
                        completion();
                    }
                } else {
                    [SimpleAlert showAlertWithTitle:@"Error" message:[jsonError localizedDescription]];
                }
            } else {
                [SimpleAlert showAlertWithTitle:@"Error" message:[NSString stringWithFormat:@"Response code: %@", @(urlResponse.statusCode)]];
            }
        }];
    }];    
}

@end
