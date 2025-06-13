//
// Created by qiuwenchen on 2022/8/11.
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

#include "HandleOperation.hpp"
#include "Assertion.hpp"
#include "CoreConst.h"
#include "Handle.hpp"
#include "InnerHandle.hpp"
#include "Notifier.hpp"

#define GetHandleOrReturnValue(writeHint, value)                               \
    RecyclableHandle handle = getHandleHolder(writeHint);                      \
    if (handle == nullptr) {                                                   \
        return value;                                                          \
    }

namespace WCDB {

HandleOperation::~HandleOperation() = default;

bool HandleOperation::insertRows(const MultiRowsValue &rows,
                                 const Columns &columns,
                                 const UnsafeStringView &table)
{
    auto insertAction = [&](Handle &handle) {
        StatementInsert insert
        = StatementInsert().insertIntoTable(table).columns(columns).values(
        BindParameter::bindParameters(columns.size()));
        if (!handle.prepare(insert)) {
            assignErrorToDatabase(handle.getError());
            return false;
        }
        for (const OneRowValue &row : rows) {
            WCTRemedialAssert(columns.size() == row.size(),
                              "Number of values is not equal to number of columns",
                              handle.finalize();
                              return false;) handle.reset();
            handle.bindRow(row);
            if (!handle.step()) {
                handle.finalize();
                assignErrorToDatabase(handle.getError());
                return false;
            }
        }
        handle.finalize();
        return true;
    };
    if (rows.size() == 0) {
        return true;
    } else if (rows.size() == 1) {
        GetHandleOrReturnValue(true, false);
        Handle newHandle = Handle(handle);
        return insertAction(newHandle);
    } else {
        return lazyRunTransaction(insertAction);
    }
}

bool HandleOperation::insertOrReplaceRows(const MultiRowsValue &rows,
                                          const Columns &columns,
                                          const UnsafeStringView &table)
{
    auto insertAction = [&](Handle &handle) {
        StatementInsert insert
        = StatementInsert().insertIntoTable(table).orReplace().columns(columns).values(
        BindParameter::bindParameters(columns.size()));
        if (!handle.prepare(insert)) {
            assignErrorToDatabase(handle.getError());
            return false;
        }
        for (const OneRowValue &row : rows) {
            WCTRemedialAssert(columns.size() == row.size(),
                              "Number of values is not equal to number of columns",
                              handle.finalize();
                              return false;) handle.reset();
            handle.bindRow(row);
            if (!handle.step()) {
                handle.finalize();
                assignErrorToDatabase(handle.getError());
                return false;
            }
        }
        handle.finalize();
        return true;
    };
    if (rows.size() == 0) {
        return true;
    } else if (rows.size() == 1) {
        GetHandleOrReturnValue(true, false);
        Handle newHandle = Handle(handle);
        return insertAction(newHandle);
    } else {
        return lazyRunTransaction(insertAction);
    }
}

bool HandleOperation::insertOrIgnoreRows(const MultiRowsValue &rows,
                                         const Columns &columns,
                                         const UnsafeStringView &table)
{
    auto insertAction = [&](Handle &handle) {
        StatementInsert insert
        = StatementInsert().insertIntoTable(table).orIgnore().columns(columns).values(
        BindParameter::bindParameters(columns.size()));
        if (!handle.prepare(insert)) {
            assignErrorToDatabase(handle.getError());
            return false;
        }
        for (const OneRowValue &row : rows) {
            WCTRemedialAssert(columns.size() == row.size(),
                              "Number of values is not equal to number of columns",
                              handle.finalize();
                              return false;) handle.reset();
            handle.bindRow(row);
            if (!handle.step()) {
                handle.finalize();
                assignErrorToDatabase(handle.getError());
                return false;
            }
        }
        handle.finalize();
        return true;
    };
    if (rows.size() == 0) {
        return true;
    } else if (rows.size() == 1) {
        GetHandleOrReturnValue(true, false);
        Handle newHandle = Handle(handle);
        return insertAction(newHandle);
    } else {
        return lazyRunTransaction(insertAction);
    }
}

bool HandleOperation::updateRow(const OneRowValue &row,
                                const Columns &columns,
                                const UnsafeStringView &table,
                                const Expression &where,
                                const OrderingTerms &orders,
                                const Expression &limit,
                                const Expression &offset)
{
    WCTRemedialAssert(columns.size() > 0, "Number of columns can not be zero", return false;)
    WCTRemedialAssert(columns.size() == row.size(),
                      "Number of values in this row is not equal to number of columns",
                      return false;) StatementUpdate update
    = StatementUpdate().update(table);
    for (int i = 0; i < columns.size(); i++) {
        update.set(columns[i]).to(WCDB::BindParameter(i + 1));
    }
    configStatement(update, where, orders, limit, offset);
    GetHandleOrReturnValue(true, false);
    bool succeed = false;
    if ((succeed = handle->prepare(update))) {
        handle->bindRow(row);
        succeed = handle->step();
        handle->finalize();
    }
    if (!succeed) {
        assignErrorToDatabase(handle->getError());
    }
    return succeed;
}

bool HandleOperation::deleteValues(const UnsafeStringView &table,
                                   const Expression &where,
                                   const OrderingTerms &orders,
                                   const Expression &limit,
                                   const Expression &offset)
{
    StatementDelete delete_ = StatementDelete().deleteFrom(table);
    configStatement(delete_, where, orders, limit, offset);
    return execute(delete_);
}

OptionalValue HandleOperation::selectValue(const ResultColumn &column,
                                           const UnsafeStringView &table,
                                           const Expression &where,
                                           const OrderingTerms &orders,
                                           const Expression &offset)
{
    auto select = StatementSelect().select(column).from(table);
    configStatement(select, where, orders, Expression(1), offset);
    return getValueFromStatement(select);
}

OptionalOneColumn HandleOperation::selectOneColumn(const ResultColumn &column,
                                                   const UnsafeStringView &table,
                                                   const Expression &where,
                                                   const OrderingTerms &orders,
                                                   const Expression &limit,
                                                   const Expression &offset)
{
    auto select = StatementSelect().select(column).from(table);
    configStatement(select, where, orders, limit, offset);
    return getOneColumnFromStatement(select);
}

OptionalOneRow HandleOperation::selectOneRow(const ResultColumns &columns,
                                             const UnsafeStringView &table,
                                             const Expression &where,
                                             const OrderingTerms &orders,
                                             const Expression &offset)
{
    auto select = StatementSelect().select(columns).from(table);
    configStatement(select, where, orders, Expression(1), offset);
    return getOneRowFromStatement(select);
}

OptionalMultiRows HandleOperation::selectAllRow(const ResultColumns &columns,
                                                const UnsafeStringView &table,
                                                const Expression &where,
                                                const OrderingTerms &orders,
                                                const Expression &limit,
                                                const Expression &offset)
{
    auto select = StatementSelect().select(columns).from(table);
    configStatement(select, where, orders, limit, offset);
    return getAllRowsFromStatement(select);
}

OptionalValue HandleOperation::getValueFromStatement(const Statement &statement, int index)
{
    OptionalValue result;
    GetHandleOrReturnValue(false, result);
    if (!handle->prepare(statement)) {
        assignErrorToDatabase(handle->getError());
        return result;
    }
    bool succeed = false;
    if ((succeed = handle->step()) && !handle->done()) {
        result = handle->getValue(index);
    }
    handle->finalize();
    if (!succeed) {
        assignErrorToDatabase(handle->getError());
    }
    return result;
}

OptionalOneColumn
HandleOperation::getOneColumnFromStatement(const Statement &statement, int index)
{
    OptionalOneColumn result;
    GetHandleOrReturnValue(false, result);
    if (!handle->prepare(statement)) {
        assignErrorToDatabase(handle->getError());
        return result;
    }
    result = handle->getOneColumn(index);
    handle->finalize();
    if (!result.succeed()) {
        assignErrorToDatabase(handle->getError());
    }
    return result;
}

OptionalOneRow HandleOperation::getOneRowFromStatement(const Statement &statement)
{
    OptionalOneRow result;
    GetHandleOrReturnValue(false, result);
    if (!handle->prepare(statement)) {
        assignErrorToDatabase(handle->getError());
        return result;
    }
    bool succeed = false;
    if ((succeed = handle->step()) && !handle->done()) {
        result = handle->getOneRow();
    }
    handle->finalize();
    if (!succeed) {
        assignErrorToDatabase(handle->getError());
    }
    return result;
}

OptionalMultiRows HandleOperation::getAllRowsFromStatement(const Statement &statement)
{
    OptionalMultiRows result;
    GetHandleOrReturnValue(false, result);
    if (!handle->prepare(statement)) {
        assignErrorToDatabase(handle->getError());
        return result;
    }
    result = handle->getAllRows();
    handle->finalize();
    if (!result.succeed()) {
        assignErrorToDatabase(handle->getError());
    }
    return result;
}

bool HandleOperation::execute(const Statement &statement)
{
    GetHandleOrReturnValue(statement.isWriteStatement(), false);
    bool succeed = handle->execute(statement);
    if (!succeed) {
        assignErrorToDatabase(handle->getError());
    }
    return succeed;
}

bool HandleOperation::runTransaction(TransactionCallback inTransaction)
{
    GetHandleOrReturnValue(true, false);
    bool succeed = handle->runTransaction([inTransaction, this](InnerHandle *innerHandle) {
        Handle handle = Handle(getDatabaseHolder(), innerHandle);
        return inTransaction(handle);
    });
    if (!succeed) {
        assignErrorToDatabase(handle->getError());
    }
    return succeed;
}

bool HandleOperation::lazyRunTransaction(TransactionCallback inTransaction)
{
    GetHandleOrReturnValue(true, false);
    if (handle->isInTransaction()) {
        Handle newHandle = Handle(getDatabaseHolder(), handle.get());
        return inTransaction(newHandle);
    } else {
        handle->markErrorNotAllowedWithinTransaction();
        return runTransaction(inTransaction);
    }
}

bool HandleOperation::runPausableTransactionWithOneLoop(TransactionCallbackForOneLoop inTransaction)
{
    Handle newHandle = Handle(getDatabaseHolder());
    auto handleHolder = newHandle.getHandleHolder(true);
    if (handleHolder == nullptr) {
        return false;
    }
    bool succeed = handleHolder->runPausableTransactionWithOneLoop(
    [&](InnerHandle *, bool &stop, bool isNewTransaction) {
        return inTransaction(newHandle, stop, isNewTransaction);
    });
    if (!succeed) {
        assignErrorToDatabase(newHandle.getError());
    }
    return succeed;
}

Optional<bool> HandleOperation::tableExists(const UnsafeStringView &tableName)
{
    Optional<bool> result;
    GetHandleOrReturnValue(false, result);
    result = handle->tableExists(tableName);
    if (!result.succeed()) {
        assignErrorToDatabase(handle->getError());
    }
    return result;
}

bool HandleOperation::dropTable(const UnsafeStringView &tableName)
{
    return execute(StatementDropTable().dropTable(tableName).ifExists());
}

bool HandleOperation::dropIndex(const UnsafeStringView &indexName)
{
    return execute(StatementDropIndex().dropIndex(indexName).ifExists());
}

void HandleOperation::notifyError(Error &error)
{
    auto handleHolder = getHandleHolder(false);
    if (handleHolder != nullptr) {
        error.infos.insert_or_assign(ErrorStringKeyPath, handleHolder->getPath());
    }
    Notifier::shared().notify(error);
}

void HandleOperation::assertCondition(bool condition)
{
    WCTAssert(condition);
}

} // namespace WCDB
