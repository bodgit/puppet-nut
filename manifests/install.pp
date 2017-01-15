# @!visibility private
class nut::install {

  ensure_packages([$::nut::package_name])
}
