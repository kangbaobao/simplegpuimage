#import "PhotoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface PhotoViewController ()
@property(nonatomic,strong)GPUImageView *img;
@property(nonatomic,strong)NSArray *filterArr;
@property(nonatomic,assign)Class currentFilterClass;
@end

@implementation PhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView 
{
    _filterArr=@[[GPUImageLuminosity class],[GPUImageColorInvertFilter class],[GPUImageContrastFilter class],[GPUImageAverageLuminanceThresholdFilter class],  [GPUImagePosterizeFilter class],[GPUImage3x3ConvolutionFilter class],[GPUImageEmbossFilter class],[GPUImageSoftLightBlendFilter class],[GPUImageChromaKeyBlendFilter class],[GPUImageMaskFilter class],[GPUImageDarkenBlendFilter class],[GPUImageColorPackingFilter class]];//[GPUImageHardLightBlendFilter class],
    
    
    NSLog(@"++%@",_filterArr);
	CGRect mainScreenFrame = [[UIScreen mainScreen] bounds];
	    
    // Yes, I know I'm a caveman for doing all this by hand
	GPUImageView *primaryView = [[GPUImageView alloc] initWithFrame:mainScreenFrame];
	primaryView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
//    filterSettingsSlider = [[UISlider alloc] initWithFrame:CGRectMake(25.0, mainScreenFrame.size.height - 50.0, mainScreenFrame.size.width - 50.0, 40.0)];
//    [filterSettingsSlider addTarget:self action:@selector(updateSliderValue:) forControlEvents:UIControlEventValueChanged];
//	filterSettingsSlider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
//    filterSettingsSlider.minimumValue = 0.0;
//    filterSettingsSlider.maximumValue = 3.0;
//    filterSettingsSlider.value = 1.0;
//    
//    [primaryView addSubview:filterSettingsSlider];
    
    photoCaptureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    photoCaptureButton.frame = CGRectMake(round(mainScreenFrame.size.width / 2.0 - 150.0 / 2.0), mainScreenFrame.size.height - 90.0, 150.0, 40.0);
    [photoCaptureButton setTitle:@"Capture Photo" forState:UIControlStateNormal];
	photoCaptureButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [photoCaptureButton addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [photoCaptureButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    [primaryView addSubview:photoCaptureButton];
    
	self.view = primaryView;	
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    stillCamera = [[GPUImageStillCamera alloc] init];
    stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    filter = [[GPUImageLocalBinaryPatternFilter alloc] init];
    [stillCamera addTarget:filter];
    GPUImageView *filterView = (GPUImageView *)self.view;
    [filter addTarget:filterView];
    _img=filterView;
    [stillCamera startCameraCapture];
   
//    stillCamera = [[GPUImageStillCamera alloc] init];
//    [stillCamera.inputCamera lockForConfiguration:nil];
//    //    #warning  闪光灯 前摄像头不能开闪光灯
//    [stillCamera.inputCamera setFlashMode:AVCaptureFlashModeOn];
//#pragma mark  解锁
//    [stillCamera.inputCamera unlockForConfiguration];

    
    
    UIButton *lvjingQie=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    lvjingQie.frame=CGRectMake(20, 100, 100, 50);
    [lvjingQie setTitle:@"切换滤镜" forState:UIControlStateNormal];
    [lvjingQie addTarget:self action:@selector(lvjingQieDown) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lvjingQie];
    
    UIButton *sexiangTouQie=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    sexiangTouQie.frame=CGRectMake(100, 100, 100, 50);
    [sexiangTouQie setTitle:@"切换滤镜" forState:UIControlStateNormal];
    [sexiangTouQie addTarget:self action:@selector(sexiangTouQieDwn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sexiangTouQie];

    

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)updateSliderValue:(id)sender
{
//    static int i=0;
//    if(i==0)
//    {
//   [stillCamera removeTarget:filter];
//    
//    GPUImageOutput<GPUImageInput> *filter22= [[GPUImageColorBurnBlendFilter alloc] init];
//    [stillCamera addTarget:filter22];
//        i++;
//    }
//    [(GPUImagePixellateFilter *)filter setFractionalWidthOfAPixel:[(UISlider *)sender value]];
//    [(GPUImageGammaFilter *)filter setGamma:[(UISlider *)sender value]];
}

//切换滤镜
-(void)lvjingQieDown
{
    
    static int i=0;
    i++;
    if(i>=_filterArr.count-1)
    {
        i=0;
    }
    [filter removeTarget:(GPUImageView *)self.view];
    [stillCamera removeTarget:filter];
    [stillCamera stopCameraCapture];
    _currentFilterClass=_filterArr[i];
    NSLog(@"---%@ ++",_filterArr);
      filter= [[_filterArr[i] alloc] init];
        [stillCamera addTarget:filter];
        GPUImageView *filterView = (GPUImageView *)self.view;
        [filter addTarget:filterView];
        _img=filterView;
    [stillCamera startCameraCapture];
}
//切换摄像头
-(void)sexiangTouQieDwn:(UIButton *)btn
{
    btn.selected=!btn.selected;
    [filter removeTarget:(GPUImageView *)self.view];
    [stillCamera removeTarget:filter];
    [stillCamera stopCameraCapture];
    stillCamera=nil;
    

    if(btn.selected)
    {
    
   stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetPhoto cameraPosition:AVCaptureDevicePositionFront];
    }else
    {
        stillCamera = [[GPUImageStillCamera alloc] init];
            [stillCamera.inputCamera lockForConfiguration:nil];
        //    #warning  闪光灯 前摄像头不能开闪光灯
        [stillCamera.inputCamera setFlashMode:AVCaptureFlashModeOn];
#pragma mark  解锁
            [stillCamera.inputCamera unlockForConfiguration];

    }
    stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    filter = [[_currentFilterClass alloc] init];
    [stillCamera addTarget:filter];
    GPUImageView *filterView = (GPUImageView *)self.view;
    [filter addTarget:filterView];
    _img=filterView;
    [stillCamera startCameraCapture];
    
}

- (IBAction)takePhoto:(id)sender;
{
    



    
    
    [photoCaptureButton setEnabled:NO];
    
    [stillCamera capturePhotoAsJPEGProcessedUpToFilter:filter withCompletionHandler:^(NSData *processedJPEG, NSError *error){

        // Save to assets library
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        
        [library writeImageDataToSavedPhotosAlbum:processedJPEG metadata:nil completionBlock:^(NSURL *assetURL, NSError *error2)
         {
             if (error2) {
                 NSLog(@"ERROR: the image failed to be written");
             }
             else {
                 NSLog(@"PHOTO SAVED - assetURL: %@", assetURL);
             }
			 
             runOnMainQueueWithoutDeadlocking(^{
                 [photoCaptureButton setEnabled:YES];
             });
         }];
    }];
}

@end
