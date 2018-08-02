//
//  Chat.m
//  Popcorn
//
//  Created by Ernest Omondi on 8/1/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "Chat.h"

@implementation Chat
@dynamic message, movieID, userObjectId, createdAtString;
+ (nonnull NSString *)parseClassName {
    return @"Chat";
}

@end
