//
//  HGImagePicker.h
//  Hush
//
//  Created by Hiren on 10/23/15.
//  Copyright © 2015 Hush. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    kOnlyPhotos,
    kOnlyVideos,
    kBoth
} PickerType;

typedef enum {
    kCropImage,
    kOriginalImage,
} PickerCropType;

@interface HGImagePicker : NSObject

@property (nonatomic) PickerType typeOfPicker;
@property (nonatomic) PickerCropType typeOfCrop;

- (void)showImagePicker:(id)fromViewController
    withNavigationColor:(UIColor *)navigationColor
            imagePicked:(void(^)(NSDictionary *dictData))successBlock
          imageCanceled:(void(^)())cancelBlock
           imageRemoved:(void(^)())removeBlock;

@end