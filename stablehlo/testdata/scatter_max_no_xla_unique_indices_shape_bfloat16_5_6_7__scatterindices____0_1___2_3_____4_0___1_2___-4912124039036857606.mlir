// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0, 1], [2, 3]], [[4, 0], [1, 2]]]> : tensor<2x2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xbf16>, tensor<5x2x2xbf16>)
    %2 = call @expected() : () -> tensor<5x6x7xbf16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<bf16>, %arg1: tensor<bf16>):
      %5 = stablehlo.maximum %arg0, %arg1 : tensor<bf16>
      stablehlo.return %5 : tensor<bf16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1, 2], scatter_dims_to_operand_dims = [1, 2], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xbf16>, tensor<2x2x2xi32>, tensor<5x2x2xbf16>) -> tensor<5x6x7xbf16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xbf16>, tensor<5x6x7xbf16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xbf16>, tensor<5x2x2xbf16>) {
    %0 = stablehlo.constant dense<"0xBC3E803F2AC04140703FD1C0093F09C0C73ED33F593F27C082BF3C406740303F1AC0D43F6BC091C036BFCE3ED43FBA4066BF4C40DAC0873F924083C084BF61BFB93FCD4021400FC0CFBFCCBFC0BECD3E3E3F0EBF78407DC0EBBF72401DBFE03F65C02BC09A40EE3DC1BF383F99BEA4C0BC40DBBFAC40A6BFF7BEA4401440053F434007C0A3BF2340C03F11C0133E31C0AD40593E4C3DCBBF31403BC046C0C53FE1BE024061409D3F2040923EE5BF6D40703F12C044BE9B3FD03F9F3F18C0B2C04F3F6540B4BF70C04540ACC020BFA640C1BD2C406A408CC0D8BE71C049C0003F4ABFCDBEF03F0541DDBF8AC024BF98BFE1C080C0C5BE4DC034C05AC0283F5940B2BF9DC02CC0624091C061C002C018C1E13F8DBF10C0873F42BF74BE7140894043C023C01BBE9ABF8240613E04C04ABF803FCA40B33F32C067BF1BC0B0C0C1C0D53FBFC0BABF4CC035C0DEBEA5BF8AC0B1BF4CC0F9BE19BF0BBF743FE5BE95BE193F4C4052C0BDBFAFC00EC0A0BF32C0683E8CBE8CBE06C0D43FFD3E37BF4F409A4036401240253FE43CA03F134060C067C0A640CD3FC1BFB8BF1A4162C04A4018404440"> : tensor<5x6x7xbf16>
    %1 = stablehlo.constant dense<[[[-1.390630e+00, -5.562500e+00], [2.984380e+00, -1.359380e+00]], [[-2.468750e+00, 2.109380e+00], [-2.578130e+00, 2.484380e+00]], [[-1.382810e+00, 2.562500e+00], [3.085940e-01, 1.632810e+00]], [[4.656250e+00, -5.062500e+00], [-6.328130e-01, -1.044920e-01]], [[-1.695310e+00, 1.031250e+00], [-1.000980e-01, 2.890630e+00]]]> : tensor<5x2x2xbf16>
    return %0, %1 : tensor<5x6x7xbf16>, tensor<5x2x2xbf16>
  }
  func.func private @expected() -> tensor<5x6x7xbf16> {
    %0 = stablehlo.constant dense<"0xBC3E803F2AC04140703FD1C0093F09C0C73ED33F593F27C082BF3C406740303F1AC0D43F6BC091C036BFCE3ED43FBA4066BF4C40DAC0873F924083C084BF61BFB93FCD4021400FC0CFBFCCBFC0BECD3E3E3F0EBF78401EC0EBBF72401DBFE03F65C02BC09A401F40C1BF383F99BEA4C0BC40DBBFAC400740F7BEA4401440053F434007C0A3BF2340C03F11C0133E31C0AD40593E4C3DCBBF31403BC046C0C53FE1BE024061409D3F2040923EE5BF6D40703F12C044BE9B3FD03FD13F18C0B2C04F3F6540B4BF70C04540244020BFA640C1BD2C406A408CC0D8BE71C049C0003F9E3ECDBEF03F0541DDBF8AC024BF98BFE1C080C0C5BE4DC034C05AC0283F9540B2BF9DC02CC0624091C061C002C0D6BDE13F8DBF10C0873F42BF74BE7140894043C023C01BBE9ABF8240613E04C04ABF803FCA40B33F32C067BF1BC0B0C0C1C0D53FBFC0BABF4CC035C0DEBEA5BF8AC0B1BFD9BFF9BE19BF0BBF743FE5BE95BE193F4C4052C0BDBFAFC00EC0A0BF32C0683E843F8CBE06C0D43FFD3E37BF4F409A4036401240253FE43CA03F134060C067C0A640CD3FC1BFB8BF1A4162C04A4018404440"> : tensor<5x6x7xbf16>
    return %0 : tensor<5x6x7xbf16>
  }
}
