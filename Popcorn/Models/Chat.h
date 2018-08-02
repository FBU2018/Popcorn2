//
//  Chat.h
//  Popcorn
//
//  Created by Ernest Omondi on 8/1/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PFObject.h"
#import <Parse/Parse.h>


@interface Chat : PFObject <PFSubclassing>
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSNumber *movieID;
@property (strong, nonatomic) NSString *userObjectId;
@property (strong, nonatomic) NSString *createdAtString;
@end
