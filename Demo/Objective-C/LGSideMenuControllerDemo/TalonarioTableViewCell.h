//
//  TalonarioTableViewCell.h
//  Integrity
//
//  Created by Fernando Alonso Pecina on 01/06/17.
//  Copyright © 2017 Grigory Lutkov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalonarioTableViewCell : UITableViewCell
@property (nonatomic,strong) IBOutlet UILabel *fechaLabel;
@property (nonatomic,strong) IBOutlet UILabel *folioLabel;
@property (nonatomic,strong) IBOutlet UILabel *nombreLabel;
@property (nonatomic,strong) NSString *idPedido;
@property (nonatomic,strong) NSString *fecha;
@property (nonatomic,strong) NSString *folio;
@property (nonatomic,strong) NSString *nombre;
-(void)actualizaUI;
@end
