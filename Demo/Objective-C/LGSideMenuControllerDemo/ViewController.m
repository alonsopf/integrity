//
//  ViewController.m
//  LGSideMenuControllerDemo
//

#import "ViewController.h"
#import "ChooseNavigationController.h"
#import "UIViewController+LGSideMenuController.h"
#import "AppDelegate.h"
#import "LoadingView.h"
#import "NuevoClienteViewController.h"
#import "MainViewController.h"
#import "LeftViewController.h"
@interface ViewController ()

//login
@property (strong, nonatomic) UIImageView *logoIntegrity;
@property (strong, nonatomic) UITextField *idGema_input;
@property (strong, nonatomic) UITextField *pass_input;
@property (strong, nonatomic) UIButton *entrarButton;

//globales
@property (strong, nonatomic) LoadingView *load;
@property (strong, nonatomic) UIScrollView *scroll;
@property int wGlobal;
@property int hGlobal;
@end

@implementation ViewController

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"";

        self.view.backgroundColor = [UIColor colorWithRed:227.0f/255.0f green:227.0f/255.0f blue:227.0f/255.0f alpha:1.0f];
        

        // -----

       /* self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"imageRoot"]];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        [self.view addSubview:self.imageView];

        self.button = [UIButton new];
        self.button.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        [self.button setTitle:@"Show Choose Controller" forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0] forState:UIControlStateHighlighted];
        [self.button addTarget:self action:@selector(showChooseController) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.button];
*/
        // -----

        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menú"
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(showLeftView)];

       /* self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Right"
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(showRightView)];
        */
    }
    return self;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

   // self.imageView.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));

    //self.button.frame = CGRectMake(0.0, CGRectGetHeight(self.view.frame)-44.0, CGRectGetWidth(self.view.frame), 44.0);
}
#pragma mark - TextField Delegate
-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    if(textField==self.idGema_input || textField==self.pass_input)
    {
        float dif = _wGlobal/3.5f;
        self.idGema_input.frame = CGRectMake(self.idGema_input.frame.origin.x,self.idGema_input.frame.origin.y-dif,self.idGema_input.frame.size.width,self.idGema_input.frame.size.height);
        self.pass_input.frame = CGRectMake(self.pass_input.frame.origin.x,self.pass_input.frame.origin.y-dif,self.pass_input.frame.size.width,self.pass_input.frame.size.height);
        self.logoIntegrity.frame = CGRectMake(self.logoIntegrity.frame.origin.x,self.logoIntegrity.frame.origin.y-dif,self.logoIntegrity.frame.size.width,self.logoIntegrity.frame.size.height);
        self.entrarButton.frame = CGRectMake(self.entrarButton.frame.origin.x,self.entrarButton.frame.origin.y-dif,self.entrarButton.frame.size.width,self.entrarButton.frame.size.height);
    }
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if(textField==self.idGema_input || textField==self.pass_input)
    {
        float dif = _wGlobal/3.5f;
        self.idGema_input.frame = CGRectMake(self.idGema_input.frame.origin.x,self.idGema_input.frame.origin.y+dif,self.idGema_input.frame.size.width,self.idGema_input.frame.size.height);
        self.pass_input.frame = CGRectMake(self.pass_input.frame.origin.x,self.pass_input.frame.origin.y+dif,self.pass_input.frame.size.width,self.pass_input.frame.size.height);
        self.logoIntegrity.frame = CGRectMake(self.logoIntegrity.frame.origin.x,self.logoIntegrity.frame.origin.y+dif,self.logoIntegrity.frame.size.width,self.logoIntegrity.frame.size.height);
        self.entrarButton.frame = CGRectMake(self.entrarButton.frame.origin.x,self.entrarButton.frame.origin.y+dif,self.entrarButton.frame.size.width,self.entrarButton.frame.size.height);
    }
    return YES;
}
#pragma mark - Ciclo de vida
-(void)handleSingleTap:(id)sender{
    [self.pass_input resignFirstResponder];
    [self.idGema_input resignFirstResponder];
}
-(void)checarSesion {
    int idGema = [[[NSUserDefaults standardUserDefaults] valueForKey:@"idGema"] intValue];
    if(idGema==-1)
    {
        [self ponLogin];
    }
    else
    {
        [self ponNuevoCliente];
    }
}
-(void)viewWillAppear:(BOOL)animated   {
    [super viewWillAppear:animated];
    [self checarSesion];
}
-(void)viewDidLoad {
    [super viewDidLoad];
    _wGlobal = self.view.frame.size.width;
    _hGlobal = self.view.frame.size.height;
    self.title=@"";
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
    
}
-(void)ponNuevoCliente{
    for(UIView *b in self.view.subviews)
    {
        [b removeFromSuperview];
    }
    float margen = 1.0f/8.0f;
    int empiezo = 70;
   // int espacioEntreObjetosVertical = 10;
    
    self.logoIntegrity = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    self.logoIntegrity.frame = CGRectMake(margen*_wGlobal,empiezo,_wGlobal*6*margen,_hGlobal*3.0*margen);
    self.logoIntegrity.clipsToBounds = YES;
    [self.view addSubview:self.logoIntegrity];
    
    UILabel *labelSesion = [[UILabel alloc] initWithFrame:CGRectMake(margen*_wGlobal-20, empiezo+self.logoIntegrity.frame.size.height, _wGlobal*6*margen+40, _hGlobal*3.0*margen)];
    labelSesion.numberOfLines=0;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    labelSesion.text=[NSString stringWithFormat:@"Logueado como: %@\nCorreo: %@",[defaults valueForKey:@"name"],[defaults valueForKey:@"email"]];
    [self.view addSubview:labelSesion];
    
    /*
    MainViewController *mainViewController = (MainViewController *)self.sideMenuController;
    
    NuevoClienteViewController *viewController = [[NuevoClienteViewController alloc] initWithNibName:@"NuevoClienteViewController" bundle:[NSBundle mainBundle]];
    
    UINavigationController *navigationController = (UINavigationController *)mainViewController.rootViewController;
    [navigationController pushViewController:viewController animated:YES];
    */
    
}
#pragma mark - Toolbar numberpad Hardcords
- (void)cancelNumberPad:(UIBarButtonItem*)textField
{
    [self.idGema_input resignFirstResponder];
    [self.pass_input resignFirstResponder];
}


