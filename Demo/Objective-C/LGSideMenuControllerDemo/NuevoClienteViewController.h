//
//  NuevoClienteViewController.h
//  Integrity
//
//  Created by Fernando Alonso Pecina on 29/05/17.
//  Copyright © 2017 Grigory Lutkov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NuevoClienteViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) IBOutlet UITextField *nombre_input;
@property (strong, nonatomic) IBOutlet UITextField *telefono_input;
@property (strong, nonatomic) IBOutlet UITextField *correo_input;
@property (strong, nonatomic) IBOutlet UITextField *calle_input;
@property (strong, nonatomic) IBOutlet UITextField *colonia_input;
@property (strong, nonatomic) IBOutlet UITextField *ciudad_input;
@property (strong, nonatomic) IBOutlet UITextField *estado_input;
@property (strong, nonatomic) IBOutlet UITextField *cp_input;
@property (strong, nonatomic) IBOutlet UITextField *rfc;
@property (strong, nonatomic) IBOutlet UIButton *nuevoClienteButton;
//para modificar cliente
@property int modo;
@property (strong, nonatomic) NSString *nombreModificar;
@property (strong, nonatomic) NSString *telefonoModificar;
@property (strong, nonatomic) NSString *correoModificar;
@property (strong, nonatomic) NSString *calleModificar;
@property (strong, nonatomic) NSString *coloniaModificar;
@property (strong, nonatomic) NSString *ciudadModificar;
@property (strong, nonatomic) NSString *estadoModificar;
@property (strong, nonatomic) NSString *cpModificar;
@property (strong, nonatomic) NSString *idClienteModificar;
@property (strong, nonatomic) NSString *rfcModificar;
-(IBAction)trySaveClient:(id)sender;
//proposito general
@property int wGlobal;
@property int hGlobal;
@end
