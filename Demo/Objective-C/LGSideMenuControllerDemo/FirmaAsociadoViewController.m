//
//  FirmaAsociadoViewController.m
//  Integrity
//
//  Created by Fernando Alonso Pecina on 12/06/17.
//  Copyright © 2017 Grigory Lutkov. All rights reserved.
//

#import "FirmaAsociadoViewController.h"
#import "AppDelegate.h"
#import "LoadingView.h"
#import "PaintingView.h"
#import "SoundEffect.h"

//CONSTANTS:

#define kBrightness             1.0
#define kSaturation             0.45

#define kPaletteHeight			30
#define kPaletteSize			5
#define kMinEraseInterval		0.5

// Padding for margins
#define kLeftMargin				10.0
#define kTopMargin				10.0
#define kRightMargin			10.0

@interface FirmaAsociadoViewController ()
{
    SoundEffect			*erasingSound;
    SoundEffect			*selectSound;
    CFTimeInterval		lastTime;
}
@end

@implementation FirmaAsociadoViewController
@synthesize firmaAnterior=_firmaAnterior;
-(void)showNoHayInternet
{
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:@"Integrity"
                                 message:@"No hay una conexión disponible de internet, favor de conectarse a internet para cambiar y guardar tu firma"
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Aceptar"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                                 [self.navigationController popViewControllerAnimated:YES];
                             }];
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
}
-(void)borrarFirma {
    for (UIView* b in self.view.subviews)
    {
        [b removeFromSuperview];
    }
    [(PaintingView *)self.view erase];
    //borrar firma
}
- (UIImage *)captureView {
    
    //hide controls if needed
    CGRect rect = [self.view bounds];
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
    
}

