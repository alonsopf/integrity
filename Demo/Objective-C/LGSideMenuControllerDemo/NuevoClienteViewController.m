//
//  NuevoClienteViewController.m
//  Integrity
//
//  Created by Fernando Alonso Pecina on 29/05/17.
//  Copyright © 2017 Grigory Lutkov. All rights reserved.
//

#import "NuevoClienteViewController.h"
#import "AppDelegate.h"
#import "Clientes+CoreDataClass.h"

#import <QuartzCore/QuartzCore.h>

@interface NuevoClienteViewController ()

@end

@implementation NuevoClienteViewController
@synthesize correo_input=_correo_input, nombre_input =_nombre_input, telefono_input=_telefono_input     , calle_input=_calle_input, colonia_input=_colonia_input, ciudad_input =_ciudad_input, estado_input=_estado_input, cp_input=_cp_input, scroll=_scroll,nuevoClienteButton=_nuevoClienteButton,modo=_modo,nombreModificar=_nombreModificar, telefonoModificar =_telefonoModificar, correoModificar=_correoModificar, calleModificar=_calleModificar,coloniaModificar=_coloniaModificar, ciudadModificar=_ciudadModificar, estadoModificar=_estadoModificar,cpModificar=_cpModificar,idClienteModificar=_idClienteModificar, rfc=_rfc,rfcModificar=_rfcModificar;
@synthesize wGlobal = _wGlobal, hGlobal=_hGlobal;
-(void)handleSingleTap:(id)sender{
    [self.correo_input resignFirstResponder];
    [self.nombre_input resignFirstResponder];
    [self.telefono_input resignFirstResponder];
    [self.calle_input resignFirstResponder];
    [self.colonia_input resignFirstResponder];
    [self.ciudad_input resignFirstResponder];
    [self.estado_input resignFirstResponder];
    [self.cp_input resignFirstResponder];
    [self.rfc resignFirstResponder];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(_modo==1)//nuevo
    {
        [_nombre_input becomeFirstResponder];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _nuevoClienteButton.layer.cornerRadius = 10; // this value vary as per your desire
    _nuevoClienteButton.clipsToBounds = YES;
    self.title=@"Nuevo Cliente";
    _wGlobal = self.view.frame.size.width;
    _hGlobal = self.view.frame.size.height;
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
    
    
    UIToolbar  *numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, _wGlobal, _hGlobal/14.0f)];
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancelar" style:UIBarButtonItemStylePlain target:self action:@selector(cancelNumberPad:)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Siguiente" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad:)],
                           nil];
    self.telefono_input.inputAccessoryView = numberToolbar;
    self.cp_input.inputAccessoryView = numberToolbar;
    if(_modo==2)//modificar cliente!
    {
        _nombre_input.text=_nombreModificar;
        _nombre_input.enabled=NO;
        _correo_input.text=_correoModificar;
        _telefono_input.text=_telefonoModificar;
        _calle_input.text=_calleModificar;
        _colonia_input.text=_coloniaModificar;
        _estado_input.text=_estadoModificar;
        _ciudad_input.text=_ciudadModificar;
        _cp_input.text=_cpModificar;
        _rfc.text=_rfcModificar;
        self.title=@"Modifica Cliente";
        
    }
    // Do any additional setup after loading the view from its nib.
}
- (void)viewDidLayoutSubviews
{
    [_scroll setContentSize:CGSizeMake(_scroll.frame.size.width, _hGlobal*1.60f)];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(int)getNextIdClient {
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.fetchLimit = 1;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"idCliente" ascending:NO]];
    NSManagedObjectContext *moc = [app managedObjectContext];
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"Clientes" inManagedObjectContext:moc];
    [request setEntity:entity];
    request.resultType = NSDictionaryResultType;
    request.returnsDistinctResults = YES;
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    if(results.count==0)// no lo he insertado en base de datos!
    {
        return 1;
    }
    return [[[results objectAtIndex:0] valueForKey:@"idCliente"] intValue] + 1;
}
-(IBAction)trySaveClient:(id)sender {
    //primero grabo con sincronizado en 0
    //si hay internet, entonces, en otro metodo sincronizo
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSError *error2 = nil;
    
    if(_modo==1)//nuevo cliente
    {
        NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"Clientes" inManagedObjectContext:[app managedObjectContext]];
        
        
        [object setValue:self.calle_input.text forKey:@"calle"];
        [object setValue:self.ciudad_input.text forKey:@"ciudad"];
        
        [object setValue:self.colonia_input.text forKey:@"colonia"];
        [object setValue:self.correo_input.text forKey:@"correo"];
        [object setValue:self.cp_input.text forKey:@"cp"];
        [object setValue:self.estado_input.text forKey:@"estado"];
        [object setValue:self.nombre_input.text forKey:@"nombre"];
        [object setValue:self.telefono_input.text forKey:@"telefono"];
        [object setValue:self.rfc.text forKey:@"rfc"];
        NSNumber *zero = [NSNumber numberWithInt:0];
        [object setValue:zero forKey:@"sincronizado"];
        NSNumber *someNumber = [NSNumber numberWithInt:[self getNextIdClient]];
        [object setValue:someNumber forKey:@"idCliente"];
    }
    else//editar 
    {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity =[NSEntityDescription entityForName:@"Clientes" inManagedObjectContext:[app managedObjectContext]];
        [request setEntity:entity];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idCliente == %@",_idClienteModificar];
        [request setPredicate:predicate];
        
       
        NSError *error = nil;
        NSMutableArray *results = [[[app managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];
      

        if(results.count>0)
        {
            Clientes *man = (Clientes*)[results objectAtIndex:0];
            NSLog(@"%@",man.description);
            [man setValue:_nombreModificar forKey:@"nombre"];
            [man setValue:_correo_input.text forKey:@"correo"];
            [man setValue:_telefono_input.text forKey:@"telefono"];
            [man setValue:_calle_input.text forKey:@"calle"];
            
            [man setValue:_colonia_input.text forKey:@"colonia"];
            [man setValue:_ciudad_input.text forKey:@"ciudad"];
            [man setValue:_estado_input.text forKey:@"estado"];
            [man setValue:_cp_input.text forKey:@"cp"];
            [man setValue:_rfc.text forKey:@"rfc"];
            NSNumber *someNumber = [NSNumber numberWithInt:[_idClienteModificar intValue]];
            [man setValue:someNumber forKey:@"idCliente"];
            NSNumber *zero = [NSNumber numberWithInt:0];
            [man setValue:zero forKey:@"sincronizado"];
            NSLog(@"%@",man.description);
           
        }
    }
    if (![[app managedObjectContext] save:&error2]) {
        NSLog(@"Failed to save - error: %@", [error2 localizedDescription]);
    }
    
    
    
    
    
    
    
    
    
    NSString *mensaje=@"";
    if(app.hasInternet)
    {
        [app trySincronizarTodo];
        mensaje=@"Cliente guardado";
    }
    else
    {
        mensaje=@"Cliente guardado, recuerda sincronizar después que tengas internet";
    }
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:@"Integrity"
                                 message:mensaje
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Ok"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [self.navigationController popViewControllerAnimated:YES];
                                 [view dismissViewControllerAnimated:YES completion:nil];
                             }];
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];

    
}
#pragma mark - Toolbar numberpad Hardcords
- (void)cancelNumberPad:(UIBarButtonItem*)textField
{
    [self.telefono_input resignFirstResponder];
    [self.cp_input resignFirstResponder];
}


