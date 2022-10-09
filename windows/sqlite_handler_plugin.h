#ifndef FLUTTER_PLUGIN_SQLITE_HANDLER_PLUGIN_H_
#define FLUTTER_PLUGIN_SQLITE_HANDLER_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace sqlite_handler {

class SqliteHandlerPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  SqliteHandlerPlugin();

  virtual ~SqliteHandlerPlugin();

  // Disallow copy and assign.
  SqliteHandlerPlugin(const SqliteHandlerPlugin&) = delete;
  SqliteHandlerPlugin& operator=(const SqliteHandlerPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace sqlite_handler

#endif  // FLUTTER_PLUGIN_SQLITE_HANDLER_PLUGIN_H_
