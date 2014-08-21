//
//  FeedViewController.m
//  SiteFan
//
//  Created by Wiley Wimberly on 8/18/14.
//  Copyright (c) 2014 Warm Fuzzy Apps, LLC. All rights reserved.
//

#import "FeedViewController.h"
#import "FeedStore.h"
#import "FeedItem.h"
#import "WebViewController.h"

@interface FeedViewController ()

@property (nonatomic, strong) FeedStore *store;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation FeedViewController

#pragma mark - Accessors

- (FeedStore *)store
{
    if (!_store) {
        _store = [[FeedStore alloc] init];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *url = [[NSURL alloc] initWithString:@"http://www.iosdevpractice.com/feed.xml"];
    [self.store fetchWithURL:url completion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.store.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    FeedItem *item = self.store.items[indexPath.row];
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = [self.dateFormatter stringFromDate:item.pubDate];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedItem *item = self.store.items[indexPath.row];
    WebViewController *webViewController = [[WebViewController alloc] init];
    webViewController.url = item.link;
    [self.navigationController pushViewController:webViewController animated:YES];
}

@end
