//
//  TalonarioDetalleTableViewController.m
//  Integrity
//
//  Created by Fernando Alonso Pecina on 01/06/17.
//  Copyright © 2017 Grigory Lutkov. All rights reserved.
//

#import "TalonarioDetalleTableViewController.h"
#import "AppDelegate.h"
@interface TalonarioDetalleTableViewController ()

@end

@implementation TalonarioDetalleTableViewController
@synthesize idPedido=_idPedido,titulosList=_titulosList,subtitulosList=_subtitulosList;

-(void)obtienePedido {
    [self.view endEditing:YES];
    if(_titulosList!=nil)
    {
        [_titulosList removeAllObjects];
    }
    if(_subtitulosList!=nil)
    {
        [_subtitulosList removeAllObjects];
    }
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"idPedido"  ascending:NO]];
    NSManagedObjectContext *moc = [app managedObjectContext];
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"Pedidos" inManagedObjectContext:moc];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idPedido == %@",_idPedido ];
    [request setPredicate:predicate];

    request.resultType = NSDictionaryResultType;
    request.returnsDistinctResults = YES;
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    
    if(results.count>0)// no lo he insertado en base de datos!
    {
        for(NSManagedObject *man in results)
        {
            /*
             
             @property (nonatomic) int16_t ;
             @property (nullable, nonatomic, copy)
            
             
             @property (nonatomic) int16_t sincronizado;
             */
            
            int idCliente = [[man valueForKey:@"idCliente"] intValue];
             NSFetchRequest *request = [[NSFetchRequest alloc] init];
            request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"idCliente"  ascending:NO]];
             NSEntityDescription *entity =[NSEntityDescription entityForName:@"Clientes" inManagedObjectContext:moc];
            [request setEntity:entity];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idCliente == %d",idCliente];
            [request setPredicate:predicate];
            
            request.resultType = NSDictionaryResultType;
            request.returnsDistinctResults = YES;
            
            NSArray *results2 = [moc executeFetchRequest:request error:&error];
            NSString *cliente = @"";
            if(results2.count>0)
            {
                cliente = [NSString stringWithFormat:@"%@",  [[[results2 objectAtIndex:0] valueForKey:@"nombre"] description]];
            }
            self.title=[NSString stringWithFormat:@"Folio: %@",  [man valueForKey:@"idPedido"]];
            
            
            
            
            [_titulosList addObject:cliente];
            [_subtitulosList addObject:@""];
            [_titulosList addObject:[NSString stringWithFormat:@"Fecha de pedido: %@",  [man valueForKey:@"fechaPedido"]]];
            [_subtitulosList addObject:@""];
            [_titulosList addObject:[NSString stringWithFormat:@"Fecha de entrega: %@",  [man valueForKey:@"fechaEntrega"]]];
            [_subtitulosList addObject:@""];
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            
            [_titulosList addObject:[NSString stringWithFormat:@"Total: %@",[formatter stringFromNumber:[NSNumber numberWithFloat:[[man valueForKey:@"total"] floatValue]]]]];
            [_subtitulosList addObject:@""];
            
            [_titulosList addObject:[NSString stringWithFormat:@"Pago inicial: %@",[formatter stringFromNumber:[NSNumber numberWithFloat:[[man valueForKey:@"pagoInicial"] floatValue]]]]];
            [_subtitulosList addObject:@""];
            [_titulosList addObject:[NSString stringWithFormat:@"# de pagos a crédito: %@",  [man valueForKey:@"numPagos"]]];
            [_subtitulosList addObject:@""];
            [_titulosList addObject:[NSString stringWithFormat:@"Cada %@ días",  [man valueForKey:@"inversion"]]];
            [_subtitulosList addObject:@""];
            
             [_titulosList addObject:[NSString stringWithFormat:@"%@ Artículos:",  [man valueForKey:@"numArticulos"]]];
            [_subtitulosList addObject:@""];
            NSString *hardcodeo =[man valueForKey:@"hardcodeo"];
            int numArticulos = [[man valueForKey:@"numArticulos"] intValue];
            int i;
            NSArray *cosas = [hardcodeo componentsSeparatedByString:@"|"];
            for(i=0;i<numArticulos;i++)
            {
                int auxi = i * 4;
                NSString *unidades = [cosas objectAtIndex:auxi];
                NSString *clave = [cosas objectAtIndex:auxi+1];
                NSString *contadoOCredito = [cosas objectAtIndex:auxi+2];
                NSString *precio = [cosas objectAtIndex:auxi+3];
                NSFetchRequest *request3 = [[NSFetchRequest alloc] init];
                NSEntityDescription *entity3 =[NSEntityDescription entityForName:@"Catalogo" inManagedObjectContext:moc];
                [request3 setEntity:entity3];
                NSPredicate *predicate3 = [NSPredicate predicateWithFormat:@"clave == %@",clave];
                [request3 setPredicate:predicate3];
                
                request3.resultType = NSDictionaryResultType;
                request3.returnsDistinctResults = YES;
                
                NSArray *results3 = [moc executeFetchRequest:request3 error:&error];
                NSString *producto = @"";
                NSString *sub = @"";
                NSString *palabra=@"Contado";
                if(![contadoOCredito isEqualToString:@"1"])
                {
                    palabra=@"Crédito";
                }
                if(results3.count>0)
                {
//                    producto = [NSString stringWithFormat:@"%@ %@",unidades,   [[[[results3 objectAtIndex:0] valueForKey:@"nombre"] description] substringToIndex:25] ];
                    producto = [NSString stringWithFormat:@"%@ %@",unidades,   [[[results3 objectAtIndex:0] valueForKey:@"nombre"] description]  ];
                    
                    
                    sub = [NSString stringWithFormat:@"%@ a %@ c/u",palabra, [formatter stringFromNumber:[NSNumber numberWithFloat:[precio floatValue]]]];
                }
                [_titulosList addObject:producto];
                [_subtitulosList addObject:sub];
                //[hardcodeo appendFormat:@"%d|%@|%d|%.2f|",unidades,clave,contadoOCredito,precio ];
            }//for articulos
        }
        [self.tableView reloadData];
    }
}
-(void)enviaBoton {
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(app.hasInternet) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        int idGema = [[defaults valueForKey:@"idGema"]intValue];
        
      
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
            
           // NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
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
            NSString *post = [NSString stringWithFormat:@"servicio=app&accion=mandaTalon&idGema=%d&idPedido=%@",idGema,_idPedido];
            
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
            NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                       NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                                       int success = [[json objectForKey:@"success"] intValue];
            if(success==1)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertController * view=   [UIAlertController
                                                 alertControllerWithTitle:@"Integrity"
                                                 message:@"Copia de talón enviada exitosamente"
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
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertController * view=   [UIAlertController
                                                 alertControllerWithTitle:@"Integrity"
                                                 message:@"Ocurrió un error, favor de contactar al administrador de integrity."
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
                                     message:@"No hay una conexión disponible de internet, favor de conectarse a internet para mandar copia del talón."
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
- (void)viewDidLoad {
    [super viewDidLoad];
    _titulosList = [[NSMutableArray alloc] init];
    _subtitulosList = [[NSMutableArray alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"TalonarioDetalleTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"letraGrande"];
    self.title=@"Detalle";
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(enviaBoton)];
    self.navigationItem.rightBarButtonItems = @[bar];
    
    [self obtienePedido];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titulosList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"letraGrande" forIndexPath:indexPath];
    cell.textLabel.text=[_titulosList objectAtIndex:indexPath.row];
    cell.detailTextLabel.text=[_subtitulosList objectAtIndex:indexPath.row];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
