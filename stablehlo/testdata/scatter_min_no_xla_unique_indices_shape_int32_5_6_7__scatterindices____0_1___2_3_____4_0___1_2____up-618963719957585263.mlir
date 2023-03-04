// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0, 1], [2, 3]], [[4, 0], [1, 2]]]> : tensor<2x2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xi32>, tensor<5x2x2xi32>)
    %2 = call @expected() : () -> tensor<5x6x7xi32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i32>, %arg1: tensor<i32>):
      %5 = stablehlo.minimum %arg0, %arg1 : tensor<i32>
      stablehlo.return %5 : tensor<i32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1, 2], scatter_dims_to_operand_dims = [1, 2], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xi32>, tensor<2x2x2xi32>, tensor<5x2x2xi32>) -> tensor<5x6x7xi32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xi32>, tensor<5x6x7xi32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xi32>, tensor<5x2x2xi32>) {
    %0 = stablehlo.constant dense<"0x00000000FEFFFFFFFAFFFFFF0500000001000000FFFFFFFF0600000002000000FFFFFFFF06000000FFFFFFFFFEFFFFFF020000000000000006000000010000000000000001000000FCFFFFFF0200000001000000FFFFFFFFFFFFFFFFFFFFFFFF00000000FBFFFFFF00000000FFFFFFFF0100000001000000FFFFFFFF0300000001000000FEFFFFFF05000000FEFFFFFF0000000000000000FDFFFFFFFFFFFFFF05000000FDFFFFFFFFFFFFFF0100000001000000FBFFFFFF0000000003000000FEFFFFFF02000000020000000000000000000000FCFFFFFF04000000FEFFFFFF04000000FDFFFFFF00000000FBFFFFFF02000000000000000100000000000000FCFFFFFF0000000004000000FDFFFFFF020000000100000000000000FAFFFFFF04000000FEFFFFFFFFFFFFFFFFFFFFFF00000000FFFFFFFFFCFFFFFF0000000000000000000000000100000000000000FAFFFFFF00000000000000000100000000000000FCFFFFFF03000000FCFFFFFF00000000FEFFFFFF00000000000000000400000000000000FFFFFFFFFFFFFFFF01000000050000000400000001000000F8FFFFFF000000000000000003000000FFFFFFFF0200000000000000FFFFFFFF0000000005000000FFFFFFFFFDFFFFFF0100000009000000040000000100000003000000000000000500000000000000F9FFFFFF03000000FEFFFFFF00000000FEFFFFFF0200000002000000FFFFFFFFFDFFFFFFFEFFFFFF0000000001000000FDFFFFFF0700000000000000FEFFFFFFF9FFFFFF0000000000000000FFFFFFFFFCFFFFFF04000000FBFFFFFF020000000300000003000000FDFFFFFFFDFFFFFF060000000400000000000000FEFFFFFF0200000006000000FFFFFFFF04000000FDFFFFFF00000000FCFFFFFF03000000F9FFFFFF070000000200000002000000FCFFFFFF0000000000000000FDFFFFFF000000000400000000000000000000000000000002000000010000000100000001000000FFFFFFFF01000000FCFFFFFF02000000FFFFFFFF0200000000000000000000000100000004000000FDFFFFFFFDFFFFFF0500000001000000FEFFFFFF0000000003000000FDFFFFFF01000000FBFFFFFF01000000020000000300000000000000030000000400000003000000FBFFFFFF00000000"> : tensor<5x6x7xi32>
    %1 = stablehlo.constant dense<[[[0, 0], [-6, 0]], [[7, 0], [0, 4]], [[3, 4], [0, 0]], [[0, 0], [0, 1]], [[0, -1], [4, 1]]]> : tensor<5x2x2xi32>
    return %0, %1 : tensor<5x6x7xi32>, tensor<5x2x2xi32>
  }
  func.func private @expected() -> tensor<5x6x7xi32> {
    %0 = stablehlo.constant dense<"0x00000000FEFFFFFFFAFFFFFF0500000001000000FFFFFFFF0600000002000000FFFFFFFF00000000FFFFFFFFFEFFFFFF020000000000000006000000010000000000000000000000FCFFFFFF0200000001000000FFFFFFFFFFFFFFFFFFFFFFFF00000000FBFFFFFF00000000FFFFFFFFFAFFFFFF01000000FFFFFFFF0300000001000000FEFFFFFF05000000FEFFFFFF0000000000000000FDFFFFFFFFFFFFFF05000000FDFFFFFFFFFFFFFF0100000001000000FBFFFFFF0000000003000000FEFFFFFF02000000020000000000000000000000FCFFFFFF04000000FEFFFFFF04000000FDFFFFFF00000000FBFFFFFF02000000000000000100000000000000FCFFFFFF0000000004000000FDFFFFFF020000000100000000000000FAFFFFFF04000000FEFFFFFFFFFFFFFFFFFFFFFF00000000FFFFFFFFFCFFFFFF0000000000000000000000000100000000000000FAFFFFFF00000000000000000100000000000000FCFFFFFF03000000FCFFFFFF00000000FEFFFFFF00000000000000000400000000000000FFFFFFFFFFFFFFFF01000000040000000400000001000000F8FFFFFF000000000000000003000000FFFFFFFF0200000000000000FFFFFFFF0000000005000000FFFFFFFFFDFFFFFF0100000009000000040000000100000003000000000000000500000000000000F9FFFFFF03000000FEFFFFFF00000000FEFFFFFF0200000002000000FFFFFFFFFDFFFFFFFEFFFFFF0000000001000000FDFFFFFF0700000000000000FEFFFFFFF9FFFFFF0000000000000000FFFFFFFFFCFFFFFF04000000FBFFFFFF020000000300000003000000FDFFFFFFFDFFFFFF060000000400000000000000FEFFFFFF0200000006000000FFFFFFFF04000000FDFFFFFF00000000FCFFFFFF03000000F9FFFFFF070000000200000002000000FCFFFFFF0000000000000000FDFFFFFF000000000400000000000000000000000000000001000000010000000100000001000000FFFFFFFF01000000FCFFFFFF02000000FFFFFFFF0200000000000000000000000100000004000000FDFFFFFFFDFFFFFF0500000001000000FEFFFFFF0000000003000000FDFFFFFF01000000FBFFFFFF01000000020000000300000000000000030000000400000003000000FBFFFFFF00000000"> : tensor<5x6x7xi32>
    return %0 : tensor<5x6x7xi32>
  }
}
