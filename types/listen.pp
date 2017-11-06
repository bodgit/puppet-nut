#
type Nut::Listen = Struct[{'address' => IP::Address::NoSubnet, Optional['port'] => Integer[0, 65535]}]
