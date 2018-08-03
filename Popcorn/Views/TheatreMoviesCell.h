//
//  TheatreMoviesCell.h
//  Popcorn
//
//  Created by Rucha Patki on 8/3/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface TheatreMoviesCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *posterImage;
@property (strong, nonatomic) Movie *movie;

@end
