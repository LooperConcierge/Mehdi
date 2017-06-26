//
//  HGImagePicker.m
//  Hush
//
//  Created by Hiren on 10/23/15.
//  Copyright © 2015 Hush. All rights reserved.
//

#import "HGImagePicker.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <Photos/Photos.h>

typedef void (^ImageCanceled)();
typedef void (^ImageRemoved)();
typedef void (^ImagePicked)(NSDictionary *dictData);

@interface HGImagePicker () <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    id delegate;
    UIColor *navColor;
    ImageCanceled imageCanceledBlock;
    ImagePicked imagePickedBlock;
    ImageRemoved imageRemovedBlock;
}
@end

@implementation HGImagePicker

- (void)showImagePicker:(id)fromViewController
    withNavigationColor:(UIColor *)navigationColor
            imagePicked:(void(^)(NSDictionary *dictData))successBlock
          imageCanceled:(void(^)())cancelBlock
           imageRemoved:(void (^)())removeBlock {
    
    delegate = fromViewController;
    navColor = navigationColor;
    imagePickedBlock = successBlock;
    imageCanceledBlock = cancelBlock;
    imageRemovedBlock = removeBlock;
    
    NSString *strTitle = @"Choose/Capture a Photo";
    
    if (self.typeOfPicker == kBoth) {
        strTitle = @"Choose/Capture a Photo or a Video";
    } else if (self.typeOfPicker == kOnlyVideos) {
        strTitle = @"Choose/Capture a Video";
    }
    
    //Show Alert View Controller
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:strTitle
                                                                             message:@""
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    //We add buttons to the alert controller by creating UIAlertActions:
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"Photo Album"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         //on Gallery
                                                         [self showGallery];
                                                     }];
    [alertController addAction:photoAction];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Camera"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 [self showCamera];
                                                             }];
        [alertController addAction:cameraAction];
    }
    
    if (imageRemovedBlock) {
        NSString *strRemove = @"Remove a Photo";
        
        if (self.typeOfPicker == kBoth) {
            strRemove = @"Remove a Photo or a Video";
        } else if (self.typeOfPicker == kOnlyVideos) {
            strRemove = @"Remove a Video";
        }
        
        UIAlertAction *removeAction = [UIAlertAction actionWithTitle:strRemove
                                                               style:UIAlertActionStyleDestructive
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 if (imageRemovedBlock) {
                                                                     imageRemovedBlock();
                                                                 }
                                                             }];
        [alertController addAction:removeAction];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             if (imageCanceledBlock) {
                                                                 imageCanceledBlock();
                                                             }
                                                         }];
    [alertController addAction:cancelAction];
    
    [fromViewController presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Image Picker Delegate Methods
- (void)imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    
    
    if ([info objectForKey:UIImagePickerControllerMediaURL]) {
        if (imagePickedBlock) {
            double compressionRatio=1;
            NSData *imgData=UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerMediaURL"],compressionRatio);
            while ([imgData length]>50000) {
                compressionRatio=compressionRatio*0.5;
                imgData=UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerMediaURL"],compressionRatio);
            }
            UIImage *img=[[UIImage alloc] initWithData:imgData];
            
            imagePickedBlock(@{ UIImagePickerControllerMediaURL : img});
        }
    }
    
    if ([info objectForKey:UIImagePickerControllerOriginalImage]) {
        //UIImage *originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
        
        if (imagePickedBlock) {
            if (self.typeOfCrop == kCropImage)
                imagePickedBlock(@{ UIImagePickerControllerOriginalImage : info[UIImagePickerControllerEditedImage]});
            else
            imagePickedBlock(@{ UIImagePickerControllerOriginalImage : info[UIImagePickerControllerOriginalImage]});
        }
    }
    
    [delegate dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [delegate dismissViewControllerAnimated:YES completion:nil];
    if (imageCanceledBlock) {
        imageCanceledBlock();
    }
}

#pragma mark - Common Methods
- (void)showGallery {
    [self obtainPermissionForMediaSourceType:UIImagePickerControllerSourceTypePhotoLibrary withSuccessHandler:^{
        
        UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
        mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
        // Displays saved pictures from the Camera Roll album.
        if (self.typeOfPicker == kOnlyPhotos) {
            mediaUI.mediaTypes = @[(NSString *)kUTTypeImage];
            if (self.typeOfCrop == kCropImage)
                mediaUI.allowsEditing = YES;
            else if (self.typeOfCrop == kOriginalImage)
                mediaUI.allowsEditing = NO;
            
        } else if (self.typeOfPicker == kOnlyVideos) {
            mediaUI.mediaTypes = @[(NSString *)kUTTypeMovie];
            mediaUI.allowsEditing = NO;
        } else {
            mediaUI.mediaTypes = @[(NSString *)kUTTypeImage,(NSString *)kUTTypeMovie];
            if (self.typeOfCrop == kCropImage)
                mediaUI.allowsEditing = YES;
            else if (self.typeOfCrop == kOriginalImage)
                mediaUI.allowsEditing = NO;
        }
        
        // Hides the controls for moving & scaling pictures
        
        mediaUI.delegate = self;
        
        [delegate presentViewController:mediaUI animated:YES completion:nil];
    } andFailure:^{
        UIAlertController *alertController= [UIAlertController
                                             alertControllerWithTitle:nil
                                             message:NSLocalizedString(@"You have disabled Photos access", nil)
                                             preferredStyle:UIAlertControllerStyleActionSheet];
        
        [alertController addAction:[UIAlertAction
                                    actionWithTitle:NSLocalizedString(@"Open Settings", @"Photos access denied: open the settings app to change privacy settings")
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction *action) {
                                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                    }]
         ];
        
        [alertController addAction:[UIAlertAction
                                    actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                    style:UIAlertActionStyleDefault
                                    handler:NULL]
         ];
        
        [delegate presentViewController:alertController animated:YES completion:^{}];
    }];
}

