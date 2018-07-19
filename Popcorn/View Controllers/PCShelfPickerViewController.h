//
//  PCShelfPickerViewController.h
//  Popcorn
//
//  Created by Rucha Patki on 7/18/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface PCShelfPickerViewController : UIViewController

@property (strong, nonatomic) Movie *movie;
@property (strong, nonatomic) NSArray *shelves;

@end
