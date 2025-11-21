/**
 * @File CoreTest.cpp
 * @Author dfnzhc (https://github.com/dfnzhc)
 * @Date 2025/11/21
 * @Brief This file is part of Otter.
 */

#include <gtest/gtest.h>
#include <Otter/Otter.hpp>

using namespace ott;

TEST(CoreTest, Hello)
{
    Hello();
    EXPECT_TRUE(true);
}
