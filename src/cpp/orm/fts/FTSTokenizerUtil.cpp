//
// Created by qiuwenchen on 2022/8/27.
//

/*
 * Tencent is pleased to support the open source community by making
 * WCDB available.
 *
 * Copyright (C) 2017 THL A29 Limited, a Tencent company.
 * All rights reserved.
 *
 * Licensed under the BSD 3-Clause License (the "License"); you may not use
 * this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 *       https://opensource.org/licenses/BSD-3-Clause
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "FTSTokenizerUtil.hpp"
#include "StatementCreateVirtualTable.hpp"
#include <cstdarg>

namespace WCDB {

StringView FTSTokenizerUtil::tokenize(const char* name, ...)
{
    StringView tokenizerPrefix = Syntax::CreateVirtualTableSTMT::tokenizerPreFix();
    std::ostringstream stream;
    stream << tokenizerPrefix.data() << name;
    va_list pArgs;
    va_start(pArgs, name);
    const char* parameter = nullptr;
    while ((parameter = va_arg(pArgs, const char*)) != nullptr) {
        stream << ' ' << parameter;
    }
    return WCDB::StringView(stream.str());
}

} // namespace WCDB
