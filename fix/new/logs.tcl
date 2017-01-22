variable InputLog {} 
  set InputLog [open "test[clock format [clock seconds] -format {%Y_%m_%d_%H_%M_%S}].log" w]
    variable InputLog
      fconfigure $InputLog    -buffering none -blocking 0 -translation binary