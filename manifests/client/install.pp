# @!visibility private
class nut::client::install {

  ensure_packages([$::nut::client::package_name])
}
