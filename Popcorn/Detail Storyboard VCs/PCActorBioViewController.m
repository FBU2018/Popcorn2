//
//  PCActorBioViewController.m
//  Popcorn
//
//  Created by Sarah Embry on 7/24/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PCActorBioViewController.h"

@interface PCActorBioViewController ()
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;

@end

@implementation PCActorBioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bioLabel.text = self.bio;
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
