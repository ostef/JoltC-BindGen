#pragma once

#include <Core.hpp>
#include <Database.hpp>

struct ParseOptions {
    Array<String> include_dirs;
    Array<String> defines;
    Array<String> files;
    Array<String> extra_options;
};

void ParseFiles(const ParseOptions &options, Database &db);
