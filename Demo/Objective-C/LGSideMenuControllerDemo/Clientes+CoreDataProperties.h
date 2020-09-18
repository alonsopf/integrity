//
//  Clientes+CoreDataProperties.h
//  Integrity
//
//  Created by Fernando Alonso Pecina on 13/06/17.
//  Copyright © 2017 Grigory Lutkov. All rights reserved.
//

#import "Clientes+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Clientes (CoreDataProperties)

+ (NSFetchRequest<Clientes *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *calle;
@property (nullable, nonatomic, copy) NSString *ciudad;
@property (nullable, nonatomic, copy) NSString *colonia;
@property (nullable, nonatomic, copy) NSString *correo;
@property (nullable, nonatomic, copy) NSString *cp;
@property (nullable, nonatomic, copy) NSString *estado;
@property (nonatomic) int16_t idCliente;
@property (nullable, nonatomic, copy) NSString *nombre;
@property (nonatomic) int16_t sincronizado;
@property (nullable, nonatomic, copy) NSString *telefono;
@property (nullable, nonatomic, copy) NSString *rfc;

@end

NS_ASSUME_NONNULL_END