- (UIImage *)glToUIImage {
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGSize screenSize = CGSizeMake(screenBounds.size.width * screenScale, screenBounds.size.height * screenScale);
    
    int w = screenSize.width;
    int h = screenSize.height-50;
    NSInteger myDataLength = w * h * 4;
    
    // allocate array and read pixels into it.
    GLubyte *buffer = (GLubyte *) malloc(myDataLength);
    glReadPixels(0, 0, w, h, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
    
    // gl renders "upside down" so swap top to bottom into new array.
    // there's gotta be a better way, but this works.
    GLubyte *buffer2 = (GLubyte *) malloc(myDataLength);
    for(int y = 0; y < h; y++)
    {
        for(int x = 0; x < w * 4; x++)
        {
            buffer2[(h - 1 - y) * w * 4 + x] = buffer[y * 4 * w + x];
        }
    }
    
    // make data provider with data.
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer2, myDataLength, NULL);
    
    // prep the ingredients
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * w;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    // make the cgimage
    CGImageRef imageRef = CGImageCreate(w, h, bitsPerComponent, bitsPerPixel, bytesPerRow,     colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    
    // then make the uiimage from that
    UIImage *myImage = [UIImage imageWithCGImage:imageRef];
    return myImage;
}
-(void)guardarFirma {
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(app.hasInternet)
    {
        UIImage *firmaDelAsociado = [self glToUIImage];
        
        UIImage * portraitImage = [[UIImage alloc] initWithCGImage: firmaDelAsociado.CGImage
                                                             scale: 1.0
                                                       orientation: UIImageOrientationLeft];
        
        NSData *dataImage = UIImageJPEGRepresentation(portraitImage, 0.5f);
        NSString *urlString = @"http://integritycapacitacion.org/guardaImagen.php";
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *filename = [defaults valueForKey:@"idGema"];
        NSMutableURLRequest* request= [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        NSMutableData *postbody = [NSMutableData data];
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"firma\"; filename=\"%@.jpg\"\r\n", filename] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[NSData dataWithData:dataImage]];
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:postbody];
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *responseString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        if ([responseString containsString:@"{ \"success\" : 1 }"])
        {
            UIAlertController * view=   [UIAlertController
                                         alertControllerWithTitle:@"Integrity"
                                         message:@"Firma guardada"
                                         preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* cancel = [UIAlertAction
                                     actionWithTitle:@"Aceptar"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [view dismissViewControllerAnimated:YES completion:nil];
                                         [self.navigationController popViewControllerAnimated:YES];
                                     }];
            [view addAction:cancel];
            [self presentViewController:view animated:YES completion:nil];
        }
    }
    else
    {
        [self showNoHayInternet];
    }
}
-(void)cargaImagenEnElView {
    LoadingView *load = [LoadingView loadingViewInView:self.view];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *filename = [NSString stringWithFormat:@"%@.jpg", [defaults valueForKey:@"idGema"]];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://integritycapacitacion.org/firmaAsociados/%@",filename]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if(data!=nil)
    {
        UIImage *image = [UIImage imageWithData:data];
        UIImage * portraitImage = [[UIImage alloc] initWithCGImage: image.CGImage
                                                             scale: 1.0
                                                       orientation: UIImageOrientationUp];
        
        [_firmaAnterior setImage:portraitImage];
    }
    else
    {
        [_firmaAnterior removeFromSuperview];
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@"Integrity"
                                     message:@"Recuerda firmar con la parte de abajo del telefono a la derecha (modo landscape o panorámico)"
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Aceptar"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [view dismissViewControllerAnimated:YES completion:nil];
                                 }];
        [view addAction:cancel];
        [self presentViewController:view animated:YES completion:nil];

    }
    [load removeView];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"desabilita"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Firma del ejecutivo";
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(app.hasInternet)
    {
        UIBarButtonItem *borrarBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(borrarFirma)];
        
        UIBarButtonItem *guardarBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(guardarFirma)];
        
        self.navigationItem.rightBarButtonItems = @[borrarBar, guardarBar];
        
        
        CGColorRef color = [UIColor colorWithHue:(CGFloat)2.0 / (CGFloat)kPaletteSize
                                      saturation:kSaturation
                                      brightness:kBrightness
                                           alpha:1.0].CGColor;
        const CGFloat *components = CGColorGetComponents(color);
        
        // Defer to the OpenGL view to set the brush color
        [(PaintingView *)self.view setBrushColorWithRed:components[0] green:components[1] blue:components[2]];
        
        // Load the sounds
        NSBundle *mainBundle = [NSBundle mainBundle];
        erasingSound = [[SoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"Erase" ofType:@"caf"]];
        selectSound =  [[SoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"Select" ofType:@"caf"]];
        
        // Erase the view when recieving a notification named "shake" from the NSNotificationCenter object
        // The "shake" nofification is posted by the PaintingWindow object when user shakes the device
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eraseView) name:@"shake" object:nil];
        [self cargaImagenEnElView];
    }
    else
    {
        [self showNoHayInternet];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"desabilita"];
}
- (BOOL)canBecomeFirstResponder
{
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// Release resources when they are no longer needed,
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// Change the brush color
- (void)changeBrushColor:(id)sender
{
    // Play sound
    [selectSound play];
    
    // Define a new brush color
    CGColorRef color = [UIColor colorWithHue:(CGFloat)[sender selectedSegmentIndex] / (CGFloat)kPaletteSize
                                  saturation:kSaturation
                                  brightness:kBrightness
                                       alpha:1.0].CGColor;
    const CGFloat *components = CGColorGetComponents(color);
    
    // Defer to the OpenGL view to set the brush color
    [(PaintingView *)self.view setBrushColorWithRed:components[0] green:components[1] blue:components[2]];
}

// Called when receiving the "shake" notification; plays the erase sound and redraws the view
- (void)eraseView
{
    if(CFAbsoluteTimeGetCurrent() > lastTime + kMinEraseInterval) {
        [erasingSound play];
        [(PaintingView *)self.view erase];
        lastTime = CFAbsoluteTimeGetCurrent();
    }
}

// We do not support auto-rotation in this sample
- (BOOL)shouldAutorotate
{
    return NO;
}

#pragma mark Motion

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        // User was shaking the device. Post a notification named "shake".
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shake" object:self];
    }
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
