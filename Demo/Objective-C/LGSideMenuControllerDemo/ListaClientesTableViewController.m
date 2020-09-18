//
//  ListaClientesTableViewController.m
//  Integrity
//
//  Created by Fernando Alonso Pecina on 01/06/17.
//  Copyright © 2017 Grigory Lutkov. All rights reserved.
//

#import "ListaClientesTableViewController.h"
#import "NuevoClienteViewController.h"
#import "AppDelegate.h"
@interface ListaClientesTableViewController ()

@end

@implementation ListaClientesTableViewController
@synthesize search=_search,titulosList=_titulosList,subtituloList=_subtituloList;


-(void)obtieneClientes {
    [self.view endEditing:YES];
    if(_titulosList!=nil)
    {
        [_titulosList removeAllObjects];
    }
    if(_subtituloList!=nil)
    {
        [_subtituloList removeAllObjects];
    }
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"idCliente"  ascending:NO]];
    NSManagedObjectContext *moc = [app managedObjectContext];
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"Clientes" inManagedObjectContext:moc];
    [request setEntity:entity];
    request.resultType = NSDictionaryResultType;
    request.returnsDistinctResults = YES;
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    
    if(results.count>0)// no lo he insertado en base de datos!
    {
        for(NSManagedObject *man in results)
        {
            NSString *titulo = [NSString stringWithFormat:@"%@ %@",[man valueForKey:@"nombre"], [man valueForKey:@"telefono"]];
            NSString *subtitulo = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@|%@",[man valueForKey:@"calle"],[man valueForKey:@"colonia"],[man valueForKey:@"cp"],[man valueForKey:@"ciudad"],[man valueForKey:@"estado"],[man valueForKey:@"correo"],[man valueForKey:@"idCliente"]];
            [_titulosList addObject:titulo];
            [_subtituloList addObject:subtitulo];
        }
        [self.tableView reloadData];
    }
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self obtieneClientes];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _titulosList = [[NSMutableArray alloc] init];
    _subtituloList = [[NSMutableArray alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"SelectClienteTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"selectCliente"];
    
    self.title=@"Lista de clientes";
    [self obtieneClientes];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectCliente" forIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor colorWithRed:0.0f/255.0f green:136.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:0.0f/255.0f green:136.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
    cell.textLabel.text=[_titulosList objectAtIndex:indexPath.row];
    cell.detailTextLabel.text=[_subtituloList objectAtIndex:indexPath.row];
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


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *idCliente = [[cell.detailTextLabel.text componentsSeparatedByString:@"|"]objectAtIndex:1];
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"idCliente"  ascending:NO]];
    NSManagedObjectContext *moc = [app managedObjectContext];
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"Clientes" inManagedObjectContext:moc];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idCliente == %@",idCliente];
    [request setPredicate:predicate];
    
    request.resultType = NSDictionaryResultType;
    request.returnsDistinctResults = YES;
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    NSString *nombre = @"Cliente: No determinado";
    NSString *correo, *tel, *calle, *colonia, *cd, *edo, *cp, *rfc;
    if(results.count>0)
    {
        /*
         @dynamic idCliente;
         
         @dynamic sincronizado;
         */
        nombre =  [[[results objectAtIndex:0] valueForKey:@"nombre"] description];
        correo =  [[results objectAtIndex:0] valueForKey:@"correo"];
        tel =  [[results objectAtIndex:0] valueForKey:@"telefono"];
        calle =  [[results objectAtIndex:0] valueForKey:@"calle"];
        colonia =  [[results objectAtIndex:0] valueForKey:@"colonia"];
        cd =  [[results objectAtIndex:0] valueForKey:@"ciudad"];
        edo =  [[results objectAtIndex:0] valueForKey:@"estado"];
        cp =  [[results objectAtIndex:0] valueForKey:@"cp"];
        rfc =  [[results objectAtIndex:0] valueForKey:@"rfc"];
    }
    // Navigation logic may go here, for example:
    // Create the next view controller.
    NuevoClienteViewController *viewController = [[NuevoClienteViewController alloc] initWithNibName:@"NuevoClienteViewController" bundle:[NSBundle mainBundle]];
    // Pass the selected object to the new view controller.
    viewController.modo=2;
    viewController.nombreModificar=nombre;
    viewController.correoModificar=correo;
    viewController.telefonoModificar=tel;
    viewController.calleModificar=calle;
    viewController.coloniaModificar=colonia;
    viewController.ciudadModificar=cd;
    viewController.estadoModificar=edo;
    viewController.cpModificar=cp;
    viewController.idClienteModificar=idCliente;
    viewController.rfcModificar=rfc;
    [self.navigationController pushViewController:viewController animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Searchbar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(_titulosList!=nil)
    {
        [_titulosList removeAllObjects];
    }
    if(_subtituloList!=nil)
    {
        [_subtituloList removeAllObjects];
    }
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"idCliente"  ascending:NO]];
    NSManagedObjectContext *moc = [app managedObjectContext];
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"Clientes" inManagedObjectContext:moc];
    [request setEntity:entity];
    request.resultType = NSDictionaryResultType;
    request.returnsDistinctResults = YES;
    if(![searchText isEqualToString:@""])
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(nombre CONTAINS[cd] %@)",searchText ];
        [request setPredicate:predicate];
    }
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    
    if(results.count>0)// no lo he insertado en base de datos!
    {
        for(NSManagedObject *man in results)
        {
            NSString *titulo = [NSString stringWithFormat:@"%@ %@",[man valueForKey:@"nombre"], [man valueForKey:@"telefono"]];
            NSString *subtitulo = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@ %@|%@",[man valueForKey:@"calle"],[man valueForKey:@"colonia"],[man valueForKey:@"cp"],[man valueForKey:@"ciudad"],[man valueForKey:@"estado"],[man valueForKey:@"correo"],[man valueForKey:@"rfc"],[man valueForKey:@"idCliente"]];
            [_titulosList addObject:titulo];
            [_subtituloList addObject:subtitulo];
        }
        [self.tableView reloadData];
    }
}

@end
