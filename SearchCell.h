//
//  SearchCell.h
//  Popcorn
//
//  Created by Ernest Omondi on 7/16/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
#import <SWTableViewCell.h>

@interface SearchCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (strong, nonatomic) Movie *movie;

@end
