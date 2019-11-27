add_subdirectory(unnamed-dev-type)

define_device(
  DEVICE polarpro-3e
  ARCH quicklogic-polarpro-3e
  DEVICE_TYPE unnamed-dev-type
  PACKAGES wlcsp
  CACHE_PLACE_DELAY
  CACHE_ARGS
    --route_chan_width 100
    --clock_modeling route
    --allow_unrelated_clustering off
    --target_ext_pin_util 0.7
    --router_init_wirelength_abort_threshold 2
    --congested_routing_iteration_threshold 0.8
)
