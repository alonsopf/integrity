//
//  CambiarContrasenaViewController.h
//  Integrity
//
//  Created by Fernando Alonso Pecina on 13/06/17.
//  Copyright © 2017 Grigory Lutkov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CambiarContrasenaViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic,strong) IBOutlet UITextField *anterior;
@property (nonatomic,strong) IBOutlet UITextField *pass;
@property (nonatomic,strong) IBOutlet UITextField *pass1;
-(IBAction)cambiarContrasena:(id)sender;
@end