- (void)doneWithNumberPad:(UIBarButtonItem*)textField
{
    
    if([self.telefono_input isFirstResponder])
    {
        [self.telefono_input resignFirstResponder];
        [self.correo_input becomeFirstResponder];
    } else{
        if([self.cp_input isFirstResponder])
        {
            [self.cp_input resignFirstResponder];
            [self.rfc resignFirstResponder];
           // [self trySaveClient:nil];
        }
    }
    
}

#pragma mark - TextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.telefono_input==textField)
    {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSArray *components = [newString componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
        NSString *decimalString = [components componentsJoinedByString:@""];
        
        NSUInteger length = decimalString.length;
        BOOL hasLeadingOne = length > 0 && [decimalString characterAtIndex:0] == '1';
        
        if (length == 0 || (length > 10 && !hasLeadingOne) || (length > 11)) {
            textField.text = decimalString;
            return NO;
        }
        
        NSUInteger index = 0;
        NSMutableString *formattedString = [NSMutableString string];
        
        if (hasLeadingOne) {
            [formattedString appendString:@"1 "];
            index += 1;
        }
        
        if (length - index > 3) {
            NSString *areaCode = [decimalString substringWithRange:NSMakeRange(index, 3)];
            [formattedString appendFormat:@"%@-",areaCode];
            index += 3;
        }
        
        if (length - index > 3) {
            NSString *prefix = [decimalString substringWithRange:NSMakeRange(index, 3)];
            [formattedString appendFormat:@"%@-",prefix];
            index += 3;
        }
        
        NSString *remainder = [decimalString substringFromIndex:index];
        [formattedString appendString:remainder];
        
        textField.text = formattedString;
        return NO;
    }
    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    if(textField==self.nombre_input)
    {
        [textField resignFirstResponder];
        [self.telefono_input becomeFirstResponder];
    }
    else
    {
        if(textField==self.telefono_input)
        {
            [textField resignFirstResponder];
            [self.correo_input becomeFirstResponder];
        }
        else
        {
            if(textField==self.correo_input)
            {
                [textField resignFirstResponder];
                [self.calle_input becomeFirstResponder];
            }
            else
            {
                if(textField==self.calle_input)
                {
                    [textField resignFirstResponder];
                    [self.colonia_input becomeFirstResponder];
                }
                else
                {
                    if(textField==self.colonia_input)
                    {
                        [textField resignFirstResponder];
                        [self.ciudad_input becomeFirstResponder];
                    }
                    else
                    {
                        if(textField==self.ciudad_input)
                        {
                            [textField resignFirstResponder];
                            [self.estado_input becomeFirstResponder];
                        }
                        else
                        {
                            if(textField==self.estado_input)
                            {
                                [textField resignFirstResponder];
                                [self.cp_input becomeFirstResponder];
                            }
                            else
                            {
                                if(textField==self.cp_input)
                                {
                                    [textField resignFirstResponder];
                                    //guarda cliente!
                                }
                                else
                                {
                                    if(textField==self.rfc)
                                    {
                                        [self trySaveClient:nil];
                                    }
                                }
                                
                            }
                        }
                    }
                }
            }
        }
    }
    return YES;
}

@end
