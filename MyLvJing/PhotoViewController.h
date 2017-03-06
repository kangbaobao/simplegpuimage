#import <UIKit/UIKit.h>
#import "GPUImage.h"

@interface PhotoViewController : UIViewController
{
    GPUImageStillCamera *stillCamera;
    GPUImageOutput<GPUImageInput> *filter, *secondFilter, *terminalFilter;
    UISlider *filterSettingsSlider;
    UIButton *photoCaptureButton;
    
    GPUImagePicture *memoryPressurePicture1, *memoryPressurePicture2;
}

- (void)updateSliderValue:(id)sender;
- (void)takePhoto:(id)sender;

@end
