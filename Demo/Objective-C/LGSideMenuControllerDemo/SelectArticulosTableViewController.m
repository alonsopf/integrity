//
//  SelectArticulosTableViewController.m
//  Integrity
//
//  Created by Fernando Alonso Pecina on 29/05/17.
//  Copyright © 2017 Grigory Lutkov. All rights reserved.
//

#import "SelectArticulosTableViewController.h"
#import "AppDelegate.h"
#import "PagosViewController.h"
@interface SelectArticulosTableViewController ()

@end

@implementation SelectArticulosTableViewController
@synthesize titulosList=_titulosList,subtituloList=_subtituloList,speechSynth=_speechSynth,utterance=_utterance, dataList = _dataList, total =_total;

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
- (void) selectProducto: (NSString *) producto contadoOCredito:(int)cc precio:(float)p   clave:(NSString*)clave {
    clave = [self claveDelProducto:producto];
    if([_dataList objectForKey:clave]) {
        int unidades = [[[_dataList objectForKey:clave] valueForKey:@"unidades"] intValue];
        unidades++;
        [[_dataList objectForKey:clave] setObject:[NSNumber numberWithInt:unidades] forKey:@"unidades"];
    } else {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSNumber numberWithInt:1] forKey:@"unidades"];
        [dic setObject:producto forKey:@"nombre"];
        [dic setObject:[NSNumber numberWithInt:cc] forKey:@"contadoOCredito"];
        [dic setObject:[NSNumber numberWithFloat:p] forKey:@"precio"];
        [_dataList setObject:dic forKey:clave];
    }
    [self.tableView reloadData];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _speechSynth = [[AVSpeechSynthesizer alloc] init];
}
-(void)muestraSeleccionarProducto {
    CatalagoTableViewController *detailViewController = [[CatalagoTableViewController alloc] initWithNibName:@"CatalagoTableViewController" bundle:nil];
    detailViewController.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
-(void)siguientePantalla {
    
    if(_dataList.count==0)
    {
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@"Integrity"
                                     message:@"Primero tienes que seleccionar al menos 1 artículo, si no ¿que vas a vender?"
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Ok"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [view dismissViewControllerAnimated:YES completion:nil];
                                 }];
        [view addAction:cancel];
        [self presentViewController:view animated:YES completion:nil];
        return;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_dataList forKey:@"Articulos_PedidoActual"];
    [defaults setObject:[NSNumber numberWithFloat:_total] forKey:@"Total_PedidoActual"];
    [defaults synchronize];
    
    
    PagosViewController *detailViewController = [[PagosViewController alloc] initWithNibName:@"PagosViewController" bundle:nil];
   [self.navigationController pushViewController:detailViewController animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView.backgroundView setBackgroundColor:[UIColor colorWithRed:227.0f/255.0f green:227.0f/255.0f blue:227.0f/255.0f alpha:1.0f]];
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    _dataList = [[NSMutableDictionary alloc] init];
    _titulosList = [[NSMutableArray alloc] init];
    _subtituloList = [[NSMutableArray alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"SelectClienteTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"selectCliente"];
    self.title=@"Paso 2.- Selecciona artículos";
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(muestraSeleccionarProducto)];
    UIBarButtonItem *next = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(siguientePantalla)];
    self.navigationItem.rightBarButtonItems = @[next,bar];
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
    _total=0.0f;
    return _dataList.count+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectCliente" forIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor colorWithRed:0.0f/255.0f green:136.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:0.0f/255.0f green:136.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
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
        _total+=precio*unidades;
        
        cell.textLabel.text = [NSString stringWithFormat:@"%.0f %@",unidades,nombre];
         cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",palabra, [formatter stringFromNumber:[NSNumber numberWithFloat:precio*unidades]]];
    }
    else
    {
        cell.detailTextLabel.text = @"";
        
        cell.textLabel.text = [NSString stringWithFormat:@"Total:  %@",[formatter stringFromNumber:[NSNumber numberWithFloat:_total]]];
    }
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
