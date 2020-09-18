//
//  CatalagoTableViewController.m
//  Integrity
//
//  Created by Fernando Alonso Pecina on 29/05/17.
//  Copyright © 2017 Grigory Lutkov. All rights reserved.
//

#import "CatalagoTableViewController.h"
#import "SelectClienteTableViewCell.h"
#import "AppDelegate.h"
@interface CatalagoTableViewController ()

@end

@implementation CatalagoTableViewController
@synthesize dataList=_dataList,speechSynth=_speechSynth,utterance=_utterance,cuantosTiposInt=_cuantosTiposInt, cuantosTipos = _cuantosTipos;

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _speechSynth = [[AVSpeechSynthesizer alloc] init];
}
-(void)obtieneCatalago {
    [self.view endEditing:YES];
    _utterance = [[AVSpeechUtterance alloc] initWithString:[NSString stringWithFormat:@"Integrity, Más que un servicio, un legado de vida."] ];
    _utterance.rate = AVSpeechUtteranceDefaultSpeechRate;
    [_speechSynth speakUtterance:_utterance];
    if(_dataList!=nil)
    {
        [_dataList removeAllObjects];
    }
    if(_cuantosTipos!=nil)
    {
        [_cuantosTipos removeAllObjects];
    }
    
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"tipo"  ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"nombre"  ascending:YES]];
    NSManagedObjectContext *moc = [app managedObjectContext];
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"Catalogo" inManagedObjectContext:moc];
    [request setEntity:entity];
    request.resultType = NSDictionaryResultType;
    request.returnsDistinctResults = YES;
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    
    if(results.count>0)// no lo he insertado en base de datos!
    {
        for(NSManagedObject *man in results)
        {
            int cuak = [[man valueForKey:@"tipo"] intValue]-1;
            NSNumber *tipoN = [NSNumber numberWithInt:cuak];
            if(![_cuantosTipos containsObject:tipoN])
            {
                [_cuantosTipos addObject:tipoN];
                [_dataList setObject:[[NSMutableArray alloc] init] forKey:[NSString stringWithFormat:@"titulos%d",cuak]];
                [_dataList setObject:[[NSMutableArray alloc] init] forKey:[NSString stringWithFormat:@"subtitulos%d",cuak]];
                [_dataList setObject:[[NSMutableArray alloc] init] forKey:[NSString stringWithFormat:@"contado%d",cuak]];
                [_dataList setObject:[[NSMutableArray alloc] init] forKey:[NSString stringWithFormat:@"credito%d",cuak]];
            }
            
            NSString *titulo = [NSString stringWithFormat:@"%@",[man valueForKey:@"nombre"]];
            NSString *palabra = @"";
            int agotado = [[man valueForKey:@"agotado"] intValue];
            if (agotado==1)
            {
                palabra=@"AGOTADO";
            }
             NSString *subtitulo = [NSString stringWithFormat:@"%@ Contado: %@ Crédito: %@",palabra,  [formatter stringFromNumber:[NSNumber numberWithFloat:[[man valueForKey:@"contadoPublico"]floatValue]]], [formatter stringFromNumber:[NSNumber numberWithFloat:[[man valueForKey:@"creditoPublico"]floatValue]]] ];
            
            [[_dataList valueForKey:[NSString stringWithFormat:@"titulos%d",cuak]] addObject:titulo];
            [[_dataList valueForKey:[NSString stringWithFormat:@"subtitulos%d",cuak]] addObject:subtitulo];
            [[_dataList valueForKey:[NSString stringWithFormat:@"contado%d",cuak]] addObject:[man valueForKey:@"contadoPublico"]];
            [[_dataList valueForKey:[NSString stringWithFormat:@"credito%d",cuak]] addObject:[man valueForKey:@"creditoPublico"]];
            
        }
        _cuantosTiposInt = (int)_cuantosTipos.count;
        [self.tableView reloadData];
    }
}
-(void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _cuantosTiposInt=0;
    _dataList = [[NSMutableDictionary alloc] init];
    _cuantosTipos = [[NSMutableArray alloc] init];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(close)];
    self.navigationItem.rightBarButtonItem = bar;
    self.title=@"Selecciona un artículo";
    [self.tableView registerNib:[UINib nibWithNibName:@"SelectClienteTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"selectCliente"];
    [self obtieneCatalago];
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
    return _cuantosTiposInt;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *titulo=@"";
    int aver = [[_cuantosTipos objectAtIndex:section] intValue];
    switch (aver) {
        case 0:
            titulo=@"Biblia";
        break;
        case 1:
            titulo=@"Colecciones";
        break;
        case 2:
            titulo=@"Libros";
        break;
        case 3:
            titulo=@"Revistas";
            break;
        default:
            titulo=@"No determinado";
        break;
    }
    return titulo;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr=  [_dataList valueForKey:[NSString stringWithFormat:@"titulos%d",(int)[[_cuantosTipos objectAtIndex:section] intValue]]] ;
    return arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectCliente" forIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor colorWithRed:0.0f/255.0f green:136.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:0.0f/255.0f green:136.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
    //int cuak = [[man valueForKey:@"tipo"] intValue];
  /*  if(indexPath.section<_cuantosTipos.count)
    {
    }
    else
    {
        int gato = 5;
    }
    */
    NSArray *arr=  [_dataList valueForKey:[NSString stringWithFormat:@"titulos%d",(int)[[_cuantosTipos objectAtIndex:indexPath.section] intValue]]] ;
    NSArray *arrS=  [_dataList valueForKey:[NSString stringWithFormat:@"subtitulos%d",(int)[[_cuantosTipos objectAtIndex:indexPath.section] intValue]]] ;
    if(indexPath.row<arr.count)
    {
        cell.textLabel.text=[arr objectAtIndex:indexPath.row];
        cell.detailTextLabel.text=[arrS objectAtIndex:indexPath.row];
    }
   /* else
    {
        int aver = 5;
    }*/
    
    
    return cell;
}


#pragma mark - Searchbar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(_dataList!=nil)
    {
        [_dataList removeAllObjects];
    }
    if(_cuantosTipos!=nil)
    {
        [_cuantosTipos removeAllObjects];
    }
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"tipo"  ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"nombre"  ascending:YES]];
    NSManagedObjectContext *moc = [app managedObjectContext];
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"Catalogo" inManagedObjectContext:moc];
    [request setEntity:entity];
    if(![searchText isEqualToString:@""])
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(nombre CONTAINS[cd] %@)",searchText ];
        [request setPredicate:predicate];
    }
    
    
    request.resultType = NSDictionaryResultType;
    request.returnsDistinctResults = YES;
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    
    if(results.count>0)// no lo he insertado en base de datos!
    {
        for(NSManagedObject *man in results)
        {
            int cuak = [[man valueForKey:@"tipo"] intValue]-1;
            NSNumber *tipoN = [NSNumber numberWithInt:cuak];
            if(![_cuantosTipos containsObject:tipoN])
            {
                [_cuantosTipos addObject:tipoN];
                [_dataList setObject:[[NSMutableArray alloc] init] forKey:[NSString stringWithFormat:@"titulos%d",cuak]];
                [_dataList setObject:[[NSMutableArray alloc] init] forKey:[NSString stringWithFormat:@"subtitulos%d",cuak]];
                [_dataList setObject:[[NSMutableArray alloc] init] forKey:[NSString stringWithFormat:@"contado%d",cuak]];
                [_dataList setObject:[[NSMutableArray alloc] init] forKey:[NSString stringWithFormat:@"credito%d",cuak]];
            }
            
            NSString *titulo = [NSString stringWithFormat:@"%@",[man valueForKey:@"nombre"]];
            NSString *palabra = @"";
            int agotado = [[man valueForKey:@"agotado"] intValue];
            if (agotado==1)
            {
                palabra=@"AGOTADO";
            }
           
            
            
            
            
            
            NSString *subtitulo = [NSString stringWithFormat:@"%@ Contado: %@ Crédito: %@",palabra,  [formatter stringFromNumber:[NSNumber numberWithFloat:[[man valueForKey:@"contadoPublico"]floatValue]]], [formatter stringFromNumber:[NSNumber numberWithFloat:[[man valueForKey:@"creditoPublico"]floatValue]]] ];
            [[_dataList valueForKey:[NSString stringWithFormat:@"titulos%d",cuak]] addObject:titulo];
            [[_dataList valueForKey:[NSString stringWithFormat:@"subtitulos%d",cuak]] addObject:subtitulo];
            [[_dataList valueForKey:[NSString stringWithFormat:@"contado%d",cuak]] addObject:[man valueForKey:@"contadoPublico"]];
            [[_dataList valueForKey:[NSString stringWithFormat:@"credito%d",cuak]] addObject:[man valueForKey:@"creditoPublico"]];
            
        }
        _cuantosTiposInt = (int)_cuantosTipos.count;
        [self.tableView reloadData];
    }
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
    NSArray *arr=  [_dataList valueForKey:[NSString stringWithFormat:@"contado%d",(int)[[_cuantosTipos objectAtIndex:indexPath.section] intValue]]] ;
    NSArray *arrC=  [_dataList valueForKey:[NSString stringWithFormat:@"credito%d",(int)[[_cuantosTipos objectAtIndex:indexPath.section] intValue]]] ;
    
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:@"Integrity"
                                 message:[NSString stringWithFormat:@"%@ ¿Contado o crédito? \n $%.2f contado \n $%.2f crédito",cell.textLabel.text, [[arr objectAtIndex:indexPath.row] floatValue], [[arrC objectAtIndex:indexPath.row] floatValue] ]
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* contado = [UIAlertAction
                             actionWithTitle:@"Contado"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                                 [self.delegate selectProducto:cell.textLabel.text contadoOCredito:1 precio:[[arr objectAtIndex:indexPath.row] floatValue] clave:@""];
                                 [self close];
                             }];
    [view addAction:contado];
    UIAlertAction* credito = [UIAlertAction
                              actionWithTitle:@"Crédito"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  [view dismissViewControllerAnimated:YES completion:nil];
                                  [self.delegate selectProducto:cell.textLabel.text contadoOCredito:2 precio:[[arrC objectAtIndex:indexPath.row] floatValue] clave:@""];
                                  [self close];
                              }];
    [view addAction:credito];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancelar"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                             }];
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
    // Navigation logic may go here, for example:
    // Create the next view controller.
  //  <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
//    [self.navigationController pushViewController:detailViewController animated:YES];
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
