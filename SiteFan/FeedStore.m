//
//  FeedStore.m
//  SiteFan
//
//  Created by Wiley Wimberly on 8/18/14.
//  Copyright (c) 2014 Warm Fuzzy Apps, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FeedStore.h"
#import "FeedItem.h"
#import "SimpleAlert.h"

@interface FeedStore () <NSXMLParserDelegate>

@property (nonatomic, copy) void (^completion)(void);

@property (nonatomic, strong) NSMutableArray *privateItems;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (nonatomic, copy) NSString *titleBuffer;
@property (nonatomic, copy) NSString *linkBuffer;
@property (nonatomic, copy) NSString *pubDateBuffer;
@property (nonatomic, copy) NSString *guidBuffer;

@property (nonatomic, copy) NSString *element;

@end

@implementation FeedStore

#pragma mark - Accessors

- (NSArray *)items {
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
        _dateFormatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss ZZ";
    }
    return _dateFormatter;
}

#pragma mark - Public Methods

- (void)fetchWithURL:(NSURL *)url completion:(void (^)(void))completion {
    
    self.completion = completion;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (error) {
            [SimpleAlert showAlertWithTitle:@"Error" message:[error localizedDescription]];
            return;
        }
        
        NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"response: %@", response);
        NSLog(@"content: %@", content);
        
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
        parser.delegate = self;
        parser.shouldResolveExternalEntities = NO;
        if (![parser parse]) {
            [SimpleAlert showAlertWithTitle:@"Error" message:@"Unable to parse feed."];
        };
    }];
    [task resume];
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    if (!elementName) {
        return;
    }
    
    self.element = elementName;
    if ([self.element isEqualToString:@"item"]) {
        self.titleBuffer = @"";
        self.linkBuffer = @"";
        self.pubDateBuffer = @"";
        self.guidBuffer = @"";
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([self.element isEqualToString:@"title"]) {
        self.titleBuffer = [self.titleBuffer stringByAppendingString:string];
    } else if ([self.element isEqualToString:@"link"]) {
        self.linkBuffer = [self.linkBuffer stringByAppendingString:string];
    } else if ([self.element isEqualToString:@"pubDate"]) {
        self.pubDateBuffer = [self.pubDateBuffer stringByAppendingString:string];
    } else if ([self.element isEqualToString:@"guid"]) {
        self.guidBuffer = [self.guidBuffer stringByAppendingString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {

    if ([elementName isEqualToString:@"item"]) {
        NSString *title = [self.titleBuffer componentsSeparatedByString:@"\n"][0];
        NSURL *link = [NSURL URLWithString:[self.linkBuffer componentsSeparatedByString:@"\n"][0]];
        NSDate *pubDate = [self.dateFormatter dateFromString:[self.pubDateBuffer componentsSeparatedByString:@"\n"][0]];
        NSString *guid = [self.guidBuffer componentsSeparatedByString:@"\n"][0];
        
        FeedItem *item = [[FeedItem alloc] initWithTitle:title link:link pubDate:pubDate guid:guid];
        [self.privateItems addObject:item];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    if (self.completion) {
        self.completion();
    }
}

@end
