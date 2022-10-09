#include "include/sqlite_handler/sqlite_handler_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "sqlite_handler_plugin.h"

void SqliteHandlerPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  sqlite_handler::SqliteHandlerPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
