//
// Created by qiuwenchen on 2022/8/26.
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

#pragma once

#include "BaseBinding.hpp"
#include "CPPDeclaration.h"
#include "Field.hpp"
#include <map>

namespace WCDB {

template<typename Base, typename Derive>
void assertFirstBaseClass()
{
    int offsetOfBase = (char*) (Base*) (Derive*) 0x1000 - (char*) (Derive*) 0x1000;
    // Base must be the first base class of Derive
    assert(offsetOfBase == 0);
    WCDB_UNUSED(offsetOfBase);
}

class WCDB_API Binding final : public BaseBinding {
public:
    Binding();
    ~Binding() override;

#pragma mark - Inherit
public:
    void inherit(const Binding& binding);

#pragma mark - Field
public:
    const Field&
    registerField(void* memberPointer, const UnsafeStringView& name, BaseAccessor* accessor);
    const StringView& getColumnName(void* memberPointer) const;
    const BaseAccessor* getAccessor(void* memberPointer) const;
    const Fields& allFields() const;

private:
    using FieldMap = std::map<void*, std::pair<StringView, BaseAccessor*>>;
    FieldMap m_fieldMap;
    Fields m_fields;

#pragma mark - ColumnDef
public:
    using BaseBinding::getColumnDef;
    ColumnDef* getColumnDef(void* memberPointer);

#pragma mark - IndexColumn
public:
    IndexedColumn getIndexColumn(void* memberPointer);
};

} //namespace WCDB
