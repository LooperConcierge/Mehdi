//
//  LandingVC.m
//  Looper
//
//  Created by hardik on 1/30/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "LandingVC.h"
#import "SelectCityMapVC.h"
#import "UIFont+CustomFont.h"

@interface LandingVC ()
@property (strong, nonatomic) IBOutlet UIButton *btnLogin;
@property (strong, nonatomic) IBOutlet UIButton *btnRegister;
@property (strong, nonatomic) IBOutlet UIButton *btnExplore;
@property (strong, nonatomic) IBOutlet UIImageView *imgBackground;

@end

@implementation LandingVC
@synthesize btnExplore,btnLogin,btnRegister;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareView];
    // Do any additional setup after loading the view.
}

-(void)prepareView
{
    UIFont *font1 = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
    
    NSDictionary *dict1 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),
                            NSFontAttributeName:font1,NSForegroundColorAttributeName : [UIColor whiteColor]}; // Added line
    
    btnRegister.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
    btnExplore.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
    btnLogin.titleLabel.font = [UIFont fontAvenirNextCondensedMediumWithSize:FONT_MEDIUM_SIZE];
    
    btnRegister.backgroundColor = [UIColor lightRedBackgroundColor];
    [btnLogin setTitle:[[LooperUtility sharedInstance].localization localizedStringForKey:keyLandingLogin] forState:UIControlStateNormal];
    [btnRegister setTitle:[[LooperUtility sharedInstance].localization localizedStringForKey:keyLandingRegister] forState:UIControlStateNormal];
    [btnExplore setAttributedTitle:[[NSAttributedString alloc] initWithString:@"EXPLORE" attributes:dict1] forState:UIControlStateNormal];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareView) name:@"LCLLanguageChangeNotification" object:nil];
    

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma Mark - Private methods

- (IBAction)btnLoginPressed:(id)sender
{

    [self performSegueWithIdentifier:@"segueLogin" sender:nil];

}

- (IBAction)btnRegisterPressed:(id)sender
{
    [self performSegueWithIdentifier:@"segueRegister" sender:nil];
}

- (IBAction)btnExplorePressed:(id)sender
{
    NSLog(@"BTN EXPLORE PRESSED");

    UIStoryboard *st = [UIStoryboard storyboardWithName:@"Traveler" bundle:nil];
    SelectCityMapVC *mainViewController = [st instantiateViewControllerWithIdentifier:@"SelectCityMapVCID"];
    mainViewController.isSkipHide = TRUE;
    [self.navigationController pushViewController:mainViewController animated:YES];
}

-(IBAction)btnLanguagePressed:(id)sender
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Language" message:@"Select language" preferredStyle:UIAlertControllerStyleActionSheet];

    NSArray *localization = [[LooperUtility sharedInstance].localization availableLanguages];

    for (NSString *language in localization)
    {
        NSString *str = [[LooperUtility sharedInstance].localization displayNameForLanguage:language];
        UIAlertAction *action = [UIAlertAction actionWithTitle:str style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[LooperUtility sharedInstance].localization setLanguage:language];
        }];
        [controller addAction:action];
    }
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [controller addAction:action];
    
    [self presentViewController:controller animated:YES completion:^{
        
    }];
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
