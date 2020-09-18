//
//  Pedidos+CoreDataProperties.m
//  Integrity
//
//  Created by Fernando Alonso Pecina on 31/05/17.
//  Copyright © 2017 Grigory Lutkov. All rights reserved.
//

#import "Pedidos+CoreDataProperties.h"

@implementation Pedidos (CoreDataProperties)

+ (NSFetchRequest<Pedidos *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Pedidos"];
}

@dynamic idPedido;
@dynamic idGema;
@dynamic idCliente;
@dynamic numArticulos;
@dynamic hardcodeo;
@dynamic total;
@dynamic pagoInicial;
@dynamic numPagos;
@dynamic inversion;
@dynamic fechaPedido;
@dynamic fechaEntrega;
@dynamic sincronizado;
@dynamic facturado;

@end
