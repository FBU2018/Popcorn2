//
//  CastCollectionViewCell.h
//  Popcorn
//
//  Created by Sarah Embry on 7/16/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"

@interface CastCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *castImageView;
@property (weak, nonatomic) IBOutlet UILabel *characterNameLabel;
- (void) configureCell:(NSArray *)castList withIndexPath:(NSIndexPath *)indexPath;
@end
