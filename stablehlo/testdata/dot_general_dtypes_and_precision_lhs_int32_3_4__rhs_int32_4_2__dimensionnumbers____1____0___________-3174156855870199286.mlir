// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<3x4xi32>, tensor<4x2xi32>)
    %1 = call @expected() : () -> tensor<3x2xi32>
    %2 = "stablehlo.dot_general"(%0#0, %0#1) {dot_dimension_numbers = #stablehlo.dot<lhs_contracting_dimensions = [1], rhs_contracting_dimensions = [0]>, precision_config = [#stablehlo<precision HIGHEST>, #stablehlo<precision HIGHEST>]} : (tensor<3x4xi32>, tensor<4x2xi32>) -> tensor<3x2xi32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<3x2xi32>, tensor<3x2xi32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<3x4xi32>, tensor<4x2xi32>) {
    %0 = stablehlo.constant dense<[[-2, 0, 4, -2], [2, -2, -2, -2], [-4, 1, 3, 0]]> : tensor<3x4xi32>
    %1 = stablehlo.constant dense<[[-2, -1], [-3, -3], [1, -1], [8, 0]]> : tensor<4x2xi32>
    return %0, %1 : tensor<3x4xi32>, tensor<4x2xi32>
  }
  func.func private @expected() -> tensor<3x2xi32> {
    %0 = stablehlo.constant dense<[[-8, -2], [-16, 6], [8, -2]]> : tensor<3x2xi32>
    return %0 : tensor<3x2xi32>
  }
}