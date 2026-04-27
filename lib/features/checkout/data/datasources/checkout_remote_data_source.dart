import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/providers/dio_provider.dart';
import '../../domain/entities/order_creation_entity.dart';
import '../dtos/branch_dto.dart';
import '../dtos/order_result_dto.dart';
import '../dtos/payment_condition_dto.dart';

part 'checkout_remote_data_source.g.dart';

/// Data source remoto del checkout.
///
/// Habla con Supabase RPC para S14, S24, S19, S20.
/// Retorna DTOs o lanza DioException — el repositorio convierte a Failure.
class CheckoutRemoteDataSource {
  final DioClient _dio;
  const CheckoutRemoteDataSource(this._dio);

  /// S14 — Sucursales de entrega del cliente.
  Future<List<BranchDto>> getBranches() async {
    final response = await _dio.get<List<dynamic>>(
      ApiEndpoints.branches,
    );
    return _parseList(response.data, BranchDto.fromJson);
  }

  /// S24 — Condiciones de pago disponibles.
  Future<List<PaymentConditionDto>> getPaymentConditions() async {
    final response = await _dio.get<List<dynamic>>(
      ApiEndpoints.paymentConditions,
    );
    return _parseList(response.data, PaymentConditionDto.fromJson);
  }

  /// S19 — Crear pedido. CRÍTICO: sin cache, siempre a la red.
  Future<OrderResultDto> createOrder(OrderCreationEntity order) async {
    final body = {
      'id_sucursal': order.branchId,
      'id_condicion_pago': order.paymentConditionId,
      'codigo_cupon': order.couponCode,
      'notas': order.notes,
      'lineas': order.lines
          .map((l) => {
                'sku': l.sku,
                'nombre': l.productName,
                'cantidad': l.quantity,
                'precio_base': l.basePrice,
                'tasa_iva': l.taxRate,
                'descuento': l.discount,
              })
          .toList(),
    };

    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.createOrder,
      data: body,
    );

    return OrderResultDto.fromJson(response.data!);
  }

  /// S20 — Disparar pedido al ERP tras confirmación S19.
  Future<bool> triggerErpOrder(String orderId) async {
    await _dio.post<void>(
      ApiEndpoints.triggerOrder,
      data: {'id_pedido': orderId},
    );
    return true;
  }

  List<T> _parseList<T>(
    List<dynamic>? data,
    T Function(Map<String, dynamic>) fromJson,
  ) =>
      (data ?? [])
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList();
}

@riverpod
CheckoutRemoteDataSource checkoutRemoteDataSource(Ref ref) =>
    CheckoutRemoteDataSource(ref.watch(dioClientProvider));
