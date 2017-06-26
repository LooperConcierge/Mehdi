//
//  RegistrationVC.m
//  Looper
//
//  Created by hardik on 2/1/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "RegistrationVC.h"
#import "ExpertiseGalleryViewController.h"

@interface RegistrationVC ()
{
    
    IBOutlet UIButton *btnLooper;
    IBOutlet UIButton *btnTraveler;
}

@end

@implementation RegistrationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareView];
    
    // Do any additional setup after loading the view.
}

-(void)prepareView
{
//    [self addBackButton];
    btnLooper.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
    btnTraveler.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
    [btnLooper setBackgroundColor:[UIColor lightRedBackgroundColor]];

}

- (IBAction)btnTravelerPressed:(id)sender
{
    AppdelegateObject.looperGlobalObject.isLooper = FALSE;
    [self performSegueWithIdentifier:@"segueTraveler" sender:nil];
}

- (IBAction)btnLooperPressed:(id)sender
{
        AppdelegateObject.looperGlobalObject.isLooper = TRUE;
//     [self performSegueWithIdentifier:@"segueTraveler" sender:nil];
    
     [self performSegueWithIdentifier:@"segueLooperProfile" sender:nil];
    
//    UIStoryboard *Lopper = [UIStoryboard storyboardWithName:@"Looper" bundle:nil];
//    //  self.ViewObj = [[ViewController alloc] init];
//    ExpertiseGalleryViewController *vc = [Lopper instantiateViewControllerWithIdentifier:@"ExpertiseGalleryViewController"];
//    [self.navigationController pushViewController:vc animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //Need to set title here back button issue (...)
    self.title = @"REGISTER";
}



-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.title = @"";
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
