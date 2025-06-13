//
// Created by qiuwenchen on 2022/10/30.
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

#include <WCDB/WCDBCpp.h>

class CPPFTS5Object {
public:
    CPPFTS5Object();
    CPPFTS5Object(WCDB::UnsafeStringView cont, WCDB::UnsafeStringView ext);
    WCDB::StringView content;
    WCDB::StringView extension;
    bool operator==(const CPPFTS5Object& other);
    WCDB_CPP_ORM_DECLARATION(CPPFTS5Object);
};

class CPPFTS5PinyinObject {
public:
    CPPFTS5PinyinObject();
    WCDB::StringView content;
    bool operator==(const CPPFTS5PinyinObject& other);
    WCDB_CPP_ORM_DECLARATION(CPPFTS5PinyinObject);
};

class CPPFTS5SymbolObject {
public:
    CPPFTS5SymbolObject();
    WCDB::StringView content;
    bool operator==(const CPPFTS5SymbolObject& other);
    WCDB_CPP_ORM_DECLARATION(CPPFTS5SymbolObject);
};
