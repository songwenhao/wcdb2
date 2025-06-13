# pod lib lint WCDBOptimizedSQLCipher.podspec --verbose --allow-warnings 
# pod trunk push WCDBOptimizedSQLCipher.podspec --verbose --allow-warnings
Pod::Spec.new do |sqlcipher|
  sqlcipher.name         = "WCDBOptimizedSQLCipher"
  sqlcipher.version      = "1.4.7"
  sqlcipher.summary      = "Full Database Encryption for SQLite and optimized by WCDB."
  sqlcipher.description  = <<-DESC
                          SQLCipher is an open source extension to SQLite that provides transparent 256-bit AES encryption of database files.

                          This is optimized version by WCDB, which is an efficient, complete, easy-to-use mobile database framework.
                          DESC
  sqlcipher.homepage     = "https://github.com/Tencent/sqlcipher"
  sqlcipher.license      = { :type => "BSD", :file => "LICENSE"}
  sqlcipher.author             = { "Qiuwen-Chen" => "qwchen2008@163.com" }
  sqlcipher.source       = { :git => "https://github.com/Tencent/sqlcipher.git", :tag => "v#{sqlcipher.version}" }
  sqlcipher.module_name = "sqlcipher"
  sqlcipher.public_header_files = [
    "sqlite3.h",
    "ext/fts3/fts3_tokenizer.h",
    "src/sqlite3_wcdb.h"
  ]
  sqlcipher.source_files = [
    "config.h",
    "src/callback.c",
    "src/loadext.c",
    "src/rowset.c",
    "src/treeview.c",
    "ext/userauth/userauth.c",
    "src/vtab.c",
    "src/btmutex.c",
    "src/btree.c",
    "src/btreeInt.h",
    "src/btree.h",
    "fts5.c",
    "fts5.h",
    "ext/fts3/fts3_aux.c",
    "ext/fts3/fts3_expr.c",
    "ext/fts3/fts3_hash.c",
    "ext/fts3/fts3_hash.h",
    "ext/fts3/fts3_icu.c",
    "ext/fts3/fts3_porter.c",
    "ext/fts3/fts3_snippet.c",
    "ext/fts3/fts3_tokenize_vtab.c",
    "ext/fts3/fts3_tokenizer.c",
    "ext/fts3/fts3_tokenizer1.c",
    "ext/fts3/fts3_unicode.c",
    "ext/fts3/fts3_unicode2.c",
    "ext/fts3/fts3_write.c",
    "ext/fts3/fts3.c",
    "ext/fts3/fts3.h",
    "ext/fts3/fts3Int.h",
    "src/backup.c",
    "src/legacy.c",
    "src/main.c",
    "src/notify.c",
    "src/vdbeapi.c",
    "src/table.c",
    "src/wal.c",
    "src/wal.h",
    "src/status.c",
    "src/prepare.c",
    "src/malloc.c",
    "src/mem0.c",
    "src/mem1.c",
    "src/mem2.c",
    "src/mem3.c",
    "src/mem5.c",
    "src/memjournal.c",
    "src/mutex_unix.c",
    "src/mutex_noop.c",
    "src/mutex.c",
    "src/mutex.h",
    "src/os_common.h",
    "src/os_setup.h",
    "src/os_unix.c",
    "src/sqlite3_wcdb.h",
    "src/os.c",
    "src/os.h",
    "src/threads.c",
    "src/bitvec.c",
    "src/pager.c",
    "src/pager.h",
    "src/pcache.c",
    "src/pcache.h",
    "src/pcache1.c",
    "ext/rtree/rtree.c",
    "ext/rtree/rtree.h",
    "ext/rtree/sqlite3rtree.h",
    "src/complete.c",
    "src/tokenize.c",
    "src/resolve.c",
    "parse.c",
    "parse.h",
    "src/analyze.c",
    "src/func.c",
    "src/wherecode.c",
    "src/whereexpr.c",
    "src/whereInt.h",
    "src/alter.c",
    "src/attach.c",
    "src/auth.c",
    "src/build.c",
    "src/delete.c",
    "src/expr.c",
    "src/insert.c",
    "src/pragma.c",
    "src/pragma.h",
    "src/select.c",
    "src/trigger.c",
    "src/update.c",
    "src/vacuum.c",
    "src/walker.c",
    "src/where.c",
    "opcodes.c",
    "opcodes.h",
    "src/sqlcipher.h",
    "sqlite3.h",
    "ext/rbu/sqlite3rbu.c",
    "ext/rbu/sqlite3rbu.h",
    "ext/userauth/sqlite3userauth.h",
    "ext/misc/json1.c",
    "ext/icu/icu.c",
    "src/window.c",
    "ext/icu/sqliteicu.h",
    "src/global.c",
    "src/ctime.c",
    "src/hwtime.h",
    "src/date.c",
    "src/dbstat.c",
    "src/fault.c",
    "src/fkey.c",
    "src/sqliteInt.h",
    "src/upsert.c",
    "src/sqliteLimit.h",
    "src/sqlite3ext.h",
    "src/hash.c",
    "src/hash.h",
    "src/printf.c",
    "src/random.c",
    "src/utf.c",
    "src/util.c",
    "src/crypto_cc.c",
    "src/crypto_impl.c",
    "src/crypto_libtomcrypt.c",
    "src/crypto.c",
    "src/crypto.h",
    "src/vdbe.c",
    "src/vdbe.h",
    "src/vdbeaux.c",
    "src/vdbeblob.c",
    "src/vdbeInt.h",
    "src/vdbemem.c",
    "src/vdbesort.c",
    "src/vdbetrace.c",
    "src/msvc.h",
    "src/vxworks.h",
    "ext/fts3/fts3_tokenizer.h",
    "keywordhash.h"
  ]
  sqlcipher.watchos.deployment_target = "2.0"
  sqlcipher.tvos.deployment_target = "9.0"
  sqlcipher.osx.deployment_target = "10.13"
  sqlcipher.ios.deployment_target = "9.0"
  sqlcipher.frameworks = "Security", "Foundation"
  sqlcipher.requires_arc = false
  sqlcipher.pod_target_xcconfig = {
    "GCC_PREPROCESSOR_DEFINITIONS" => "NDEBUG=1 " +
                                      "_HAVE_SQLITE_CONFIG_H " +
                                      "SQLITE_DEFAULT_CACHE_SIZE=-2000 " +
                                      "SQLITE_DEFAULT_PAGE_SIZE=4096 " +
                                      "SQLITE_DEFAULT_MEMSTATUS=0 " +
                                      "SQLITE_DEFAULT_WAL_SYNCHRONOUS=1 " +
                                      "SQLITE_LIKE_DOESNT_MATCH_BLOBS=1 " +
                                      "SQLITE_DEFAULT_WAL_AUTOCHECKPOINT=0 " +
                                      "SQLITE_DEFAULT_LOCKING_MODE=0 " +
                                      "SQLITE_DEFAULT_SYNCHRONOUS=1 " +
                                      "SQLITE_DEFAULT_JOURNAL_SIZE_LIMIT=4194304 " +
                                      "SQLITE_MAX_SCHEMA_RETRY=999 " +
                                      "SQLITE_TEMP_STORE=2 " +
                                      "SQLITE_THREADSAFE=2 " +
                                      "SQLITE_ENABLE_API_ARMOR=1 " +
                                      "SQLITE_ENABLE_COLUMN_METADATA=1 " +
                                      "SQLITE_ENABLE_FTS3=1 " +
                                      "SQLITE_ENABLE_FTS3_PARENTHESIS=1 " +
                                      "SQLITE_ENABLE_FTS3_TOKENIZER=1 " +
                                      "SQLITE_ENABLE_FTS5=1 " +
                                      "SQLITE_ENABLE_LOCKING_STYLE=1 " +
                                      "SQLITE_USE_ALLOCA=1 " +
                                      "SQLITE_ENABLE_UPDATE_DELETE_LIMIT=1 " +
                                      "SQLITE_ENABLE_RTREE=1 " +
                                      "SQLITE_ENABLE_DBSTAT_VTAB=1 " +
                                      "SQLITE_ENABLE_BATCH_ATOMIC_WRITE=1 " +
                                      "SQLITE_MAX_EXPR_DEPTH=0 " +
                                      "SQLITE_MAX_ATTACHED=64 " +
                                      "SQLITE_OMIT_BUILTIN_TEST=1 " +
                                      "SQLITE_UNTESTABLE=1 " +
                                      "SQLITE_OMIT_COMPILEOPTION_DIAGS=1 " +
                                      "SQLITE_OMIT_DEPRECATED=1 " +
                                      "SQLITE_OMIT_SHARED_CACHE=1 " +
                                      "SQLITE_OMIT_LOAD_EXTENSION=1 " +
                                      "OMIT_MEMLOCK=1 " +
                                      "OMIT_MEM_SECURITY=1 " +
                                      "SQLITE_SYSTEM_MALLOC=1 " +
                                      "SQLITE_CORE=1 " +
                                      "SQLITE_HAS_CODEC=1 " +
                                      "SQLCIPHER_CRYPTO_CC=1 " +
                                      "USE_PREAD=1 " +
                                      "SQLCIPHER_PREPROCESSED=1 " +
                                      "SQLITE_MALLOC_SOFT_LIMIT=0 " +
                                      "SQLITE_PRINT_BUF_SIZE=256 " +
                                      "SQLITE_WCDB=1 " +
                                      "SQLITE_WCDB_CHECKPOINT_HANDLER=1 " +
                                      "SQLITE_WCDB_LOCK_HOOK=1 " +
                                      "SQLITE_WCDB_SUSPEND=1 " +
                                      "SQLITE_WCDB_IMPROVED_CHECKPOINT=1",
    "CLANG_WARN_CONSTANT_CONVERSION" => "YES",
    "GCC_WARN_64_TO_32_BIT_CONVERSION" => "NO",
    "CLANG_WARN_UNREACHABLE_CODE" => "NO",
    "GCC_WARN_UNUSED_FUNCTION" => "NO",
    "GCC_WARN_UNUSED_VARIABLE" => "NO",
    "CLANG_WARN_COMMA" => "NO",
    "CLANG_WARN_STRICT_PROTOTYPES" => "NO",
    "APPLICATION_EXTENSION_API_ONLY" => "YES",
  }
  sqlcipher.header_dir = "sqlcipher"
end
