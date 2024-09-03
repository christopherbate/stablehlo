// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<20x20xf64> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0 = call @inputs() : () -> tensor<20x20xf64>
    %1 = call @expected() : () -> tensor<20x20xf64>
    %2 = stablehlo.sine %0 : tensor<20x20xf64>
    stablehlo.custom_call @check.expect_close(%2, %1) {has_side_effect = true} : (tensor<20x20xf64>, tensor<20x20xf64>) -> ()
    return %2 : tensor<20x20xf64>
  }
  func.func private @inputs() -> (tensor<20x20xf64> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0x44A55F04C2A304C08E765FD3047E0C40556FF0DFCA6302C0F61E5635FDF103C01D9B41E63767D6BF988CF67DF5BBD73F72BB7EFA216DF3BF889CE293EC2AED3FAE7BF78484C2134061C7D7E599EE1040EC70D50163370740B29E621256DD01C074D14EDE538A10C0EB96351AFB4609C0B8A338FE5A8505400C334823C68112C0C6BA7D96201FEF3F313013BF11BCE73FEE2815DED27CF73F427ABC2ED021F7BF727ECFB00BA61A40610B3864502E10404C4C942E26D9D9BF2869E38AC8DFE0BFA0FB6723AEDCEDBF8E3B778A3DA3D03F94C70579DD1FF93FB0E955A981E100C02ED46DB7018E0A407A2BB4D7F317C63F86B940E33937C2BF5D2653B93EF4F83FC36A59C7750EFB3F8802022D8A15004092CBD8FAF9F0F5BF11A84458C7331B40065326B6276509C06AA61D390E03FC3FAFA1DFFD6BA910C0D6DEB19E872A0CC0B8E977F34E4AF2BF186AB6A4F57C0040B0D5B94DB6530CC01ED77F1324250140792A579BD268ECBF21FFFB046B39F03F857760F8B94F17C08263859A3FE812C02FD6E6B98C2724C0F64673DE75F9F5BFB4D21BB149E0E53FCB082033E74AE93F31B13A14A8A7F8BF035FCD33A3DFE33F722059A656590640847C98D22EC413C0E87A7AF2424B1440C2584D51470CCDBF2E8C99635F25FFBFC241734DB47116C0F4279E7FB1CBF63F30EB881D3243F63FF45A6E4A3C43F0BF3323FF8486E0D43F099134C66E32D43FB424C924A17B01C075BF1229D522FCBF94F735053355E9BF2941A8C32B76F03FC81D5FCCE62F10C0346FD1D896FFFDBF909C3133FA8BF63F1C5FB977F27FEC3F1444EDEFA0B4CCBFAC639E49EB17EEBFA37BC8C5005D05C04EC6DA04D7191340900AB645C5B2C9BF2EB593EA940306C05D7252E5A8960F40380B7D98A114FBBF546C3C8C68ACF0BFB67CD4CF5F070BC09E19DBD6931C19C09E35EBF2EEA017C003980EA81FC2EABF8FE42A7BD9A203C062C0007085EBF8BFA7E681955219F73F62B26744F158C4BF62DBABC9D139E1BFE7B4D9621174F43F9E662040C5EC10C0D68B8ED7FD5808402874732891C41AC0EA7C5E48BCDF14C0C9B55310A208FE3FAB5CC539258115C0C682A22F6087FFBF34A896A2CC3A00402AA41C4FE95D1DC0E8758A7366BED83F6024EDC0A92D00C0ECB2B5E652C8ED3F95F534A8BFB0EEBFB2610863455400404C7881C9428A06C0B7404A81779A02C0CACBFC61E48215C0C0764D9DBF590AC009ADA55319780940E9B40474517B13408087754F00B6E33F8F69B74BE84CCD3F68FD821FF8ED03C02E44E47F83400EC06BA0559B1A99FFBF71FC477269C305C0C44FE12532480840323142DDC124E03F5805FC8706960F4040F2447F38EE07407A765136FD5A02C08D99049DA72CF8BF2D366D9ABBF0A13FD8F9D19B14A2F33F630FAE514DF304C0E25CA17D8B9413C004F22D18978D0B401C9CAC858070D1BF6B91ECB001AA0140B67BF6C6319211C07EEAB1D07170E63FFC063DF2FE1FF1BF22EEDED43E0015C03D0BE3761B4B0BC0AA3FB728CE081840761393A37F41C0BFD57A485C834005C0385ED8D2A7C9F8BF4C16E5AED8991A403406003F5B91FABF02322C73779FEA3F98309DE6C05D06C076A6A3FED79DE73F3C29DE7083F912C0FFB5A902F86C154076DEB5D0D1ED0D4072F8AC730A84F53F0921A59344A915C05898D572A86DF6BF60E03CE7B9A411C032F69492EEEEDDBF573B2A2B1E3CF5BF78452C7D25950C40401CD26FD34602C0A95178263090FE3F539BF3DE08050140B4AB923986B0EB3FB0AC0016BF43B13FE29341E4BA250440FB3295B848E0DBBF21D6FE011E870340906C39C48A1DF73F8B20A1FCC91FF03F06785F6D74E54DBF2ACA1BA5AD830CC012DED8D78B8F0E4002DB91712414F2BFD0385F1586AEF83F8A976C95C80710C0E3BCB9FB5927DA3FDAAFA4952198D53F1A729959A4F60EC0DA7F2787C94FD63F2E39BE72ED7B0240A0D83C86D6FC0940B0924EBBEE0B1240CAE7E61B269001C0D4313321A14F0DC0901B45AE6608E9BFE6D33C6108EC0D406BE9A62D64C716C0F4C2C0FD2566FE3F0FA59051C3A5DB3F7AB76A06C2F5E23F4EB74059D39CF6BF62CF5740955A18C07B17C59C6745F03F0CB69089D0ADF73F1229B92FA697054042D41DCFEE40D4BF873D5053248808409C5B24723AA0EBBFF01C1F2EABCCE6BFC076A71BEE3203C0AEFD58E324BF0A4014D8503004FC0D40DEFDDC8B4AF510C0E487877A0A2822409E193A04144A04C04DAE9D94F65C224097E1C275A86900C0B50E91C5A79C0F40DC24674D05730AC0EA4010FC43E406400A7B949A129BFFBFE4E2BDB8FE211BC0E6E8A1B27695F0BF640D6B26F53AF43F56931CC1E9FAD0BF105C164DD0ABE03F6C144BD2C0AE0740407983C36466FEBFF255DF75DE03F53F728DAB26F2F9E6BF329A4ECBE96211C0D0464A2903F609C08F3C542E27A3034000C8DCE53B9916C096C4F46918BB0B40C58CEFEC5535DFBF28BBEB5A5BF20CC0F1C063C30B99FB3F5C6FCAE1BF58D7BFEF408C75CF3A10406A2759244241FABFF0C322DDB4880840BC644091F172F33F5CA9B34BED5F0A40B254222030D6F1BFD9410F3943A5DDBFD636F408F667F5BF16240D935A4514C0174A0B91987401C0280AE5BA0764F43F7C442A491B010AC058B25FCE46FDDA3F33238684CE35D73FFCDCF84E53E4FD3F86DC2511B343FABF6E1EED2F3E95EABF247E73047BCFF93F1C3FC443016E04400EDD3CA5350DFD3F23359FF88785F7BF6A9A00729E1CDCBFC2F2BAA79B5C1FC07CA05F78232C0FC0431AC25E120407404FD4D69C78E814C098DCED283AC1603FFED13E78B651F9BF590690E02264EBBF16DD7DED0CC0F4BFC0D32037A9EBDD3F3CAF3B6FF43602C0F6C2B9A5AFCA0A402F9FEC355C8BFB3F2C3C227D4466C23FB24BB144341C034003F14FBFF87904C01C43A34DB27418406552327977D0FE3F66C8993CA79504405763A251924702C08E8287A2F69008409421D75ECC60E83F6C349EB5FB6DF5BFAE778BC61CF0FCBF2F41DAD2FE0905C0FCEBD0254F47104056ED29797A7500403068A777F4AF004086DB68BD3EE7F9BFC82DA37775C203406186FD1D6C8315C016586E3CD1EF08C0EEFB3704E4F1FD3F8D1B01DAE5AF0C405EFFA984EB690FC0BED2ED62C5700240AABCF6E65A53EE3F3687FB1F8599F43F4DD13A0923DC11409F89E8195686F93FA82CC9F5CB62E5BFE4DFBE8B2C6AEEBF1BCDC649590002408085B73839B4D8BFEE6ADACB5897F13F146C4409E878F93FBAD6E7721E6B04C0BA144F6C13120C4033580EAF6906FD3F95EBEFF90FD6F1BFD98704642B2B09C0D1240DF26B53D83F643DDFD998BCD53F9DE1B1A9544A0540B8F9C5624B0000C0C5654CB9356001C0A42C7C304266FB3F517DEF246CACF3BF3A4C0873822EF63F92A15C9D051B02C0578784CECEF700C050E2E05B6802F73F6C3B03D4DCF1F33FD02F625BDFEC0B406785AB01462BD9BF946E40E4D3DC16402D5493B7DBA01440DCF5B1266E8D05C0325BEB7B3294084016D85C1E44571140E20B9A46C9590D40A5815F604B5E0B409A8046B867D6FC3FFE6120B79DD310400FC17DAB63A614C09235CFDA48250AC04C3989CC3037174084F3F5A1204BF1BF5E2C334EC83BFABF42FA4355888A0F4080C062146718FCBF52E5E1D067C1D83F3D2D27835E5FF7BF93F3C9E57F5914403665ECC3D623A3BFA397C8C3A97BF53F3F5FECFF0B48124068B4B9CC020F0E403C848C2A145DAC3FBC03295A7080F43F9E3EBABF6321D0BF0CADC2951231FC3F2F37143570E60D406DF4AC57131AF8BF6217B0EF3082D8BF773B1D8FDC64D23F10C0580F37C0EABFDFDCBB3028D004C0D0146DB0516A12C0D013D27C7AB518C04A41FE7473BE08C036F51D824DF008C0D271C74D847400401165BB900BD9FCBF412CF4A746DE13400C6787F6DE6806C08C3BC40598E911C09A999CFC32EA09C04877EB19D8F0F23F048751C52D80EF3F503635258D2DFD3F99F983CA344E0A406E78B09B5DFE0EC0447E536D686B0F40B0253180664415C079AFFE0CD7B50D40B4824D54690004C0628928ECBF570F407D50BC7E891A0DC0CBA6F250A3BD0640E1DF16153AF910401E592703FF99FF3F0BE8B7F4D3AAD1BF97F52A69B4D7B4BF222658B95EC0F9BF4B382BACDA26FFBF9E56C78AA6C702C0FACC9584E642FA3F5FBB0436848BF23FA3B18E407EEC07C05A014A20F61C0CC0B47A35D6B3D60F405764048AD3F8F3BF44B3DCAB36E10E40B9C67278972FDCBF97DD0EA4942DEF3F2D6429D22ED6EC3F5E1B088A637903C0DE02AD386765F3BF802DC4D7F96BFCBF9E2BAD585392F43F00DCB5917D470040BE1F16252A9E13C0189720EC9BEF03408A9E67CEFA200BC0ACB9E705D71FF0BF35E17CBFD7E40A40BC63AF8940C4FFBF26089F49C28A0BC0CEC611B8C7FAFEBFDBAC953796D6FC3F7CDF1B1640C4EDBF831517002F9114C0428D7D60C7EAF1BF"> : tensor<20x20xf64>
    return %cst : tensor<20x20xf64>
  }
  func.func private @expected() -> (tensor<20x20xf64> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0x000448D2CD0AE1BF5F51EA76D917DABF8D6EEFEEC2E3E7BFF1B208BC7753E3BF96DA1071CEF2D5BF89891514A531D73FF09FCCDD7BFCEDBFDCB42E02194BE93F180BED58CA2CEFBF881D87359B64ECBF3AABB5C6A95ECE3FED438D71283CE9BFE394DC1562D0EA3F2692DC05A17F923F5E7D8C8E44ECDB3FA16B893FF7E1EF3FBE6857D63F71EA3F346DF9D4169EE53F2B15C4E1BBD4EF3F6779D78F0AC0EFBFA9C84C3977ADD73FFBE406837C23E9BFCF406EF1B626D9BF05A0E0475A1AE0BFF4F2A8E473B6E9BFE0F179A56D73D03F037A51B8FFFFEF3F8BABBC6D3C75EBBFC15F5E47C7A1C6BFC86210ECE8FBC53FC0BE2A7E8027C2BFF23BC2427DFFEF3F484C49D2DBC4EF3FA0C063CAB2F4EC3F5FFFA688935DEFBF33E182059AA7DF3FBB3FF42553CAA03F03A77AAAB87BEF3F82411696F554EB3F27D6BBAC96B0D73F767B73843C1EEDBF27BA40DA393BEC3F7003F04666E1D83F7548A1967EE6EA3F3A8CF40B64D2E8BFE1009A7BB22AEB3FA5CD5D22F824DC3F5CB5471526FFEF3F600870A4C36DE33F92506DD1EB60EFBF44764A702736E43FE318626D7BBDE63FE37E89DA58FCEFBF25F684B1D59EE23FD7096AD7C9D2D53FF5F4DB37C629EF3F877888B1A9EFEDBF44528A339DCCCCBFB092D45B3BC4EDBFC30A457EE2ECE33F1F363FEFC3A8EF3F058883FE897CEF3FE69666A90D35EBBF0B842E843E82D43F1E2D25F109DDD33F40BF9AA60A25EABF8350C09E1A70EFBF98970EB9B8C4E6BFADCF82DB236AEB3F6C513445562BE93F096F84E31D88EEBF508810F53C95EF3F45E522B9F5E0E83F7D8ED5692F77CCBFCDE9A1308BD9E9BFB71B7AE1550DDDBF94B40EFAD3EFEFBF4F548CDFA986C9BFCE53AFB7A352D8BFD7623F6F3A1CE7BFFD39577A5EC3EFBFC78C599679A1EBBF165FE16EC60DCE3F0A05B710EF9D753F1980C4349D80D73FFBA8DFD346BFE7BF054BF3A3044CE4BF718A89A146FFEFBF6CFABCEDE7BDEF3FA85E5A390843C4BF8B585861E867E0BFD1D2FB1826A4EE3F31628201D75DEC3FDC07DBD25D15B93FB5B38D036670D9BFD9E459F70DFDEB3FC7C44A7CAE82EE3FD837F4C6D634E93F13C1726E1D7AEDBF1A035E0B08B4EC3FAFF711D66BE4EBBF0FF9F9CCC421D83FEF7F54EF1BCBECBFB137239350AAE93FAF8DA5DE7832EABFDBA4601F6C86EC3F8BFE178E4E61D4BF3C6E852F1850E7BF805BF292382CE93FC660FA1A0669C33FB5568916E085A5BF0C69D2E9E899EFBFEE48586EE97CE23F0F143A49920BCD3F4EEF6E244660E3BFD37B6B209F1BE33F68B18EB63E6CEDBF8F18988E582ADABF6CE4ED27052CBB3F2734B50558EFDE3F7AAB9123791AE7BF80E4692CAA29C33F7CA7D92122FBE7BFD692548A4FF1EFBF55577B06CBEFA13F70879D53D020EE3F9382E0D78FF4DFBFCA517749B277EF3F376BC7109811D3BFDE6EB1147539D1BF941616845EB8E93FACE921DB1C61EE3FB04E3A1F1CA5E43FAA2454584013ECBFEB87F5BC627BEB3F1AFCC5726713D13FE8F0B79D805AD1BF4923812D5236C0BF65623E56B1D7DDBF97CC926C18FEEFBF20EB887DB3F7D63F2EE8CC6412DFEFBF954759F7FDA7E73F4EF0F16E92B1D5BFA9F78808C487E53F10B8CC58FEFBEF3F676D24160597E9BF5AEA92CB5F0EE2BFED26AF65922FEF3F195B2FC8316AE83F7186E13D428BEFBFEF0ADB456B8EEE3FF00EC0BF97DADCBF9B0A31EA190EEFBF98679F675DC0DABF0ADCC5693C30E8BFD7655505AB2CEE3FB55A014E332BEB3F633739447A5CE83FF9640E9C6540B13F6A6E072FF3ACE23F2D783224C500DBBF4A6563894CA1E43F73CBDBB2F8BEEF3F05883F45790FEB3F9F78C92774E54DBF490D8A692A41DA3FCF84C03F8015E4BF1DE04611A8F0ECBF8B065CE5BEFCEF3F390F106F3F60E83F91C1752D8D6ED93FF2388793D52FD53FBD269C25E64FE53F84F86D5ECADCD53F18BAED881BA3E73F8BBF2FD4134EBBBF59603E56815BEFBF0565A84461F5E9BFE29C853A68EDDF3F1E0A9995808EE6BF009570B57808E2BF8CF5C83945C3E13FDFED5BC34048EE3F710FBC42ABCBDA3F0FC04A0FB6DEE13FB4CE0895979AEFBFD542BC0A83C4C83FB5EDDA125637EB3FC8BAF72D35DEEF3FB6FBE75F4C68DB3F1548CB27D2EAD3BFBB7F3D453F36B33F7636DD12E651E8BF87B591C73CEBE4BFFC415BBD309EE5BF54A1B218D9A5C9BFAA613E6F253DE2BF89BD23D7227DEC3FE97E11DB42BDD53FA2CE25C02336E2BF0D23D4F624D3CE3FD2EDAB29415FECBF3D823590CA2CE7BF806BDD8D50F8C43F3B881433EFB1D13F5CC2032CB26AEDBF41D0CA1618AFDEBFC54E717D378AEBBFB3BA75EA7482EE3F0A40662E18C8D0BFD92FC440B8DADF3F2BF3B4172F13C73F72EDF12D1848EEBF5935255637F2EE3F128ABE266B0DE5BF2CB97F8604E2ED3F70F8E557DD74BA3FF1A47B58144BE43F007E39BCB1F1E23F0397A41ADE6BD4BFA74884F974FCDDBFA0386AC8745EDD3F9C89DC11F79EEF3F18C91E4212D5D6BFFBDE5807DD60E9BF65F68D1FDCEBEFBF0576B1093B24B33FF691EEA38800EE3F2FC2B083B6CAC3BF77027558EFBAECBFF8FA15C3C298DCBF22C0B0FBCB22EFBF7F73D5BA3B00EE3FC0946F703935EABF585AAE52D79AEE3FA65B9ACEE0D5BB3F5A96D7054D32DA3FF664A21E6AB4D63F3F9F79684598EE3F96070C2A84EBEFBFDA31A03B1AA1E7BF17F1C4EAA6F8EF3F55278C7743BFE13F081CE2B6810BEF3FE8F0ECC280D6EFBF083E49B36C37DBBFBB0032A63FFFEFBFF0238674A4EDE53F22B76006DEBCD03F96341071EADAEB3FC6A7F36439C1603F795F699C71FFEFBFD5AB7619AD2AE8BF7C8E7B069CCEEEBFB3E57548ACD7DC3FD925A6E89C59E8BF78B41586AB5ACABF9154CDCE1EA3EF3FF510EB1F1056C23F50CD813EDFE0E53F739318F25A97E1BF45F0A84CB38EC5BF9A886222EB00EE3F88EF09B4733AE13F7361F16C482EE8BFE9AFCFB2B51CB23FCA68E1646B16E63F1E68EA759125EFBFFA2AB3DB6A19EFBFAD180FF5C356DFBF812FA2D5489DE9BF08CBB74B4449EC3F7B57A502F5D8EB3FE8143B6B80F6EFBF13AFFB6BA7E9E33FB1FB8AEE9929E93FA3C7178D671499BFCC55A7D94690EE3F987E6AA63182DBBF0116B6E30A9FE63F6304295719C1E73F3D80CA5967FCE93F840ED7856AB9EE3F59B0FFCC8C06EFBFAAF965978AFDEF3F5F7E716042D4E3BF501B2BC3B109EABFA237266219E5E83FC4DBEA8F5718D8BFF81134BEB982EC3FFCDC41C627FEEF3FC951F870DDC8E1BFE4AFE6C96CFAD6BFCF6CE0BFCA0EEF3F825BA907D3BAECBF33BF9A761B60723F388E52348EBED73F0EDB4A073B52D53FBCBFC8262092DD3F6D6747697918EDBF7C525F63AE63EABF7EDD1A1AEEADEF3FB4EAC274C227EEBFCF4DB8DE0D75EF3F447A786186A1E8BF4904674C0247EBBF86515C09F8B7EF3F628D24BB1E55EE3F17A025E8AFE3D5BFF0A812017886D8BF113E6BB8A333E1BF0082363E3FE3ECBF9EBEB71516B2DBBF8D3C1D717BB5B13F38314DE231C0EDBF1D22942FDD19E0BF60CC149924A7D1BF6A94888C5F25EF3F71505B0A86FEEBBFE8C845A91AD0EC3F04EAAFF4C429C03FF19772AF7183DDBFFEC41ADE3E3CECBF70FD0ABB9EECEFBF589D5B5E92FAE6BFC901FB73F873EFBF289EC4598D24D83FAB4C64107ACEEFBFD5EA92F4ADC6EDBF763D4EA1B222A3BF36209AB4CC2BEF3F843854E782ADEFBF9A623DA25F7BE2BFC7D68B8C5D59AC3F8153510F3FABEE3F2687068D9EEBCFBF82F149A5BD6AEF3F4E8837E0F7F5E1BF132EBD9900EFEFBF3CACD055F6E9D7BF56F9363A4D24D23F8D32B448FFBDE7BF37C093AC7973E0BF4E317CFBC5CFEF3FB66AFB263913BB3F102879F975DFA8BFA9A5086F49D698BF65B62E85104BEC3F69C495EE2824EFBFA164078DC3F7EEBF6D3828FFD05DD5BF051654513A20EF3F6888729FC1FCB83F9C2541DF2CA2ED3F2912C2916EA7EA3F7EC22DFD92FBEE3FF2FDCFB767B2C2BFDFF508EFE766E53F8ACC022A40A3E6BFD82E0F69B154EA3FFAAC5EB3CD53E1BF7253367E5D25E3BFBCC06F6F686BE6BF1553E3FB967ADE3FE2BE66F215DAD23F9F09E3E06B8BECBF47E67C0F8B6BED3FE52A3E699A71D1BFBA82DCDBCFD1B4BF59C38D44E0F9EFBF8DFFFBCD24C3EDBFB070FC78D8D2E6BF926E5E09A1EBEF3F9F6170C46053ED3FEBE285E6FD44C3BFFD3F13999E4BD73F16A7225D7FCAE7BF738A52C98B59EEBF514DE8D9A90FE5BF98D34B769748DBBF20C808FD6079EA3F5B0F31A3D716E93F2AFBB88A28CBE4BFA59CD1A412F7EDBF5D3D8D2C8653EFBF3DB170B661B5EE3F77B1C2D4729DEC3F617498695C69EF3F8A6A685B0D5BE33F7EE1E1CF659BCF3FE396CA2F870FEBBF71B06FF7A5F3CBBF86C3D6E8E549EDBFB2BCF9C5F7FBD23F26D5DCF815E3EDBF3D1EC1344A25EF3F865B6686E1A7E9BFD134D7A25218ED3FAD447E13FACCECBF"> : tensor<20x20xf64>
    return %cst : tensor<20x20xf64>
  }
}