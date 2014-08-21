//
//  TweetsViewController.m
//  SiteFan
//
//  Created by Wiley Wimberly on 8/18/14.
//  Copyright (c) 2014 Warm Fuzzy Apps, LLC. All rights reserved.
//

#import "TweetsViewController.h"
#import "TweetStore.h"
#import "Tweet.h"
#import "WebViewController.h"

@interface TweetsViewController ()

@property (nonatomic, strong) TweetStore *store;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation TweetsViewController

#pragma mark - Accessors

- (TweetStore *)store
{
    if (!_store) {
        _store = [[TweetStore alloc] init];
    }
    return _store;
}

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.timeStyle = NSDateFormatterShortStyle;
        _dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    }
    return _dateFormatter;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.store fetchTimelineForUser:@"@iosdevpractice" completion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.store.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    Tweet *item = self.store.tweets[indexPath.row];
    cell.textLabel.text = item.text;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    [cell.textLabel sizeToFit];
    cell.detailTextLabel.text = [self.dateFormatter stringFromDate:[item createdDate]];
    
    return cell;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tweet *item = self.store.tweets[indexPath.row];
    if ([self canOpenTwitter]) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"twitter://status?id=%@", item.tweetId]];
        NSLog(@"url: %@", url);
        [[UIApplication sharedApplication] openURL:url];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else {
        WebViewController *webViewController = [[WebViewController alloc] init];
        webViewController.url = item.url;
        [self.navigationController pushViewController:webViewController animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tweet *item = self.store.tweets[indexPath.row];
    NSString *text = item.text;
    UIFont *font = [UIFont systemFontOfSize:17.0];
    CGSize textSize = CGSizeMake(280, CGFLOAT_MAX);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [text boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSParagraphStyleAttributeName: [paragraphStyle copy], NSFontAttributeName: font} context:nil].size;
    CGFloat padding = 40.0;
    CGFloat height = MAX(ceil(size.height) + padding, 44.0);
    return height;
}

#pragma mark - helpers

- (BOOL)canOpenTwitter {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]];
}

@end
