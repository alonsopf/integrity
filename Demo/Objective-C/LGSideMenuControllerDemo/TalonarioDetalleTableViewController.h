//
//  TalonarioDetalleTableViewController.h
//  Integrity
//
//  Created by Fernando Alonso Pecina on 01/06/17.
//  Copyright © 2017 Grigory Lutkov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalonarioDetalleTableViewController : UITableViewController
@property (nonatomic,strong) NSString *idPedido;
@property (nonatomic,strong)  NSMutableArray *titulosList;
@property (nonatomic,strong)  NSMutableArray *subtitulosList;
@end
