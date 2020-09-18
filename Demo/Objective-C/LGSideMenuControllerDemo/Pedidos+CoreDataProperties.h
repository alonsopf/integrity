//
//  Pedidos+CoreDataProperties.h
//  Integrity
//
//  Created by Fernando Alonso Pecina on 31/05/17.
//  Copyright © 2017 Grigory Lutkov. All rights reserved.
//

#import "Pedidos+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Pedidos (CoreDataProperties)

+ (NSFetchRequest<Pedidos *> *)fetchRequest;

@property (nonatomic) int16_t idPedido;
@property (nonatomic) int16_t idGema;
@property (nonatomic) int16_t idCliente;
@property (nonatomic) int16_t numArticulos;
@property (nullable, nonatomic, copy) NSString *hardcodeo;
@property (nonatomic) float total;
@property (nonatomic) float pagoInicial;
@property (nonatomic) int16_t numPagos;
@property (nonatomic) int16_t inversion;
@property (nullable, nonatomic, copy) NSString *fechaPedido;
@property (nullable, nonatomic, copy) NSString *fechaEntrega;
@property (nonatomic) int16_t sincronizado;
@property (nonatomic) int16_t facturado;

@end

NS_ASSUME_NONNULL_END
