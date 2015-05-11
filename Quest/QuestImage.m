//
//  QuestImage.m
//  Quest
//
//  Created by Georgel Vintila on 11/05/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "QuestImage.h"

@interface QuestImage ()

@property(nonatomic,readwrite) NSData *imageData;

@end

@implementation QuestImage

- (instancetype)initWithData:(NSData *)data
{
    self = [super init];
    if (self) {
        _imageData = data;
        _imageUrl = nil;
    }
    return self;
}

- (instancetype)initWithUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        _imageUrl = url;
        _imageData = nil;
    }
    return self;
}


-(void)imageWithBlock:(void (^)(UIImage *, NSError *))block
{
    
    if (!self.imageData) {
        self.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageUrl]];
    }
    UIImage *image = [UIImage imageWithData:self.imageData];
    NSError *error = nil;
    if (!image) {
        error = [NSError errorWithDomain:@"Data corrupt" code:101 userInfo:nil];
    }
    block(image,error);
}

@end
