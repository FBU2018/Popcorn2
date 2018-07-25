//
//  ShelfViewController.h
//  Popcorn
//
//  Created by Rucha Patki on 7/16/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCLibraryViewController.h"


@interface PCShelfViewController : UIViewController

@property (strong, nonatomic) NSNumber *shelfId;
@property (strong, nonatomic) NSArray *shelves;

@end
