// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<32> : tensor<1xi32>
    %1:2 = call @inputs() : () -> (tensor<1x50x3xi32>, tensor<1x3xi32>)
    %2 = call @expected() : () -> tensor<1x50x3xi32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i32>, %arg1: tensor<i32>):
      %5 = stablehlo.multiply %arg0, %arg1 : tensor<i32>
      stablehlo.return %5 : tensor<i32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1]>, unique_indices = true} : (tensor<1x50x3xi32>, tensor<1xi32>, tensor<1x3xi32>) -> tensor<1x50x3xi32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<1x50x3xi32>, tensor<1x50x3xi32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1x50x3xi32>, tensor<1x3xi32>) {
    %0 = stablehlo.constant dense<"0x0400000001000000FDFFFFFF0000000000000000FFFFFFFFFEFFFFFF00000000FCFFFFFFFDFFFFFF0200000000000000FCFFFFFFFFFFFFFF0500000000000000FFFFFFFF0200000005000000FFFFFFFF010000000100000000000000FEFFFFFF04000000FFFFFFFFFAFFFFFF040000000000000000000000030000000200000000000000FEFFFFFF030000000000000001000000FDFFFFFF0100000000000000FFFFFFFF000000000000000003000000FBFFFFFF0000000000000000020000000700000003000000FFFFFFFF00000000010000000300000000000000010000000200000002000000FBFFFFFF0100000004000000FCFFFFFF000000000900000000000000FDFFFFFF00000000FFFFFFFF0200000000000000FFFFFFFFF8FFFFFFFCFFFFFF01000000FDFFFFFFFFFFFFFF0000000006000000FBFFFFFF01000000FCFFFFFF00000000FDFFFFFF010000000000000001000000FDFFFFFF00000000000000000000000000000000FEFFFFFF0000000001000000020000000300000005000000FFFFFFFF00000000FEFFFFFF0200000002000000FDFFFFFF00000000FEFFFFFFFAFFFFFF0400000000000000FFFFFFFF02000000FDFFFFFFFDFFFFFFFBFFFFFF0100000002000000FEFFFFFFFEFFFFFF0300000000000000FDFFFFFF00000000030000000200000008000000FEFFFFFFFFFFFFFFFEFFFFFFFDFFFFFF0000000001000000FEFFFFFF09000000FCFFFFFF0000000005000000000000000000000000000000FCFFFFFF01000000FEFFFFFF02000000050000000300000000000000FCFFFFFF03000000FFFFFFFF0100000000000000"> : tensor<1x50x3xi32>
    %1 = stablehlo.constant dense<[[-2, 0, -3]]> : tensor<1x3xi32>
    return %0, %1 : tensor<1x50x3xi32>, tensor<1x3xi32>
  }
  func.func private @expected() -> tensor<1x50x3xi32> {
    %0 = stablehlo.constant dense<"0x0400000001000000FDFFFFFF0000000000000000FFFFFFFFFEFFFFFF00000000FCFFFFFFFDFFFFFF0200000000000000FCFFFFFFFFFFFFFF0500000000000000FFFFFFFF0200000005000000FFFFFFFF010000000100000000000000FEFFFFFF04000000FFFFFFFFFAFFFFFF040000000000000000000000030000000200000000000000FEFFFFFF030000000000000001000000FDFFFFFF0100000000000000FFFFFFFF000000000000000003000000FBFFFFFF0000000000000000020000000700000003000000FFFFFFFF00000000010000000300000000000000010000000200000002000000FBFFFFFF0100000004000000FCFFFFFF000000000900000000000000FDFFFFFF00000000FFFFFFFF0200000000000000FFFFFFFFF8FFFFFFFCFFFFFF01000000FDFFFFFFFFFFFFFF0000000006000000FBFFFFFF01000000FCFFFFFF00000000FDFFFFFF010000000000000001000000FDFFFFFF00000000000000000000000000000000FEFFFFFF00000000010000000200000003000000F6FFFFFF0000000000000000FEFFFFFF0200000002000000FDFFFFFF00000000FEFFFFFFFAFFFFFF0400000000000000FFFFFFFF02000000FDFFFFFFFDFFFFFFFBFFFFFF0100000002000000FEFFFFFFFEFFFFFF0300000000000000FDFFFFFF00000000030000000200000008000000FEFFFFFFFFFFFFFFFEFFFFFFFDFFFFFF0000000001000000FEFFFFFF09000000FCFFFFFF0000000005000000000000000000000000000000FCFFFFFF01000000FEFFFFFF02000000050000000300000000000000FCFFFFFF03000000FFFFFFFF0100000000000000"> : tensor<1x50x3xi32>
    return %0 : tensor<1x50x3xi32>
  }
}