- (void)doneWithNumberPad:(UIBarButtonItem*)textField
{
    
    if([self.idGema_input isFirstResponder])
    {
        [self.idGema_input resignFirstResponder];
        [self.pass_input becomeFirstResponder];
    } else{
        if([self.pass_input isFirstResponder])
        {
            [self.idGema_input resignFirstResponder];
            [self.pass_input resignFirstResponder];
            [self tryLogin];
        }
    }
    
}
#pragma mark - UI Hardcords
-(void)searchAndDestroy {
    for(UIView *view in self.view.subviews)
    {
        [view removeFromSuperview];
    }
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    if(textField==self.pass_input)
    {
        [self tryLogin];
        
    }
    return YES;
}

-(void)ponLogin {
    [self searchAndDestroy];
    float margen = 1.0f/8.0f;
    int empiezo = 70;
    int espacioEntreObjetosVertical = 10;
    
    self.logoIntegrity = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    self.logoIntegrity.frame = CGRectMake(margen*_wGlobal,empiezo,_wGlobal*6*margen,_hGlobal*3.0*margen);
    self.logoIntegrity.clipsToBounds = YES;
    [self.view addSubview:self.logoIntegrity];
    
    empiezo+=self.logoIntegrity.frame.size.height+espacioEntreObjetosVertical;
    
    UIToolbar  *numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, _wGlobal, _hGlobal/14.0f)];
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancelar" style:UIBarButtonItemStylePlain target:self action:@selector(cancelNumberPad:)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Siguiente" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad:)],
                           nil];
    
    self.idGema_input = [[UITextField alloc] initWithFrame:CGRectMake(margen*_wGlobal, empiezo, _wGlobal*6*margen, _hGlobal*0.5*margen)];
    self.idGema_input.inputAccessoryView = numberToolbar;
    [self.idGema_input setKeyboardType:UIKeyboardTypeNumberPad];
    [self.idGema_input setPlaceholder:@"Escribe tu idGema"];
    [self.idGema_input setFont:[UIFont systemFontOfSize:16.0f]];
    [self.idGema_input  setBorderStyle:UITextBorderStyleRoundedRect];
    self.idGema_input.returnKeyType = UIReturnKeyNext;
    self.idGema_input.delegate=self;
    [self.view addSubview:self.idGema_input];
    
    empiezo+=self.idGema_input.frame.size.height+espacioEntreObjetosVertical;
    
    
    self.pass_input = [[UITextField alloc] initWithFrame:CGRectMake(margen*_wGlobal, empiezo, _wGlobal*6*margen, _hGlobal*0.5*margen)];
    [self.pass_input setSecureTextEntry:YES];
    //[self.pass_input setKeyboardType:UIKeyboardTypeNumberPad];
    [self.pass_input setKeyboardType:UIKeyboardTypeAlphabet];
    [self.pass_input setPlaceholder:@"Escribe tu password"];
    [self.pass_input setFont:[UIFont systemFontOfSize:16.0f]];
    [self.pass_input  setBorderStyle:UITextBorderStyleRoundedRect];
    self.pass_input.delegate=self;
    //self.pass_input.inputAccessoryView = numberToolbar;
    self.pass_input.returnKeyType = UIReturnKeyGo;
    [self.view addSubview:self.pass_input];

    
    
    
    empiezo+=self.pass_input.frame.size.height+espacioEntreObjetosVertical;
    
    
    self.entrarButton = [[UIButton alloc] initWithFrame:CGRectMake(margen*_wGlobal, empiezo, _wGlobal*6*margen, _hGlobal*0.5*margen)];
    [self.entrarButton setTitle:@"Entrar" forState:UIControlStateNormal];
    [self.entrarButton setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:136.0f/255.0f blue:204.0f/255.0f alpha:1.0f]];
    [self.entrarButton addTarget:self action:@selector(tryLogin) forControlEvents:UIControlEventTouchUpInside];
    //[self.entrarButton setFont:[UIFont systemFontOfSize:16.0f]];
    //[self.entrarButton  setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:self.entrarButton];
    
    empiezo+=self.entrarButton.frame.size.height+espacioEntreObjetosVertical;
    
    UIButton *entraInvitado = [UIButton buttonWithType:UIButtonTypeSystem];
    entraInvitado.frame = CGRectMake(margen*_wGlobal, empiezo, _wGlobal*6*margen, _hGlobal*0.5*margen);
    [entraInvitado setTitle:@"Entrar como invitado" forState:UIControlStateNormal];
    [entraInvitado setBackgroundColor:[UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.7f]];
    
    [entraInvitado setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [entraInvitado addTarget:self action:@selector(entraInvitado) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:entraInvitado];

}
#pragma mark - POSTS
-(void)entraInvitado {
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Catalogo"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    
    [app.persistentStoreCoordinator executeRequest:delete withContext:app.managedObjectContext error:&deleteError];
    [app saveContext];
    
    NSFetchRequest *requestCliente = [[NSFetchRequest alloc] initWithEntityName:@"Clientes"];
    NSBatchDeleteRequest *deleteCliente = [[NSBatchDeleteRequest alloc] initWithFetchRequest:requestCliente];
    
    
    
    [app.persistentStoreCoordinator executeRequest:deleteCliente withContext:app.managedObjectContext error:&deleteError];
    [app saveContext];
    
    NSFetchRequest *requestPedidos = [[NSFetchRequest alloc] initWithEntityName:@"Pedidos"];
    NSBatchDeleteRequest *deletePedidos = [[NSBatchDeleteRequest alloc] initWithFetchRequest:requestPedidos];
    
    
    
    [app.persistentStoreCoordinator executeRequest:deletePedidos withContext:app.managedObjectContext error:&deleteError];
    [app saveContext];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"Usuario invitado" forKey:@"name"];
    [defaults setObject:@"contacto@integritycapacitacion.org" forKey:@"email"];
    [defaults setInteger:1234567 forKey:@"idGema"];
    [defaults synchronize];
    MainViewController *mainViewController = (MainViewController *)self.sideMenuController;
    LeftViewController *left = (LeftViewController*)mainViewController.leftViewController;
    [left reloadMenu];
    [self ponNuevoCliente];
}
-(void)tryLogin {
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (app.hasInternet)
    {
        _load = [LoadingView loadingViewInView:self.view];
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
            
            
            NSString *urlString = @"http://integritycapacitacion.org/app.php";
            
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            NSData *nsdata = [self.pass_input.text dataUsingEncoding:NSUTF8StringEncoding];
            
            // Get NSString from NSData object in Base64
            NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
            
            NSString *post = [NSString stringWithFormat:@"servicio=app&accion=access&idGema=%@&pass=%@",self.idGema_input.text, base64Encoded ];
            
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            
            NSString *postLength = [NSString stringWithFormat:@"%d", (int)[postData length]];
            
            
            
            NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
            
            NSString* encodedUrl = [urlString stringByAddingPercentEncodingWithAllowedCharacters:
                                    set];
            
            NSURL * url = [NSURL URLWithString:encodedUrl];
            NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
            [urlRequest setHTTPMethod:@"POST"];//GET
            [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [urlRequest setHTTPBody:postData];
            NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                               completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                   if(error == nil)
                                                                   {
                                                                       NSError* error;
                                                                       NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                                       int success = [[json objectForKey:@"success"] intValue];
                                                                       if(success==1)
                                                                       {
            NSString *name = [json objectForKey:@"name"];
            NSString *email = [json objectForKey:@"email"];
            [defaults setObject:name forKey:@"name"];
            [defaults setObject:email forKey:@"email"];
            [defaults setInteger:[self.idGema_input.text intValue] forKey:@"idGema"];
            [defaults synchronize];
            NSArray *catalago = [json objectForKey:@"lista"];
            int i;
            NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Catalogo"];
            NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
                                                                           
            NSError *deleteError = nil;
                                             
            [app.persistentStoreCoordinator executeRequest:delete withContext:app.managedObjectContext error:&deleteError];
            [app saveContext];
                                                                           
            NSFetchRequest *requestCliente = [[NSFetchRequest alloc] initWithEntityName:@"Clientes"];
            NSBatchDeleteRequest *deleteCliente = [[NSBatchDeleteRequest alloc] initWithFetchRequest:requestCliente];
                                                                           
                                                                           
                                                                           
            [app.persistentStoreCoordinator executeRequest:deleteCliente withContext:app.managedObjectContext error:&deleteError];
            [app saveContext];
                                                                           
            NSFetchRequest *requestPedidos = [[NSFetchRequest alloc] initWithEntityName:@"Pedidos"];
            NSBatchDeleteRequest *deletePedidos = [[NSBatchDeleteRequest alloc] initWithFetchRequest:requestPedidos];
                                                                           
                                                                           
                                                                           
            [app.persistentStoreCoordinator executeRequest:deletePedidos withContext:app.managedObjectContext error:&deleteError];
            [app saveContext];
                                                                           
                                                                           
                                                                           
                                                                           
            NSManagedObjectContext *moc = [app managedObjectContext];
            //NSFetchRequest *requestFetch = [[NSFetchRequest alloc] init];
            NSError *error2 = nil;
               /*
                @dynamic clave;
                @dynamic nombre;
                @dynamic tipo;
                @dynamic listaColportor;
                @dynamic contadoColportor;
                @dynamic contadoPublico;
                @dynamic creditoPublico;
                @dynamic agotado;
                */
            //NSEntityDescription *entity =[NSEntityDescription entityForName:@"Catalogo" inManagedObjectContext:moc];
            for(i=0;i<catalago.count;i++)
            {
                NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"Catalogo" inManagedObjectContext:moc];
                NSDictionary *cat = [catalago objectAtIndex:i];
                
                
                [object setValue:[cat valueForKey:@"nombre"] forKey:@"nombre"];
                [object setValue:[cat valueForKey:@"clave"] forKey:@"clave"];
                NSNumber *tipoInt = [NSNumber numberWithInt:[[cat valueForKey:@"tipo"] intValue]];
                [object setValue:tipoInt forKey:@"tipo"];
                NSNumber *listaColportor = [NSNumber numberWithFloat:[[cat valueForKey:@"listaColportor"] floatValue]];
                [object setValue:listaColportor forKey:@"listaColportor"];
                NSNumber *contadoColportor = [NSNumber numberWithFloat:[[cat valueForKey:@"contadoColportor"] floatValue]];
                [object setValue:contadoColportor forKey:@"contadoColportor"];
                NSNumber *contadoPublico = [NSNumber numberWithFloat:[[cat valueForKey:@"contadoPublico"] floatValue]];
                
                [object setValue:contadoPublico forKey:@"contadoPublico"];
                NSNumber *creditoPublico = [NSNumber numberWithFloat:[[cat valueForKey:@"creditoPublico"] floatValue]];
                
                [object setValue:creditoPublico forKey:@"creditoPublico"];
                NSNumber *agotado = [NSNumber numberWithInt:[[cat valueForKey:@"agotado"] intValue]];
                
                [object setValue:agotado forKey:@"agotado"];
                
                if (![moc save:&error2]) {
                    NSLog(@"Failed to save - error: %@", [error2 localizedDescription]);
                }

                //borrar todo de core data de la entidad "catalogo"
                //poner en core adta esta lista
                
                //despues programar el menu, agregar nombre y correo y opcion de nuevo cliente
                //poner boton de guardar cliente y que funcione
                
                //luego que pueda editar clientes en la lista
                //en nuevo pedido, que cargue la lista de clientes y el catalogo, va escogiendo del catalogo
                
                //se guarda en core data, si tiene internet postea y manda el archivo, si no no
                //poner un boton de sincronizar, y poner de otro color que le falta de sincronizar
                
                //cuando aplana el boton de "sincronizar", veo por todos los pedidos que no estan sincronizados
                //y los sincronizo, cuando se sincronizan, se hace el post y se manda el recibo con los datos
                
                
            }
            NSArray *clientes = [json objectForKey:@"clientes"];
            for(i=0;i<clientes.count;i++)
            {
                NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"Clientes" inManagedObjectContext:moc];
                NSDictionary *cat = [clientes objectAtIndex:i];
                [object setValue:[cat valueForKey:@"nombre"] forKey:@"nombre"];
                [object setValue:[cat valueForKey:@"calle"] forKey:@"calle"];
                [object setValue:[cat valueForKey:@"ciudad"] forKey:@"ciudad"];
                [object setValue:[cat valueForKey:@"colonia"] forKey:@"colonia"];
                [object setValue:[cat valueForKey:@"correo"] forKey:@"correo"];
                [object setValue:[cat valueForKey:@"cp"] forKey:@"cp"];
                [object setValue:[cat valueForKey:@"rfc"] forKey:@"rfc"];
                [object setValue:[cat valueForKey:@"estado"] forKey:@"estado"];
                [object setValue:[cat valueForKey:@"telefono"] forKey:@"telefono"];
                NSNumber *numero = [NSNumber numberWithInt:1];
                [object setValue:numero forKey:@"sincronizado"];
                NSNumber *idClienteInt = [NSNumber numberWithInt:[[cat valueForKey:@"idCliente"] intValue] ];
                [object setValue:idClienteInt forKey:@"idCliente"];
                if (![moc save:&error2]) {
                    NSLog(@"Failed to save - error: %@", [error2 localizedDescription]);
                }
            }
            NSArray *pedidos = [json objectForKey:@"pedidos"];
            for(i=0;i<pedidos.count;i++)
            {
                NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"Pedidos" inManagedObjectContext:moc];
                NSDictionary *cat = [pedidos objectAtIndex:i];
                NSNumber *pagoInicialNumber = [NSNumber numberWithFloat:[[cat valueForKey:@"pagoInicial"] floatValue]];
                [object setValue:pagoInicialNumber forKey:@"pagoInicial"];
                
                NSNumber *totalNumber = [NSNumber numberWithFloat:[[cat valueForKey:@"total"] floatValue]];
                [object setValue:totalNumber forKey:@"total"];
                NSNumber *inversionNumber = [NSNumber numberWithInt:[[cat valueForKey:@"inversion"] intValue]];
                [object setValue:inversionNumber forKey:@"inversion"];
                NSNumber *numPagosNumber = [NSNumber numberWithInt:[[cat valueForKey:@"numPagos"] intValue]];
                [object setValue:numPagosNumber forKey:@"numPagos"];
                NSNumber *numArticulosNumber = [NSNumber numberWithInt:[[cat valueForKey:@"numArticulos"] intValue]];
                [object setValue:numArticulosNumber forKey:@"numArticulos"];
                [object setValue:[cat valueForKey:@"hardcodeo"] forKey:@"hardcodeo"];
                [object setValue:[cat valueForKey:@"fechaPedido"] forKey:@"fechaPedido"];
                [object setValue:[cat valueForKey:@"fechaEntrega"] forKey:@"fechaEntrega"];
                
                int idPedido = [[cat valueForKey:@"idPedido"] intValue];
                NSNumber *idPedidoNumber = [NSNumber numberWithInt:idPedido];
                [object setValue:idPedidoNumber forKey:@"idPedido"];
               
                
                int idGema = [self.idGema_input.text intValue];
                NSNumber *idGemaNumber = [NSNumber numberWithInt:idGema];
                [object setValue:idGemaNumber forKey:@"idGema"];
                NSNumber *numero = [NSNumber numberWithInt:1];
                [object setValue:numero forKey:@"sincronizado"];
                NSNumber *idClienteInt = [NSNumber numberWithInt:[[cat valueForKey:@"idCliente"] intValue] ];
                [object setValue:idClienteInt forKey:@"idCliente"];
                if (![moc save:&error2]) {
                    NSLog(@"Failed to save - error: %@", [error2 localizedDescription]);
                }
            }
           [self ponNuevoCliente];
                                                                           
                                                                   
            MainViewController *mainViewController = (MainViewController *)self.sideMenuController;
            LeftViewController *left = (LeftViewController*)mainViewController.leftViewController;
            [left reloadMenu];
                                                                           NSLog(@"%s","Inicio de sesión exitoso");                                                                           //[self performSegueWithIdentifier:@"vesMenuPeriodos" sender:nil];
                                                                           
                                                                       }
                                                                       if(success==2)
                                                                       {
                                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                                               
                                                                               UIAlertController * view=   [UIAlertController
                                                                                                            alertControllerWithTitle:@"Integrity"
                                                                                                            message:@"El idGema no existe"
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
                                                                               
                                                                           });
                                                                           
                                                                       }
                                                                       if(success==3)
                                                                       {
                                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                                               
                                                                               UIAlertController * view=   [UIAlertController
                                                                                                            alertControllerWithTitle:@"Integrity"
                                                                                                            message:@"Esta mal el password"
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
                                                                               
                                                                           });
                                                                           
                                                                           NSLog(@"%s","esta bien el idGema, pero no el password");
                                                                       }
                                                                       if(success==0)
                                                                       {
                                                                           NSLog(@"%s","algo anda mal");
                                                                       }
                                                                   }
                                                                   if(_load!=nil)
                                                                   {
                                                                       [_load removeView];
                                                                   }
                                                               }];
            
            [dataTask resume];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Code to update the UI/send notifications based on the results of the background processing
                //            [_message show];
                
                
            });
            
        });
    }
    else
    {
        [self showNoHayInternet];
    }
}
-(void)showNoHayInternet
{
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:@"Integrity"
                                 message:@"No hay una conexión disponible de internet, favor de conectarse a internet para iniciar sesión."
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

#pragma mark - Cosas del menú

- (void)showLeftView {
    [self.sideMenuController showLeftViewAnimated:YES completionHandler:nil];
}

- (void)showRightView {
   // [self.sideMenuController showRightViewAnimated:YES completionHandler:nil];
}

- (void)showChooseController {
    ChooseNavigationController *navigationController = [ChooseNavigationController new];

    UIWindow *window = UIApplication.sharedApplication.delegate.window;
    window.rootViewController = navigationController;

    [UIView transitionWithView:window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:nil
                    completion:nil];
}

@end
