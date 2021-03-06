# OPENCL Module
find_package(OpenCL QUIET)

if(OpenCL_FOUND)
  # always set the includedir when cuda is available
  # avoid global retrigger of cmake
  include_directories(${OpenCL_INCLUDE_DIRS})
endif(OpenCL_FOUND)

if(USE_SDACCEL)
  message(STATUS "Build with SDAccel support")
  file(GLOB RUNTIME_SDACCEL_SRCS src/runtime/opencl/sdaccel/*.cc)
  list(APPEND RUNTIME_SRCS ${RUNTIME_SDACCEL_SRCS})
  if(NOT USE_OPENCL)
    message(STATUS "Enable OpenCL support required for SDAccel")
    set(USE_OPENCL ON)
  endif()
else()
  list(APPEND COMPILER_SRCS src/codegen/opt/build_sdaccel_off.cc)
endif(USE_SDACCEL)

if(USE_OPENCL)
  find_package(OpenCL REQUIRED)
  message(STATUS "Build with OpenCL support")
  file(GLOB RUNTIME_OPENCL_SRCS src/runtime/opencl/*.cc)
  list(APPEND TVM_RUNTIME_LINKER_LIBS ${OpenCL_LIBRARIES})
  list(APPEND RUNTIME_SRCS ${RUNTIME_OPENCL_SRCS})
else()
  list(APPEND COMPILER_SRCS src/codegen/opt/build_opencl_off.cc)
endif(USE_OPENCL)
