//
//  LibraryCell.h
//  Popcorn
//
//  Created by Rucha Patki on 7/16/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LibraryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberItemsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shelfImageView;

@property (strong, nonatomic) NSString *movieId;
@property (strong, nonatomic) NSString *listType;
- (void)configureCell:(NSDictionary *) shelfInfo;



@end
