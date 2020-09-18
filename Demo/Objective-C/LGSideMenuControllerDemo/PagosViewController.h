//
//  PagosViewController.h
//  Integrity
//
//  Created by Fernando Alonso Pecina on 30/05/17.
//  Copyright © 2017 Grigory Lutkov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PagosViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic,strong) IBOutlet UITextField *saldoInicial;
@property (nonatomic,strong) IBOutlet UILabel *totalLabel;
@property (nonatomic,strong) IBOutlet UILabel *aPagarLabel;
@property float total;
@end
