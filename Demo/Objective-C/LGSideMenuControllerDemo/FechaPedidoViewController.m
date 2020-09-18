//
//  FechaPedidoViewController.m
//  Integrity
//
//  Created by Fernando Alonso Pecina on 30/05/17.
//  Copyright © 2017 Grigory Lutkov. All rights reserved.
//

#import "FechaPedidoViewController.h"
#import "FechaEntregaViewController.h"
@interface FechaPedidoViewController ()

@end

@implementation FechaPedidoViewController
@synthesize datePicker=_datePicker;
-(void)siguientePantalla {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   [defaults setObject:[_datePicker.date.description substringToIndex:10]forKey:@"FechaPedido_PedidoActual"];
    [defaults synchronize];
    
    FechaEntregaViewController *detailViewController = [[FechaEntregaViewController alloc] initWithNibName:@"FechaEntregaViewController" bundle:nil];
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Paso 4.- Fecha pedido";
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
