//
//  ActorCreditsCollectionViewCell.h
//  Popcorn
//
//  Created by Sarah Embry on 7/25/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActorCreditsCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
-(void) configureCell: (NSArray *)credits atIndexPath:(NSIndexPath *)indexPath;
@end
