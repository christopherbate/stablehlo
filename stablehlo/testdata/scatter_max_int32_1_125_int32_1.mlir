// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<1x125xi32> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<0> : tensor<1xi64>
    %0:2 = call @inputs() : () -> (tensor<1x125xi32>, tensor<1xi32>)
    %1 = call @expected() : () -> tensor<1x125xi32>
    %2 = "stablehlo.scatter"(%0#0, %c, %0#1) <{scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1]>, unique_indices = true}> ({
    ^bb0(%arg0: tensor<i32>, %arg1: tensor<i32>):
      %3 = stablehlo.maximum %arg0, %arg1 : tensor<i32>
      stablehlo.return %3 : tensor<i32>
    }) : (tensor<1x125xi32>, tensor<1xi64>, tensor<1xi32>) -> tensor<1x125xi32>
    stablehlo.custom_call @check.expect_eq(%2, %1) {has_side_effect = true} : (tensor<1x125xi32>, tensor<1x125xi32>) -> ()
    return %2 : tensor<1x125xi32>
  }
  func.func private @inputs() -> (tensor<1x125xi32> {mhlo.layout_mode = "default"}, tensor<1xi32> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<"0x00000000FBFFFFFFFEFFFFFF00000000020000000000000000000000FEFFFFFFFDFFFFFFFDFFFFFFFFFFFFFF00000000020000000000000000000000FCFFFFFF040000000100000000000000FFFFFFFFFAFFFFFF04000000FEFFFFFF0200000000000000030000000000000001000000050000000600000000000000FBFFFFFF0100000000000000FDFFFFFF020000000100000002000000FBFFFFFF00000000FAFFFFFFFFFFFFFF0400000003000000FFFFFFFF00000000FEFFFFFFFFFFFFFFFFFFFFFF05000000FFFFFFFF0000000000000000030000000100000000000000000000000300000000000000FFFFFFFFFDFFFFFFFEFFFFFF01000000000000000100000003000000FFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000FFFFFFFF0000000000000000FFFFFFFF00000000FFFFFFFFFDFFFFFF0300000000000000FCFFFFFFFDFFFFFF00000000FCFFFFFFF8FFFFFF000000000400000001000000FCFFFFFFFFFFFFFF00000000FEFFFFFF03000000000000000200000001000000FBFFFFFF03000000FFFFFFFF00000000F9FFFFFF02000000020000000000000005000000FEFFFFFFFFFFFFFF0200000000000000FEFFFFFF01000000010000000100000000000000010000000000000001000000FCFFFFFF01000000FBFFFFFF00000000FDFFFFFF01000000"> : tensor<1x125xi32>
    %c_0 = stablehlo.constant dense<0> : tensor<1xi32>
    return %c, %c_0 : tensor<1x125xi32>, tensor<1xi32>
  }
  func.func private @expected() -> (tensor<1x125xi32> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<"0x00000000FBFFFFFFFEFFFFFF00000000020000000000000000000000FEFFFFFFFDFFFFFFFDFFFFFFFFFFFFFF00000000020000000000000000000000FCFFFFFF040000000100000000000000FFFFFFFFFAFFFFFF04000000FEFFFFFF0200000000000000030000000000000001000000050000000600000000000000FBFFFFFF0100000000000000FDFFFFFF020000000100000002000000FBFFFFFF00000000FAFFFFFFFFFFFFFF0400000003000000FFFFFFFF00000000FEFFFFFFFFFFFFFFFFFFFFFF05000000FFFFFFFF0000000000000000030000000100000000000000000000000300000000000000FFFFFFFFFDFFFFFFFEFFFFFF01000000000000000100000003000000FFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000FFFFFFFF0000000000000000FFFFFFFF00000000FFFFFFFFFDFFFFFF0300000000000000FCFFFFFFFDFFFFFF00000000FCFFFFFFF8FFFFFF000000000400000001000000FCFFFFFFFFFFFFFF00000000FEFFFFFF03000000000000000200000001000000FBFFFFFF03000000FFFFFFFF00000000F9FFFFFF02000000020000000000000005000000FEFFFFFFFFFFFFFF0200000000000000FEFFFFFF01000000010000000100000000000000010000000000000001000000FCFFFFFF01000000FBFFFFFF00000000FDFFFFFF01000000"> : tensor<1x125xi32>
    return %c : tensor<1x125xi32>
  }
}
