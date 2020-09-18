//
//  RevisarViewController.m
//  Integrity
//
//  Created by Fernando Alonso Pecina on 31/05/17.
//  Copyright © 2017 Grigory Lutkov. All rights reserved.
//

#import "RevisarViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "FirmaClienteViewController.h"
@interface RevisarViewController ()

@end

@implementation RevisarViewController
@synthesize scroll=_scroll,wGlobal=_wGlobal,hGlobal=_hGlobal, clienteLabel=_clienteLabel, tableView=_tableView, loDemasLabel=_loDemasLabel,dataList=_dataList;

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
-(void)siguientePantalla {
    
    FirmaClienteViewController *detailViewController = [[FirmaClienteViewController alloc] initWithNibName:@"FirmaClienteViewController" bundle:nil];
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *next = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(siguientePantalla)];
    self.navigationItem.rightBarButtonItems = @[next];
  
    
    //_scroll.panGestureRecognizer.delaysTouchesBegan = YES;
    
    //_scroll.delaysContentTouches = NO;
    _scroll.canCancelContentTouches = NO;
    
    self.title=@"Revisa antes de firmar";
    
    //[self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [self.tableView.backgroundView setBackgroundColor:[UIColor colorWithRed:227.0f/255.0f green:227.0f/255.0f blue:227.0f/255.0f alpha:1.0f]];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SelectClienteTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"selectCliente"];
    
    _wGlobal = self.view.frame.size.width;
    _hGlobal = self.view.frame.size.height;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _dataList = [defaults valueForKey:@"Articulos_PedidoActual"];
    int idCliente = [[defaults valueForKey:@"idCliente_PedidoActual"] intValue];
    
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"idCliente"  ascending:NO]];
    NSManagedObjectContext *moc = [app managedObjectContext];
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"Clientes" inManagedObjectContext:moc];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idCliente == %d",idCliente];
    [request setPredicate:predicate];
    
    request.resultType = NSDictionaryResultType;
    request.returnsDistinctResults = YES;
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    NSString *cliente = @"Cliente: No determinado";
    if(results.count>0)
    {
       cliente = [NSString stringWithFormat:@"Cliente: %@ \nRFC: %@",  [[[results objectAtIndex:0] valueForKey:@"nombre"] description],[[[results objectAtIndex:0] valueForKey:@"rfc"] description]];
    }
    _clienteLabel.text=cliente;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    float totalAux =  [[defaults valueForKey:@"Total_PedidoActual"]floatValue];
    float pagoInicialAux =  [[defaults valueForKey:@"PagoInicial_PedidoActual"]floatValue];
    
    NSString *loDemas = [NSString stringWithFormat:@"Total: %@\nPago Inicial: %@\n# Pagos: %@\nInversión: %@\nFecha Pedido: %@\nFecha Entrega: %@",[formatter stringFromNumber:[NSNumber numberWithFloat:totalAux]] ,[formatter stringFromNumber:[NSNumber numberWithFloat:pagoInicialAux]], [defaults valueForKey:@"NumeroDePagos_PedidoActual"], [defaults valueForKey:@"Inversion_PedidoActual"] , [defaults valueForKey:@"FechaPedido_PedidoActual"], [defaults valueForKey:@"FechaEntrega_PedidoActual"]   ];
    _loDemasLabel.text = loDemas;
    // Do any additional setup after loading the view from its nib.
}
- (void)viewDidLayoutSubviews
{
    [_scroll setContentSize:CGSizeMake(_scroll.frame.size.width, _hGlobal*1.10f)];
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
    return _dataList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectCliente" forIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor colorWithRed:0.0f/255.0f green:136.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:0.0f/255.0f green:136.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
    if(indexPath.row<_dataList.count)
    {
        float unidades = [[[_dataList objectForKey:[[_dataList allKeys] objectAtIndex:indexPath.row]] valueForKey:@"unidades"] floatValue];
        NSString *nombre = [[_dataList objectForKey:[[_dataList allKeys] objectAtIndex:indexPath.row]] valueForKey:@"nombre"];
        int contadoOCredito = [[[_dataList objectForKey:[[_dataList allKeys] objectAtIndex:indexPath.row]] valueForKey:@"contadoOCredito"] intValue];
        NSString *palabra=@"Crédito";
        if(contadoOCredito==1)
        {
            palabra=@"Contado";
        }
        float precio = [[[_dataList objectForKey:[[_dataList allKeys] objectAtIndex:indexPath.row]] valueForKey:@"precio"] floatValue];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%.0f %@",unidades,nombre];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",palabra, [formatter stringFromNumber:[NSNumber numberWithFloat:precio*unidades]]];
    }
   
    return cell;
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
