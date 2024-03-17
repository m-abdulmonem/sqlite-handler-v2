//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import file_encryptor
import path_provider_macos
import sqflite
import sqlite_handler

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  FileEncryptorPlugin.register(with: registry.registrar(forPlugin: "FileEncryptorPlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  SqflitePlugin.register(with: registry.registrar(forPlugin: "SqflitePlugin"))
  SqliteHandlerPlugin.register(with: registry.registrar(forPlugin: "SqliteHandlerPlugin"))
}
