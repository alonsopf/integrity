//
//  FirmaClienteViewController.m
//  Integrity
//
//  Created by Fernando Alonso Pecina on 12/06/17.
//  Copyright © 2017 Grigory Lutkov. All rights reserved.
//

#import "FirmaClienteViewController.h"
#import "AppDelegate.h"
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

@interface FirmaClienteViewController ()
{
    SoundEffect			*erasingSound;
    SoundEffect			*selectSound;
    CFTimeInterval		lastTime;
}
@end

@implementation FirmaClienteViewController
@synthesize dataList=_dataList;

-(int)getNextIdPedido {
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.fetchLimit = 1;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"idPedido" ascending:NO]];
    NSManagedObjectContext *moc = [app managedObjectContext];
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"Pedidos" inManagedObjectContext:moc];
    [request setEntity:entity];
    request.resultType = NSDictionaryResultType;
    request.returnsDistinctResults = YES;
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    if(results.count==0)// no lo he insertado en base de datos!
    {
        return 1;
    }
    return [[[results objectAtIndex:0] valueForKey:@"idPedido"] intValue] + 1;
}

-(NSString*)claveDelProducto:(NSString*)nombre {
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"tipo"  ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"nombre"  ascending:YES]];
    NSManagedObjectContext *moc = [app managedObjectContext];
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"Catalogo" inManagedObjectContext:moc];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"nombre == %@",nombre ];
    [request setPredicate:predicate];
    
    
    
    request.resultType = NSDictionaryResultType;
    request.returnsDistinctResults = YES;
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    if(results.count>0)
    {
        return [[results objectAtIndex:0] valueForKey:@"clave"];
    }
    return @"";
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

-(void)guardaYEnviaBoton {
    //primero grabo con sincronizado en 0
    //si hay internet, entonces, en otro metodo sincronizo
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *moc = [app managedObjectContext];
    NSError *error2 = nil;
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"Pedidos" inManagedObjectContext:moc];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int idPedido =[self getNextIdPedido];
    NSString *nombreDelArchivo = [NSString stringWithFormat:@"%@-%d.jpg",[defaults valueForKey:@"idGema"], idPedido ];
    
    int idGema = [[defaults valueForKey:@"idGema"]intValue];
    int idCliente = [[defaults valueForKey:@"idCliente_PedidoActual"]intValue];
    float totalAux =  [[defaults valueForKey:@"Total_PedidoActual"]floatValue];
    float pagoInicialAux =  [[defaults valueForKey:@"PagoInicial_PedidoActual"]floatValue];
    
    int numPagos = [[defaults valueForKey:@"NumeroDePagos_PedidoActual"] intValue];
    int inversion = [[defaults valueForKey:@"Inversion_PedidoActual"] intValue];
    _dataList = [defaults valueForKey:@"Articulos_PedidoActual"];
    NSMutableString *hardcodeo = [[NSMutableString alloc] initWithString:@""];
    NSString *clave = @"";
    for(NSString *key in [_dataList allKeys])
    {
        NSDictionary * dic = [_dataList objectForKey:key];
        int unidades = [[dic valueForKey:@"unidades"] intValue];
        NSString *nombre = [dic valueForKey:@"nombre"];
        int contadoOCredito = [[dic valueForKey:@"contadoOCredito"] intValue];
        NSString *palabra=@"Crédito";
        if(contadoOCredito==1)
        {
            palabra=@"Contado";
        }
        float precio = [[dic valueForKey:@"precio"] floatValue];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        clave = [self claveDelProducto:nombre];
        [hardcodeo appendFormat:@"%d|%@|%d|%.2f|",unidades,clave,contadoOCredito,precio ];
    }
    [object setValue:[hardcodeo description] forKey:@"hardcodeo"];
    int numArticulos = (int)_dataList.count;
    [object setValue:[NSNumber numberWithInt:numArticulos] forKey:@"numArticulos"];
    
    NSNumber *totalNumber = [NSNumber numberWithFloat:totalAux];
    [object setValue:totalNumber forKey:@"total"];
    NSNumber *pagoInicialNumber = [NSNumber numberWithFloat:pagoInicialAux];
    [object setValue:pagoInicialNumber forKey:@"pagoInicial"];
    NSNumber *idGemaNumber = [NSNumber numberWithInt:idGema];
    [object setValue:idGemaNumber forKey:@"idGema"];
    NSNumber *idClienteNumber = [NSNumber numberWithInt:idCliente];
    [object setValue:idClienteNumber forKey:@"idCliente"];
    [object setValue:[defaults valueForKey:@"FechaPedido_PedidoActual"] forKey:@"fechaPedido"];
    [object setValue:[defaults valueForKey:@"FechaEntrega_PedidoActual"] forKey:@"fechaEntrega"];
    [object setValue:[NSNumber numberWithInt:numPagos] forKey:@"numPagos"];
    [object setValue:[NSNumber numberWithInt:inversion] forKey:@"inversion"];
    
    NSNumber *zero = [NSNumber numberWithInt:0];
    [object setValue:zero forKey:@"sincronizado"];
    
    NSNumber *someNumber = [NSNumber numberWithInt:idPedido];
    [object setValue:someNumber forKey:@"idPedido"];
    
    if (![moc save:&error2]) {
        NSLog(@"Failed to save - error: %@", [error2 localizedDescription]);
    }
    //guardar imagen en local!
    UIImage *firmaDelCliente = [self glToUIImage];
    
    UIImage * portraitImage = [[UIImage alloc] initWithCGImage: firmaDelCliente.CGImage
                                                         scale: 1.0
                                                   orientation: UIImageOrientationLeft];
    
    
    
    
    NSData *jpgData = UIImageJPEGRepresentation(portraitImage, 0.50f);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:nombreDelArchivo]; //Add the file name
    [jpgData writeToFile:filePath atomically:YES]; //Write the file
    
    
    NSString *mensaje=@"";
    if(app.hasInternet)
    {
        [app trySincronizarTodo];
        mensaje=@"Pedido guardado";
    }
    else
    {
        mensaje=@"Pedido guardado en el talonario local, recuerda sincronizar después que tengas internet";
    }
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:@"Integrity"
                                 message:mensaje
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Ok"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                                 [self.navigationController popToRootViewControllerAnimated:YES];
                             }];
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
}
-(void)borrarFirma {
    [(PaintingView *)self.view erase];
    //borrar firma
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _dataList = [defaults valueForKey:@"Articulos_PedidoActual"];
    UIBarButtonItem *borrarBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(borrarFirma)];
    
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(guardaYEnviaBoton)];
    self.navigationItem.rightBarButtonItems = @[borrarBar, bar];
    
    self.title=@"Firma de conformidad";
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
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"desabilita"];
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


@end
