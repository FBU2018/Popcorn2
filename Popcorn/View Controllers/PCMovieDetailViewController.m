//
//  PCMovieDetailViewController.m
//  Popcorn
//
//  Created by Sarah Embry on 7/16/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PCMovieDetailViewController.h"
#import "CastCollectionViewCell.h"

@interface PCMovieDetailViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *backdropImageView;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *directorLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *castCollectionView;

- (IBAction)didTapAddTo:(id)sender; 
- (IBAction)didTapRating:(id)sender;
- (IBAction)didTapCommunityReviews:(id)sender;

@property (strong, nonatomic) NSArray *castList;

@end

@implementation PCMovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.castCollectionView.delegate = self;
    self.castCollectionView.dataSource = self;
    ((UICollectionViewFlowLayout *)self.castCollectionView).minimumLineSpacing = 1000.0f;

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

- (IBAction)didTapAddTo:(id)sender {
}

- (IBAction)didTapRating:(id)sender {
}

- (IBAction)didTapCommunityReviews:(id)sender {
}



- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CastCollectionViewCell *cell = [self.castCollectionView dequeueReusableCellWithReuseIdentifier:@"CastCollectionViwCell" forIndexPath:indexPath];
    
    
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.castList.count;
}

//this will go in APIManager later
-(void) fetchCast{
  
}



@end
