//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <file_encryptor/file_encryptor_plugin_c_api.h>
#include <sqlite_handler/sqlite_handler_plugin_c_api.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  FileEncryptorPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FileEncryptorPluginCApi"));
  SqliteHandlerPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SqliteHandlerPluginCApi"));
}
