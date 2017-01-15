#
type Nut::Listen = Struct[{'address' => Ip::Address::NoSubnet, Optional['port'] => Integer[0, 65535]}]