- (void)showCamera {
    [self obtainPermissionForMediaSourceType:UIImagePickerControllerSourceTypeCamera withSuccessHandler:^{
        UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
        mediaUI.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        // Displays saved pictures from the Camera Roll album.
        if (self.typeOfPicker == kOnlyPhotos) {
            mediaUI.mediaTypes = @[(NSString *)kUTTypeImage];
            if (self.typeOfCrop == kCropImage)
                mediaUI.allowsEditing = YES;
            else if (self.typeOfCrop == kOriginalImage)
                mediaUI.allowsEditing = NO;
        } else if (self.typeOfPicker == kOnlyVideos) {
            mediaUI.mediaTypes = @[(NSString *)kUTTypeMovie];
            mediaUI.allowsEditing = NO;
        } else {
            mediaUI.mediaTypes = @[(NSString *)kUTTypeImage,(NSString *)kUTTypeMovie];
            if (self.typeOfCrop == kCropImage)
                mediaUI.allowsEditing = YES;
            else if (self.typeOfCrop == kOriginalImage)
                mediaUI.allowsEditing = NO;
        }
        
        // Hides the controls for moving & scaling pictures
        mediaUI.delegate = self;
        
        [delegate presentViewController:mediaUI animated:YES completion:nil];
    } andFailure:^{
        UIAlertController *alertController = [UIAlertController
                                             alertControllerWithTitle:nil
                                             message:NSLocalizedString(@"You have disabled Camera access", nil)
                                             preferredStyle:UIAlertControllerStyleActionSheet];
        
        [alertController addAction:[UIAlertAction
                                    actionWithTitle:NSLocalizedString(@"Open Settings", @"Camera access denied: open the settings app to change privacy settings")
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction *action) {
                                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                    }]
         ];
        
        [alertController addAction:[UIAlertAction
                                    actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                    style:UIAlertActionStyleDefault
                                    handler:NULL]
         ];
        
        [delegate presentViewController:alertController animated:YES completion:^{}];
    }];
}

- (void)obtainPermissionForMediaSourceType:(UIImagePickerControllerSourceType)sourceType
                        withSuccessHandler:(void (^) ())successHandler
                                andFailure:(void (^) ())failureHandler {
    if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary || sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum) {
        // Denied when photo disabled, authorized when photos is enabled. Not affected by camera
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            switch (status) {
                case PHAuthorizationStatusAuthorized: {
                    if (successHandler)
                        dispatch_async (dispatch_get_main_queue (), ^{ successHandler (); });
                }; break;
                    
                case PHAuthorizationStatusRestricted:
                case PHAuthorizationStatusDenied:{
                    if (failureHandler)
                        dispatch_async (dispatch_get_main_queue (), ^{ failureHandler (); });
                }; break;
                    
                default:
                    break;
            }
        }];
    } else if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        // Checks for Camera access:
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        switch (status) {
                
            case AVAuthorizationStatusAuthorized:{
                if (successHandler)
                    dispatch_async (dispatch_get_main_queue (), ^{ successHandler (); });
            }; break;
                
            case AVAuthorizationStatusNotDetermined:{
                // seek access first:
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if(granted){
                        if (successHandler)
                            dispatch_async (dispatch_get_main_queue (), ^{ successHandler (); });
                    } else {
                        if (failureHandler)
                            dispatch_async (dispatch_get_main_queue (), ^{ failureHandler (); });
                    }
                }];
            }; break;
                
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
            default:{
                if (failureHandler)
                    dispatch_async (dispatch_get_main_queue (), ^{ failureHandler (); });
            }; break;
        }
    }
    else{
        NSAssert(NO, @"Permission type not found");
    }
}

// If navigation controller is passed nil
- (void)navigationController:(UINavigationController *)navigationController
     willShowViewController:(UIViewController *)viewController
                   animated:(BOOL)animated {
    if (navColor != nil) {
        navigationController.navigationBar.translucent = NO;
        navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
        navigationController.navigationBar.barTintColor = navColor;
        navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
}

@end
