//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <sqlite_handler/sqlite_handler_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) sqlite_handler_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "SqliteHandlerPlugin");
  sqlite_handler_plugin_register_with_registrar(sqlite_handler_registrar);
}
