// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0], [1]], [[2], [3]]]> : tensor<2x2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xi32>, tensor<5x2x2x7xi32>)
    %2 = call @expected() : () -> tensor<5x6x7xi32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i32>, %arg1: tensor<i32>):
      %5 = stablehlo.minimum %arg0, %arg1 : tensor<i32>
      stablehlo.return %5 : tensor<i32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 3], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xi32>, tensor<2x2x1xi32>, tensor<5x2x2x7xi32>) -> tensor<5x6x7xi32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xi32>, tensor<5x6x7xi32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xi32>, tensor<5x2x2x7xi32>) {
    %0 = stablehlo.constant dense<"0x00000000020000000200000002000000020000000200000000000000FEFFFFFF01000000FFFFFFFFFEFFFFFFFEFFFFFFFEFFFFFF0500000000000000030000000300000003000000020000000200000004000000FFFFFFFFFDFFFFFF020000000000000001000000000000000200000000000000FFFFFFFF000000000000000001000000FEFFFFFF03000000FDFFFFFFFEFFFFFFFFFFFFFFFDFFFFFF01000000FEFFFFFF0400000000000000010000000000000006000000000000000000000001000000F8FFFFFFFDFFFFFF00000000FFFFFFFF01000000FAFFFFFF0100000005000000FDFFFFFFFCFFFFFFFFFFFFFF00000000000000000300000000000000FFFFFFFF0300000000000000FFFFFFFF0600000002000000000000000400000000000000060000000000000004000000FEFFFFFFFFFFFFFF00000000FBFFFFFF00000000FBFFFFFFFEFFFFFF02000000FFFFFFFFFDFFFFFFFBFFFFFFFFFFFFFF02000000000000000100000000000000000000000000000000000000FFFFFFFF01000000FEFFFFFF02000000FFFFFFFF000000000000000000000000FDFFFFFFFFFFFFFF02000000FFFFFFFF0600000004000000FAFFFFFFFFFFFFFF0300000001000000FEFFFFFF0400000001000000050000000000000000000000FEFFFFFF02000000000000000000000000000000FEFFFFFF0000000000000000FFFFFFFFFEFFFFFFFDFFFFFFFCFFFFFF04000000FBFFFFFF060000000A00000000000000010000000400000000000000FEFFFFFF000000000000000000000000FFFFFFFFFDFFFFFF020000000300000001000000FEFFFFFF02000000F8FFFFFF00000000FFFFFFFFFEFFFFFFFDFFFFFFFFFFFFFFFFFFFFFFFCFFFFFF0100000001000000FFFFFFFF04000000FDFFFFFFFFFFFFFF0000000000000000FDFFFFFFFFFFFFFF0000000000000000FFFFFFFFFDFFFFFFFFFFFFFF06000000FFFFFFFF00000000000000000700000001000000FDFFFFFF0000000000000000FFFFFFFFFEFFFFFF00000000FDFFFFFFFBFFFFFF010000000100000001000000FBFFFFFF0000000002000000FDFFFFFF01000000FFFFFFFF00000000FFFFFFFF00000000FEFFFFFF06000000000000000300000000000000FFFFFFFFFDFFFFFF010000000000000002000000FEFFFFFF"> : tensor<5x6x7xi32>
    %1 = stablehlo.constant dense<"0x05000000FEFFFFFFFEFFFFFF03000000050000000000000002000000030000000000000000000000FCFFFFFFFAFFFFFFFEFFFFFF0000000003000000030000000000000006000000FEFFFFFF030000000100000000000000020000000200000001000000FEFFFFFF00000000010000000200000000000000FFFFFFFF00000000FEFFFFFFFDFFFFFF02000000FFFFFFFFFFFFFFFFFCFFFFFFFCFFFFFF0200000000000000FFFFFFFF04000000010000000300000000000000FDFFFFFF02000000FBFFFFFFFEFFFFFFFFFFFFFF000000000100000001000000000000000300000000000000FFFFFFFF00000000010000000200000000000000FFFFFFFFFDFFFFFF00000000FFFFFFFFFFFFFFFF02000000FFFFFFFFFEFFFFFFFEFFFFFF00000000FEFFFFFFFFFFFFFF060000000000000003000000FFFFFFFF01000000FFFFFFFF000000000300000000000000FFFFFFFFFCFFFFFF000000000000000000000000FFFFFFFF00000000FEFFFFFFFDFFFFFFFEFFFFFF00000000FFFFFFFF0200000001000000FFFFFFFF01000000FFFFFFFFFEFFFFFFFFFFFFFFFEFFFFFF00000000FCFFFFFFFDFFFFFFFDFFFFFF000000000200000000000000FCFFFFFF000000000000000002000000FDFFFFFF0000000001000000020000000200000000000000FEFFFFFF02000000FFFFFFFF03000000FDFFFFFFFFFFFFFF0100000004000000FCFFFFFF00000000000000000000000002000000FDFFFFFFFEFFFFFFFFFFFFFFFDFFFFFF030000000000000002000000"> : tensor<5x2x2x7xi32>
    return %0, %1 : tensor<5x6x7xi32>, tensor<5x2x2x7xi32>
  }
  func.func private @expected() -> tensor<5x6x7xi32> {
    %0 = stablehlo.constant dense<"0x00000000FEFFFFFFFEFFFFFF02000000020000000000000000000000FEFFFFFF00000000FFFFFFFFFCFFFFFFFAFFFFFFFEFFFFFF0000000000000000030000000000000003000000FEFFFFFF0200000001000000FFFFFFFFFDFFFFFF0200000000000000FEFFFFFF000000000100000000000000FFFFFFFF000000000000000001000000FEFFFFFF03000000FDFFFFFFFEFFFFFFFFFFFFFFFDFFFFFF01000000FEFFFFFF040000000000000000000000FFFFFFFF00000000FEFFFFFFFDFFFFFF01000000F8FFFFFFFDFFFFFFFCFFFFFFFCFFFFFF01000000FAFFFFFFFFFFFFFF04000000FDFFFFFFFCFFFFFFFFFFFFFFFDFFFFFF00000000FBFFFFFFFEFFFFFFFFFFFFFF0000000000000000FFFFFFFF0000000002000000000000000400000000000000060000000000000004000000FEFFFFFFFFFFFFFF00000000FBFFFFFF00000000FBFFFFFFFEFFFFFF02000000FFFFFFFFFDFFFFFFFBFFFFFFFFFFFFFF0200000000000000FFFFFFFFFDFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFFFEFFFFFFFFFFFFFFFEFFFFFFFFFFFFFF00000000FDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000FAFFFFFFFFFFFFFFFFFFFFFF01000000FEFFFFFF0400000001000000050000000000000000000000FEFFFFFF02000000000000000000000000000000FEFFFFFF00000000FCFFFFFFFFFFFFFFFEFFFFFFFDFFFFFFFCFFFFFF00000000FBFFFFFFFDFFFFFFFEFFFFFF00000000FFFFFFFF0200000000000000FEFFFFFF00000000FFFFFFFFFEFFFFFFFFFFFFFFFDFFFFFF00000000FCFFFFFFFDFFFFFFFDFFFFFF00000000F8FFFFFF00000000FCFFFFFFFEFFFFFFFDFFFFFFFFFFFFFFFFFFFFFFFCFFFFFF0100000001000000FFFFFFFF04000000FDFFFFFFFFFFFFFF0000000000000000FDFFFFFFFFFFFFFF0000000000000000FDFFFFFFFDFFFFFFFFFFFFFF02000000FFFFFFFF00000000FEFFFFFF02000000FFFFFFFFFDFFFFFFFDFFFFFFFFFFFFFFFFFFFFFFFEFFFFFFFCFFFFFFFDFFFFFFFBFFFFFF0000000001000000FDFFFFFFFBFFFFFFFFFFFFFFFDFFFFFFFDFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000FEFFFFFF06000000000000000300000000000000FFFFFFFFFDFFFFFF010000000000000002000000FEFFFFFF"> : tensor<5x6x7xi32>
    return %0 : tensor<5x6x7xi32>
  }
}
