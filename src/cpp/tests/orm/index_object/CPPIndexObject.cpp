//
// Created by qiuwenchen on 2022/9/7.
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

#include "CPPIndexObject.hpp"

WCDB_CPP_ORM_IMPLEMENTATION_BEGIN(CPPIndexObject)

WCDB_CPP_SYNTHESIZE(index_)
WCDB_CPP_SYNTHESIZE(indexAsc)
WCDB_CPP_SYNTHESIZE(indexDesc)
WCDB_CPP_SYNTHESIZE(uniqueIndex)
WCDB_CPP_SYNTHESIZE(uniqueIndexAsc)
WCDB_CPP_SYNTHESIZE(uniqueIndexDesc)
WCDB_CPP_SYNTHESIZE(multiIndex)
WCDB_CPP_SYNTHESIZE(multiIndexAsc)
WCDB_CPP_SYNTHESIZE(multiIndexDesc)

WCDB_CPP_INDEX("_index", index_)
WCDB_CPP_INDEX_ASC("_index_asc", indexAsc)
WCDB_CPP_INDEX_DESC("_index_desc", indexDesc)

WCDB_CPP_UNIQUE_INDEX("_unique_index", uniqueIndex)
WCDB_CPP_UNIQUE_INDEX_ASC("_unique_index_asc", uniqueIndexAsc)
WCDB_CPP_UNIQUE_INDEX_DESC("_unique_index_desc", uniqueIndexDesc)

WCDB_CPP_INDEX("_multi_index", multiIndex)
WCDB_CPP_INDEX_ASC("_multi_index", multiIndexAsc)
WCDB_CPP_INDEX_DESC("_multi_index", multiIndexDesc)

WCDB_CPP_ORM_IMPLEMENTATION_END
