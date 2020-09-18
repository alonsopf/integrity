//
//  FirmaClienteViewController.h
//  Integrity
//
//  Created by Fernando Alonso Pecina on 12/06/17.
//  Copyright © 2017 Grigory Lutkov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirmaClienteViewController : UIViewController
@property (nonatomic,strong)  NSMutableDictionary *dataList;
-(void)guardaYEnviaBoton;
@end
