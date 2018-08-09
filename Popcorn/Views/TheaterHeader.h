//
//  TheaterHeader.h
//  Popcorn
//
//  Created by Rucha Patki on 8/9/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TheaterHeader : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *moviesCurrentlyPlayingLabel;
@property (weak, nonatomic) IBOutlet UILabel *theaterNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *theaterImage;


@end
