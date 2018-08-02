//
//  PCMapDetailViewController.m
//  Popcorn
//
//  Created by Rucha Patki on 8/2/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PCMapDetailViewController.h"

@interface PCMapDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *theatreNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *theatreImage;


@end

@implementation PCMapDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setViews];
}

- (void)setViews{
    self.theatreNameLabel.text = self.theatreTitle;
    self.addressLabel.text = self.theatreInfo[@"candidates"][0][@"formatted_address"];
    NSLog(@"imageURL: %@", self.theatreInfo[@"candidates"][0][@"photos"][0][@"html_attributions"][0]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
