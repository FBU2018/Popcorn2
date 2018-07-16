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

- (void)createList: (NSString*) name completion:(void (^)(NSError *))completion;
- (void)getShelves: (NSMutableArray*) shelvesArray;

@end
