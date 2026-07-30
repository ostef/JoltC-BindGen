#pragma once

#include <Core.hpp>
#include <Database.hpp>

struct JaiGenerateOptions {
    Array<String> strip_prefixes;
    Array<String> strip_declarations;
};

void AppendJaiCode(const JaiGenerateOptions &options, const Database &db, StringBuilder &builder);
