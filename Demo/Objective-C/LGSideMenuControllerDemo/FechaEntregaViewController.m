//
//  FechaEntregaViewController.m
//  Integrity
//
//  Created by Fernando Alonso Pecina on 30/05/17.
//  Copyright © 2017 Grigory Lutkov. All rights reserved.
//

#import "FechaEntregaViewController.h"
#import "RevisarViewController.h"
@interface FechaEntregaViewController ()

@end

@implementation FechaEntregaViewController
@synthesize datePicker=_datePicker;
-(void)siguientePantalla {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[_datePicker.date.description substringToIndex:10] forKey:@"FechaEntrega_PedidoActual"];
    [defaults synchronize];
    RevisarViewController *detailViewController = [[RevisarViewController alloc] initWithNibName:@"RevisarViewController" bundle:nil];
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *myDate = [df dateFromString: [defaults valueForKey:@"FechaPedido_PedidoActual"]];
    [_datePicker setMinimumDate:myDate];
    
    
    self.title=@"Paso 5.- Fecha entrega";
    UIBarButtonItem *next = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(siguientePantalla)];
    self.navigationItem.rightBarButtonItems = @[next];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
