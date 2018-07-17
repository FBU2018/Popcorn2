//
//  APIManager.h
//  Popcorn
//
//  Created by Rucha Patki on 7/16/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIManager : NSObject

+ (instancetype)shared;

- (void)createList: (NSString*) name completion:(void (^)(NSString *, NSError *))completion;
//(void(^)(NSDictionary *accountInfo, NSError *error))completion
- (void)getShelves:(void(^)(NSDictionary *shelves, NSError *error))completion;

@end
