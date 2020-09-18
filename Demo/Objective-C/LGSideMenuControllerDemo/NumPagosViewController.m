//
//  NumPagosViewController.m
//  Integrity
//
//  Created by Fernando Alonso Pecina on 30/05/17.
//  Copyright © 2017 Grigory Lutkov. All rights reserved.
//

#import "NumPagosViewController.h"
#import "FechaPedidoViewController.h"
@interface NumPagosViewController ()

@end

@implementation NumPagosViewController
@synthesize numPagos=_numPagos,inversion=_inversion,letrero=_letrero;

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_numPagos becomeFirstResponder];
}
-(void)siguientePantalla {
    if([_numPagos.text isEqualToString:@""] || [_inversion.text isEqualToString:@""])
    {
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@"Integrity"
                                     message:@"Primero indica el Número de pagos y el intervalo de la inversión (días entre pagos)"
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
    [defaults setObject:_numPagos.text forKey:@"NumeroDePagos_PedidoActual"];
    [defaults setObject:_inversion.text forKey:@"Inversion_PedidoActual"];
    [defaults synchronize];
    
    FechaPedidoViewController *detailViewController = [[FechaPedidoViewController alloc] initWithNibName:@"FechaPedidoViewController" bundle:nil];
    [self.navigationController pushViewController:detailViewController animated:YES];
}
-(void)textFieldDidChange:(id)sender {
    NSString *numPagosS = _numPagos.text;
    NSString *inversionS = _inversion.text;
    if(![numPagosS isEqualToString:@""] && ![inversionS isEqualToString:@""])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        float totalAux = [[defaults valueForKey:@"Total_PedidoActual"] floatValue]-[[defaults valueForKey:@"PagoInicial_PedidoActual"] floatValue];
        totalAux=totalAux/[numPagosS floatValue];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        _letrero.text = [NSString stringWithFormat:@"Serían %@ pagos de %@ cada %@ días",numPagosS,[formatter stringFromNumber:[NSNumber numberWithFloat:totalAux]],inversionS];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Número de pagos";
    UIBarButtonItem *next = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(siguientePantalla)];
    self.navigationItem.rightBarButtonItems = @[next];
    [_numPagos addTarget:self
                      action:@selector(textFieldDidChange:)
            forControlEvents:UIControlEventEditingChanged];
    [_inversion addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    
    
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
