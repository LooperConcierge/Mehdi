//
//  SelectLanguageVC.h
//  Looper
//
//  Created by hardik on 5/5/16.
//  Copyright © 2016 looper. All rights reserved.
//

#import "BaseNavVC.h"

@protocol SelectLanguageVCDelegate <NSObject>

@optional
-(void)languageArray:(NSArray *)languages;

@end
@interface SelectLanguageVC : BaseNavVC

@property (strong, nonatomic) NSMutableArray *contaionsLanguage;
@property (weak, nonatomic) id <SelectLanguageVCDelegate> selectLangDelegate;

@end
