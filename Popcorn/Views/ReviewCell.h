//
//  ReviewCell.h
//  Popcorn
//
//  Created by Sarah Embry on 7/19/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *reviewerName;
@property (weak, nonatomic) IBOutlet UILabel *reviewContent;
- (void) configureCell:(NSArray *)reviews withIndexPath:(NSIndexPath *)indexPath;
@end
