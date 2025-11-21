# 设置代码文件的文件组
function(AssignSourceGroup)
    foreach (_source IN ITEMS ${ARGN})
        if (IS_ABSOLUTE "${_source}")
            file(RELATIVE_PATH _source_rel "${CMAKE_CURRENT_SOURCE_DIR}" "${_source}")
        else ()
            set(_source_rel "${_source}")
        endif ()
        get_filename_component(_source_path "${_source_rel}" PATH)
        string(REPLACE "/" "\\" _source_path_msvc "${_source_path}")
        source_group("${_source_path_msvc}" FILES "${_source}")
    endforeach ()
endfunction(AssignSourceGroup)

# 添加测试程序
macro(AddTestProgram TestFile Libraries Category)
    get_filename_component(FILE_NAME ${TestFile} NAME_WE)
    add_executable(${FILE_NAME} ${TestFile})
    gtest_discover_tests(${FILE_NAME})

    set_target_properties(${FILE_NAME} PROPERTIES FOLDER "Tests/${Category}")

    target_link_libraries(${FILE_NAME} PUBLIC ${Libraries})
    add_test(NAME "${FILE_NAME}Test" COMMAND ${FILE_NAME})
endmacro()

# 添加组件
function(OtterAddComponent)
    set(options "")
    set(oneValueArgs NAME CUDA_DEPEND)
    set(multiValueArgs SOURCES HEADERS CUDA_SOURCES COMPILE_DEFINITIONS COMPILE_OPTIONS INCLUDE_DIRECTORIES LINK_LIBRARIES)

    cmake_parse_arguments(COMP "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if (NOT COMP_NAME)
        message(FATAL_ERROR "OtterAddComponent: NAME is required")
    endif ()

    set(target_name "Otter${COMP_NAME}")
    if (TARGET ${target_name})
        message(WARNING "Target ${target_name} already exists, skipping creation")
        return()
    endif ()

    # 是否是纯头文件组件
    set(is_header_only FALSE)
    if (NOT COMP_SOURCES)
        set(is_header_only TRUE)
    endif ()

    if (is_header_only)
        # 头文件库
        add_library(${target_name} INTERFACE)
        set(include_scope INTERFACE)
    else ()
        # 静态库
        add_library(${target_name} STATIC ${COMP_SOURCES})
        set(include_scope PUBLIC)
    endif ()

    # 是否是 CUDA 组件：包含 .cu 文件，这些组件需要 nvcc 编译
    set(is_cuda_target FALSE)
    if (CUDA_SOURCES)
        set(is_cuda_target TRUE)
    endif ()

    if (is_cuda_target)
        set_target_properties(${target_name} PROPERTIES CUDA_SEPARABLE_COMPILATION ON)
        target_compile_features(${target_name} PUBLIC cuda_std_20)
    endif ()

    # CUDA 的依赖组件，强制设置为 C++20
    if (COMP_CUDA_DEPEND)
        set_target_properties(${target_name} PROPERTIES
                CXX_STANDARD 20
                CUDA_STANDARD 20
                CXX_STANDARD_REQUIRED ON
                CUDA_STANDARD_REQUIRED ON
        )
        target_compile_features(${target_name} ${include_scope} cxx_std_20)
        target_compile_definitions(${target_name} ${include_scope}
                $<$<COMPILE_LANGUAGE:CUDA>:OTT_USE_CUDA>
        )
    endif ()

    # 仅进行 interface 或 public 配置，私有配置各自单独设置

    # 公共包含
    target_include_directories(${target_name} ${include_scope}
            ${OTT_INCLUDE_DIR}
    )

    # 用户指定的包含目录
    if (COMP_INCLUDE_DIRECTORIES)
        target_include_directories(${target_name} ${include_scope} ${COMP_INCLUDE_DIRECTORIES})
    endif ()

    # 处理编译定义
    if (COMP_COMPILE_DEFINITIONS)
        target_compile_definitions(${target_name} ${include_scope} ${COMP_COMPILE_DEFINITIONS})
    endif ()

    # 处理编译选项
    if (COMP_COMPILE_OPTIONS)
        target_compile_options(${target_name} ${include_scope} ${COMP_COMPILE_OPTIONS})
    endif ()

    # 处理链接库
    if (COMP_LINK_LIBRARIES)
        target_link_libraries(${target_name} ${include_scope} ${COMP_LINK_LIBRARIES})
    endif ()

    # 创建别名
    add_library(Otter::${COMP_NAME} ALIAS ${target_name})

    message(STATUS "+ Otter::${COMP_NAME}")
endfunction()
