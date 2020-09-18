//
//  AppDelegate.m
//  LGSideMenuControllerDemo
//

#import "AppDelegate.h"
//#import "ChooseNavigationController.h"
#import "Reachability.h"
#import "MainViewController.h"
#import "ViewController.h"
#import "NavigationController.h"

@interface AppDelegate ()
@property (nonatomic) Reachability *internetReachability;
@end

@implementation AppDelegate
@synthesize hasInternet=_hasInternet;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    [self updateInterfaceWithReachability:self.internetReachability];
    
    self.firstRun=NO;
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"AlreadyRan"] ) {
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"AlreadyRan"];
        [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:@"idGema"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"name"];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"desabilita"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"email"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.firstRun = YES;
    }
    
    
    
    
    UIViewController *viewController;
    viewController = [ViewController new];
    NavigationController *navigationController = [[NavigationController alloc] initWithRootViewController:viewController];
    
    MainViewController *mainViewController = [MainViewController new];
    mainViewController.rootViewController = navigationController;
    [mainViewController setupWithType:11];
    

//    ChooseNavigationController *navigationController = [ChooseNavigationController new];

    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = mainViewController;
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self saveContext];
}

- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}


- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    if (reachability == self.internetReachability)
    {
        [self configureTextField:reachability];
    }
    
}


