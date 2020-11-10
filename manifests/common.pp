# @!visibility private
class nut::common (
  Stdlib::Absolutepath                             $conf_dir,
  String                                           $group,
  Integer[1]                                       $minsupplies,
  String                                           $package_name,
  String                                           $service_name,
  String                                           $shutdowncmd,
  Stdlib::Absolutepath                             $state_dir,
  Boolean                                          $use_upssched,
  String                                           $user,
  Optional[Tuple[String, String]]                  $certident      = undef,
  Optional[Stdlib::Absolutepath]                   $certpath       = undef,
  Optional[Boolean]                                $certverify     = undef,
  Optional[Stdlib::Absolutepath]                   $cmdscript      = undef,
  Optional[Integer[0]]                             $deadtime       = undef,
  Optional[Integer[0]]                             $finaldelay     = undef,
  Optional[Boolean]                                $forcessl       = undef,
  Optional[Integer[0]]                             $hostsync       = undef,
  Boolean                                          $manage_package = true,
  Boolean                                          $manage_service = true,
  Optional[Integer[0]]                             $nocommwarntime = undef,
  Optional[Stdlib::Absolutepath]                   $notifycmd      = undef,
  Optional[Hash[Nut::Event, Tuple[Boolean, 3, 3]]] $notifyflag     = undef,
  Optional[Hash[Nut::Event, String]]               $notifymsg      = undef,
  Optional[Integer[0]]                             $pollfreq       = undef,
  Optional[Integer[0]]                             $pollfreqalert  = undef,
  Optional[Integer[0]]                             $rbwarntime     = undef,
) {

  contain nut::common::install
  contain nut::common::config
  contain nut::common::service

  Class['nut::common::install'] -> Class['nut::common::config']
    ~> Class['nut::common::service']
}
