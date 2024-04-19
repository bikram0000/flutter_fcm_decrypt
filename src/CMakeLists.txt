# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(flutter_fcm_decrypt_library VERSION 0.0.1 LANGUAGES C)

add_library(flutter_fcm_decrypt SHARED
  "flutter_fcm_decrypt.c"
)

set_target_properties(flutter_fcm_decrypt PROPERTIES
  PUBLIC_HEADER flutter_fcm_decrypt.h
  OUTPUT_NAME "flutter_fcm_decrypt"
)

target_compile_definitions(flutter_fcm_decrypt PUBLIC DART_SHARED_LIB)