- (void)configureTextField:(Reachability *)reachability
{
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    BOOL connectionRequired = [reachability connectionRequired];
    //   NSString* statusString = @"";
    
    switch (netStatus)
    {
        case NotReachable:        {
            _hasInternet=NO;
            break;
        }
            
        case ReachableViaWWAN:        {
            _hasInternet=YES;
            // statusString = NSLocalizedString(@"Reachable WWAN", @"");
            // imageView.image = [UIImage imageNamed:@"WWAN5.png"];
            break;
        }
        case ReachableViaWiFi:        {
            _hasInternet=YES;
            // statusString= NSLocalizedString(@"Reachable WiFi", @"");
            //    imageView.image = [UIImage imageNamed:@"Airport.png"];
            break;
        }
    }
    
    if (connectionRequired)
    {
        // NSString *connectionRequiredFormatString = NSLocalizedString(@"%@, Connection Required", @"Concatenation of status string with connection requirement");
        // statusString= [NSString stringWithFormat:connectionRequiredFormatString, statusString];
    }
    //   textField.text= statusString;
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "gc.deor.test" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"integrity" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"integrity.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}
#pragma mark - sincronizaciones
- (void) trySincronizaClientes {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sincronizado == 0"];
    
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"Clientes" inManagedObjectContext:moc];
    [request setEntity:entity];
    [request setPredicate:predicate];
    
    request.resultType = NSDictionaryResultType;
    request.returnsDistinctResults = YES;
    
    NSError *error = nil;
    
    NSArray *results = [moc executeFetchRequest:request error:&error];
    if(results.count>0)// sincronizar
    {
        if(self.hasInternet)
        {
            for(NSManagedObject *man in results)
            {
                dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
                    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
                    
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    NSString *urlString = @"http://integritycapacitacion.org/app.php";
                    NSString *post = [NSString stringWithFormat:@"servicio=app&accion=nuevoCliente&idGema=%@&idCliente=%@&nombre=%@&correo=%@&telefono=%@&calle=%@&colonia=%@&ciudad=%@&estado=%@&cp=%@&rfc=%@",[defaults valueForKey:@"idGema"],[man valueForKey:@"idCliente"],[man valueForKey:@"nombre"],[man valueForKey:@"correo"],[man valueForKey:@"telefono"],[man valueForKey:@"calle"],[man valueForKey:@"colonia"],[man valueForKey:@"ciudad"],[man valueForKey:@"estado"],[man valueForKey:@"cp"],[man valueForKey:@"rfc"] ];
                    
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
                    NSNumber *uno = [NSNumber numberWithInt:1];
                    [man setValue:uno forKey:@"sincronizado"];
                    if (![moc save:&error]) {
                        NSLog(@"Failed to save - error: %@", [error localizedDescription]);
                    }
                NSLog(@"idCliente: %@ sincronizado",[man valueForKey:@"idCliente"]);
                                                                                   
                                                                                   
                                                                                   
                                                                                   
                                                                                   
                                                                               }
                                                                           }
                                                                       }];
                    
                    [dataTask resume];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // Code to update the UI/send notifications based on the results of the background processing
                        //            [_message show];
                        
                        
                    });
                    
                });
            }
        }
    }
}
- (NSString *)documentsPathForFileName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    return [documentsPath stringByAppendingPathComponent:name];
}
- (void) trySincronizaPedidos {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sincronizado == 0"];
    
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"Pedidos" inManagedObjectContext:moc];
    [request setEntity:entity];
    [request setPredicate:predicate];
    
    request.resultType = NSDictionaryResultType;
    request.returnsDistinctResults = YES;
    
    NSError *error = nil;
    
    NSArray *results = [moc executeFetchRequest:request error:&error];
    if(results.count>0)// sincronizar
    {
        if(self.hasInternet)
        {
            for(NSManagedObject *man in results)
            {
                dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
                    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
                    
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    NSString *urlString = @"http://integritycapacitacion.org/app.php";
                    /*
                     $idGema = $_POST['idGema'];
                     $idCliente = $_POST['idCliente'];
                     $hardcodeo = $_POST['hardcodeo'];
                     $idPedido = $_POST['idPedido'];
                     $total = $_POST['total'];
                     $numArticulos = $_POST['numArticulos'];
                     $pagoInicial = $_POST['pagoInicial'];
                     $numPagos = $_POST['numPagos'];
                     $inversion = $_POST['inversion'];
                     $fechaPedido = $_POST['fechaPedido'];
                     $fechaEntrega = $_POST['fechaEntrega'];
                     */
                    NSString *filename = [NSString stringWithFormat:@"%@-%@",[defaults valueForKey:@"idGema"],[man valueForKey:@"idPedido"]];
                    //save firma en internet!
                    NSString *filePath = [self documentsPathForFileName:[NSString stringWithFormat:@"%@.jpg",filename]];
                    NSData *dataImage = [NSData dataWithContentsOfFile:filePath];
                    //UIImage *image = [UIImage imageWithData:dataImage];
                    
                    
                    urlString = @"http://integritycapacitacion.org/guardaImagenClientes.php";
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
                        urlString = @"http://integritycapacitacion.org/app.php";
                        NSString *post = [NSString stringWithFormat:@"servicio=app&accion=nuevoPedido&idGema=%@&idCliente=%@&idPedido=%@&hardcodeo=%@&total=%@&numArticulos=%@&pagoInicial=%@&numPagos=%@&inversion=%@&fechaPedido=%@&fechaEntrega=%@",[defaults valueForKey:@"idGema"],[man valueForKey:@"idCliente"],[man valueForKey:@"idPedido"],[man valueForKey:@"hardcodeo"],[man valueForKey:@"total"],[man valueForKey:@"numArticulos"],[man valueForKey:@"pagoInicial"],[man valueForKey:@"numPagos"],[man valueForKey:@"inversion"],[man valueForKey:@"fechaPedido"],[man valueForKey:@"fechaEntrega"]];
                        
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
                                                                                       NSNumber *uno = [NSNumber numberWithInt:1];
                                                                                       [man setValue:uno forKey:@"sincronizado"];
                                                                                       if (![moc save:&error]) {
                                                                                           NSLog(@"Failed to save - error: %@", [error localizedDescription]);
                                                                                       }
                                                                                       NSLog(@"idPedido: %@ sincronizado",[man valueForKey:@"idPedido"]);
                                                                                       
                                                                                   }
                                                                               }

                                                                           }];
                        [dataTask resume];
                        
                    }
                    
                                                          
                    
                    
                    
                    
                    
                    
                    
                    
                    
                                   //}];
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // Code to update the UI/send notifications based on the results of the background processing
                        //            [_message show];
                        
                        
                    });
                    
                });
            }
        }
    }
}
- (void) trySincronizarTodo {
    [self trySincronizaClientes];
    [self trySincronizaPedidos];
}
#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


@end
