//
//  CambiarContrasenaViewController.m
//  Integrity
//
//  Created by Fernando Alonso Pecina on 13/06/17.
//  Copyright © 2017 Grigory Lutkov. All rights reserved.
//

#import "CambiarContrasenaViewController.h"
#import "AppDelegate.h"
@interface CambiarContrasenaViewController ()

@end

@implementation CambiarContrasenaViewController
@synthesize pass=_pass,pass1=_pass1,anterior=_anterior;
-(IBAction)cambiarContrasena:(id)sender {
    if(![_pass.text isEqualToString:_pass1.text] || [_pass.text isEqualToString:@""])
    {
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@"Integrity"
                                     message:@"La contraseña nueva no coinciden"
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Aceptar"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [view dismissViewControllerAnimated:YES completion:nil];
                                 }];
        [view addAction:cancel];
        [self presentViewController:view animated:YES completion:nil];
        return;
    }

    if([_anterior.text isEqualToString:@""])
    {
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@"Integrity"
                                     message:@"Debe de escribir la contraseña anterior"
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Aceptar"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [view dismissViewControllerAnimated:YES completion:nil];
                                 }];
        [view addAction:cancel];
        [self presentViewController:view animated:YES completion:nil];
        return;
    }

    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *urlString = @"http://integritycapacitacion.org/app.php";
        
        NSData *nsdata = [self.pass.text dataUsingEncoding:NSUTF8StringEncoding];
        NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
        
        
        NSData *nsdataAnterior = [self.anterior.text dataUsingEncoding:NSUTF8StringEncoding];
        NSString *base64EncodedAnterior = [nsdataAnterior base64EncodedStringWithOptions:0];
        
        NSString *post = [NSString stringWithFormat:@"servicio=app&accion=cambiaContrasena&idGema=%@&contraAnterior=%@&contraNueva=%@",[defaults valueForKey:@"idGema"],base64EncodedAnterior,base64Encoded ];
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", (int)[postData length]];
        
        
        
        NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
        
        NSString* encodedUrl = [urlString stringByAddingPercentEncodingWithAllowedCharacters:
                                set];
        
        NSURL * url = [NSURL URLWithString:encodedUrl];
        NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
        [urlRequest setHTTPMethod:@"POST"];//GET
        [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [urlRequest setHTTPBody:postData];
        NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                               if(error == nil)
                                                               {
                                                                   NSError* error;
                                                                   NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                                   int success = [[json objectForKey:@"success"] intValue];
                                                                   if(success==1)
                                                                   {
                                                                       
                                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                                           
                                                                           UIAlertController * view=   [UIAlertController
                                                                                                        alertControllerWithTitle:@"Integrity"
                                                                                                        message:@"Contraseña cambiada"
                                                                                                        preferredStyle:UIAlertControllerStyleAlert];
                                                                           UIAlertAction* cancel = [UIAlertAction
                                                                                                    actionWithTitle:@"Aceptar"
                                                                                                    style:UIAlertActionStyleDefault
                                                                                                    handler:^(UIAlertAction * action)
                                                                                                    {
                                                                                                        [view dismissViewControllerAnimated:YES completion:nil];
                                                                                                        [self.navigationController popViewControllerAnimated:YES];
                                                                                                    }];
                                                                           [view addAction:cancel];
                                                                           [self presentViewController:view animated:YES completion:nil];
                                                                           
                                                                       });
                                                                       
                                                                       
                                                                       
                                                                   }

                                                                   if(success==2)
                                                                   {
                                                                       
                                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                                           
                                                                           UIAlertController * view=   [UIAlertController
                                                                                                        alertControllerWithTitle:@"Integrity"
                                                                                                        message:@"La contraseña anterior es incorrecta"
                                                                                                        preferredStyle:UIAlertControllerStyleAlert];
                                                                           UIAlertAction* cancel = [UIAlertAction
                                                                                                    actionWithTitle:@"Aceptar"
                                                                                                    style:UIAlertActionStyleDefault
                                                                                                    handler:^(UIAlertAction * action)
                                                                                                    {
                                                                                                        [view dismissViewControllerAnimated:YES completion:nil];
                                                                                                                                                       }];
                                                                           [view addAction:cancel];
                                                                           [self presentViewController:view animated:YES completion:nil];
                                                                           
                                                                       });
                                                                       
                                                                       
                                                                       
                                                                   }
                                                               }
                                                           }];
        
        [dataTask resume];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Code to update the UI/send notifications based on the results of the background processing
            //            [_message show];
            
            
        });
        
    });
}
- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.title=@"Cambiar contraseña";
    if(!app.hasInternet)
    {
        [self showNoHayInternet];
    }
    else
    {
        [_anterior becomeFirstResponder];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showNoHayInternet
{
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:@"Integrity"
                                 message:@"No hay una conexión disponible de internet, favor de conectarse a internet para poder cambiar la contraseña."
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Aceptar"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                                 [self.navigationController popViewControllerAnimated:YES];
                             }];
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    if(textField==self.anterior)
    {
        [textField resignFirstResponder];
        [self.pass becomeFirstResponder];
    }
    else
    {
        if(textField==self.pass)
        {
            [textField resignFirstResponder];
            [self.pass1 becomeFirstResponder];
        }
        else
        {
            if(textField==self.pass1)
            {
                [textField resignFirstResponder];
                [self cambiarContrasena:nil];
            }
        }
    }
    return YES;
}



@end
