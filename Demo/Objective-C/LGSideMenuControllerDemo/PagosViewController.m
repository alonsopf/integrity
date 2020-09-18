//
//  PagosViewController.m
//  Integrity
//
//  Created by Fernando Alonso Pecina on 30/05/17.
//  Copyright © 2017 Grigory Lutkov. All rights reserved.
//

#import "PagosViewController.h"
#import "NumPagosViewController.h"
#import "FechaPedidoViewController.h"
@interface PagosViewController ()

@end

@implementation PagosViewController
@synthesize saldoInicial=_saldoInicial,totalLabel=_totalLabel,aPagarLabel=_aPagarLabel,total=_total;
-(void)siguientePantalla {
    
    if([_saldoInicial.text isEqualToString:@""])
    {
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@"Integrity"
                                     message:@"Primero indica el Pago inicial, puede ser 0"
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
    [defaults setObject:[NSNumber numberWithFloat:[_saldoInicial.text floatValue]] forKey:@"PagoInicial_PedidoActual"];
    [defaults synchronize];
    float pagoInicial = [_saldoInicial.text floatValue];
    float dif = _total - pagoInicial;
    if(dif==0.0f)
    {
        [defaults setObject:@"" forKey:@"NumeroDePagos_PedidoActual"];
        [defaults setObject:@"" forKey:@"Inversion_PedidoActual"];
        [defaults synchronize];
        FechaPedidoViewController *detailViewController = [[FechaPedidoViewController alloc] initWithNibName:@"FechaPedidoViewController" bundle:nil];
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    else
    {
        NumPagosViewController *detailViewController = [[NumPagosViewController alloc] initWithNibName:@"NumPagosViewController" bundle:nil];
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_saldoInicial becomeFirstResponder];
}
-(void)textFieldDidChange:(id)sender {
    float pagoInicial = [_saldoInicial.text floatValue];
    float dif = _total - pagoInicial;
    if(dif<0.0f)
    {
        _saldoInicial.text = [NSString stringWithFormat:@"%.2f",_total];
        pagoInicial=_total;
        dif = _total - pagoInicial;
    }
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    _aPagarLabel.text = [NSString stringWithFormat:@"%@",[formatter stringFromNumber:[NSNumber numberWithFloat:dif]]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Paso 3.- Pago inicial";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _total = [[defaults valueForKey:@"Total_PedidoActual"] floatValue];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    

    
    _totalLabel.text = [NSString stringWithFormat:@"%@",[formatter stringFromNumber:[NSNumber numberWithFloat:_total]]];
    [_saldoInicial addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
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
