set(COMP_NAME Core)
set(IS_CUDA_DEPEND TRUE)

set(TARGET_NAME "Otter${COMP_NAME}")
file(GLOB_RECURSE CompSources
        "${CMAKE_CURRENT_SOURCE_DIR}/*.cpp"
)

file(GLOB_RECURSE CompCUDASources
        "${CMAKE_CURRENT_SOURCE_DIR}/*.cu"
)

file(GLOB_RECURSE CompHeaders
        "${OTT_INCLUDE_DIR}/Otter/${COMP_NAME}/*.hpp"
        "${OTT_INCLUDE_DIR}/Otter/${COMP_NAME}/*.inl"
        "${CMAKE_CURRENT_SOURCE_DIR}/*.hpp"
        "${CMAKE_CURRENT_SOURCE_DIR}/*.inl"
)

set(CompDefinitions
        $<$<CONFIG:Release>:NDEBUG>
        $<$<CONFIG:Debug>:_DEBUG>
        # Windows
        $<$<PLATFORM_ID:Windows>:NOMINMAX>
        $<$<PLATFORM_ID:Windows>:UNICODE>
        # MSVC C++ 
        $<$<CXX_COMPILER_ID:MSVC>:_USE_MATH_DEFINES>
        $<$<CXX_COMPILER_ID:MSVC>:_SCL_SECURE_NO_WARNINGS>
        $<$<CXX_COMPILER_ID:MSVC>:_CRT_SECURE_NO_WARNINGS>
        $<$<CXX_COMPILER_ID:MSVC>:_ENABLE_EXTENDED_ALIGNED_STORAGE>
        $<$<CXX_COMPILER_ID:MSVC>:_SILENCE_CXX17_CODECVT_HEADER_DEPRECATION_WARNING>
)

set(CompOptions
        "$<$<COMPILE_LANGUAGE:CUDA>:--std=c++20;--use_fast_math;--expt-relaxed-constexpr;--extended-lambda;--forward-unknown-to-host-compiler>"
)

set(CompIncludeDirs
)

set(CompLinkLibraries
)

OtterAddComponent(
        NAME ${COMP_NAME}
        SOURCES ${CompSources}
        HEADERS ${CompHeaders}
        CUDA_SOURCES ${CompCUDASources}
        CUDA_DEPEND ${IS_CUDA_DEPEND}
        COMPILE_DEFINITIONS ${CompDefinitions}
        COMPILE_OPTIONS ${CompOptions}
        INCLUDE_DIRECTORIES ${CompIncludeDirs}
        LINK_LIBRARIES ${CompLinkLibraries}
)
