//
//  TalonarioTableViewCell.m
//  Integrity
//
//  Created by Fernando Alonso Pecina on 01/06/17.
//  Copyright © 2017 Grigory Lutkov. All rights reserved.
//

#import "TalonarioTableViewCell.h"

@implementation TalonarioTableViewCell
@synthesize folioLabel=_folioLabel, nombreLabel=_nombreLabel, fechaLabel = _fechaLabel, idPedido = _idPedido,fecha=_fecha,folio=_folio,nombre=_nombre;
-(void)actualizaUI {
    _fechaLabel.text=_fecha;
    _nombreLabel.text=_nombre;
    _folioLabel.text=_folio;
}
-(id)init {
    if (self=[super init]) {
        _fechaLabel.text=_fecha;
        _nombreLabel.text=_nombre;
        _folioLabel.text=_folio;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
