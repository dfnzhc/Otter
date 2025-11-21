
message(STATUS "")
message(STATUS "=== [OTT] ===")

add_subdirectory(Core)

add_library(Otter INTERFACE)

target_link_libraries(Otter
        INTERFACE
        Otter::Core
)

target_include_directories(Otter
        INTERFACE
        ${OTT_INCLUDE_DIR}
)

add_library(Otter::Otter ALIAS Otter)

message(STATUS "=== [OTT] ===")
message(STATUS "")