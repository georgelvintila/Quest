//
//  QuestImage.h
//  Quest
//
//  Created by Georgel Vintila on 11/05/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestImage : NSObject

@property(nonatomic,readonly) NSString* imageUrl;
@property(nonatomic,readonly) NSData *imageData;


-(instancetype)initWithUrl:(NSString *)url;
-(instancetype)initWithData:(NSData *)data;
-(void) imageWithBlock:(void (^)(UIImage* image , NSError *error)) block;


@end
