import '../../domain/entities/branch_entity.dart';
import '../../domain/entities/order_result_entity.dart';
import '../../domain/entities/payment_condition_entity.dart';
import '../dtos/branch_dto.dart';
import '../dtos/order_result_dto.dart';
import '../dtos/payment_condition_dto.dart';

extension BranchDtoMapper on BranchDto {
  BranchEntity toEntity() => BranchEntity(
        id: id,
        code: code,
        name: name,
        address: address,
        city: city,
        phone: phone,
        priceListId: priceListId,
        isDefault: isDefault,
      );
}

extension PaymentConditionDtoMapper on PaymentConditionDto {
  PaymentConditionEntity toEntity() => PaymentConditionEntity(
        id: id,
        code: code,
        name: name,
        days: days,
        description: description,
      );
}

extension OrderResultDtoMapper on OrderResultDto {
  OrderResultEntity toEntity() => OrderResultEntity(
        orderId: orderId,
        orderNumber: orderNumber,
        confirmedTotal: confirmedTotal,
        message: message,
      );
}
