#
type Nut::Listen = Struct[{'address' => Stdlib::IP::Address::NoSubnet, Optional['port'] => Integer[0, 65535]}]
