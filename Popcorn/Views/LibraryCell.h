//
//  LibraryCell.h
//  Popcorn
//
//  Created by Rucha Patki on 7/16/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface LibraryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberItemsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shelfImageView;

@property (strong, nonatomic) NSNumber *shelfId;
@property (strong, nonatomic) NSString *listType;
@property (strong, nonatomic) Movie *movieForImage;
- (void)configureCell:(NSDictionary *) shelfInfo;



@end
