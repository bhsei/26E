import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_wireguard/flutter_wireguard.dart' as wg;

/// Secure configuration storage and tunnel lifecycle for the DēGlitch prototype.
///
/// The configuration is kept in platform secure storage; it must never be logged,
/// embedded in source code, or committed to version control.
class WireGuardService {
  WireGuardService({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const String tunnelName = 'deglitch';
  static const String _configKey = 'deglitch.wireguard.config.v1';
  static const String _labelKey = 'deglitch.wireguard.label.v1';
  static const int _maxConfigBytes = 100 * 1024;

  final FlutterSecureStorage _storage;

  Stream<wg.TunnelStatus> get statusStream => wg.statusStream();

  Future<bool> hasConfig() async {
    final config = await _storage.read(key: _configKey);
    return config != null && config.trim().isNotEmpty;
  }

  Future<String?> getServerLabel() async {
    return _storage.read(key: _labelKey);
  }

  /// Lets the user pick a local .conf file. Returns its display label, or null
  /// if the picker is cancelled. The file contents are never printed or logged.
  Future<String?> importConfig() async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: const ['conf'],
    );

    if (file == null) return null;

    final bytes = await file.readAsBytes();
    if (bytes.isEmpty) {
      throw StateError('The selected configuration could not be read.');
    }
    if (bytes.length > _maxConfigBytes) {
      throw const FormatException('The configuration file is too large.');
    }

    final String config;
    try {
      config = utf8.decode(bytes).trim();
    } on FormatException {
      throw const FormatException('The configuration is not valid UTF-8 text.');
    }

    _validateConfig(config);
    final label = _extractServerLabel(config) ?? _safeFileLabel(file.name);

    await _storage.write(key: _configKey, value: config);
    await _storage.write(key: _labelKey, value: label);
    return label;
  }

  void _validateConfig(String config) {
    bool has(RegExp pattern) => pattern.hasMatch(config);

    final valid =
        has(
          RegExp(
            r'^\s*\[Interface\]\s*$',
            multiLine: true,
            caseSensitive: false,
          ),
        ) &&
        has(
          RegExp(r'^\s*\[Peer\]\s*$', multiLine: true, caseSensitive: false),
        ) &&
        has(
          RegExp(
            r'^\s*PrivateKey\s*=\s*\S+',
            multiLine: true,
            caseSensitive: false,
          ),
        ) &&
        has(
          RegExp(
            r'^\s*Address\s*=\s*\S+',
            multiLine: true,
            caseSensitive: false,
          ),
        ) &&
        has(
          RegExp(
            r'^\s*PublicKey\s*=\s*\S+',
            multiLine: true,
            caseSensitive: false,
          ),
        ) &&
        has(
          RegExp(
            r'^\s*Endpoint\s*=\s*\S+',
            multiLine: true,
            caseSensitive: false,
          ),
        ) &&
        has(
          RegExp(
            r'^\s*AllowedIPs\s*=\s*\S+',
            multiLine: true,
            caseSensitive: false,
          ),
        );

    if (!valid) {
      throw const FormatException(
        'Not a valid WireGuard configuration. Choose a .conf file with Interface and Peer sections.',
      );
    }
  }

  String? _extractServerLabel(String config) {
    final peerStart = config.indexOf('[Peer]');
    if (peerStart < 0) return null;
    final peerSection = config.substring(peerStart);
    final match = RegExp(
      r'^\s*#\s*([A-Z]{2}-[A-Z0-9#-]+)\s*$',
      multiLine: true,
    ).firstMatch(peerSection);
    if (match != null) return match.group(1);

    final endpoint = RegExp(
      r'^\s*Endpoint\s*=\s*(.+)$',
      multiLine: true,
    ).firstMatch(peerSection)?.group(1)?.trim();
    if (endpoint == null || endpoint.isEmpty) return null;
    return endpoint;
  }

  String _safeFileLabel(String name) {
    final base = name.replaceAll(RegExp(r'\.conf$', caseSensitive: false), '');
    return base.isEmpty ? 'Imported WireGuard profile' : base;
  }

  Future<void> connect() async {
    final config = await _storage.read(key: _configKey);
    if (config == null || config.isEmpty) {
      throw StateError('Import a WireGuard configuration first.');
    }
    // The plugin requests Android's VPN permission when needed.
    await wg.start(tunnelName, config);
  }

  Future<void> disconnect() => wg.stop(tunnelName);

  Future<wg.TunnelStatus?> getStatus() async {
    try {
      return await wg.status(tunnelName);
    } catch (_) {
      // No tunnel may exist yet; do not treat this as connected.
      return null;
    }
  }

  Future<void> removeConfig() async {
    await _storage.delete(key: _configKey);
    await _storage.delete(key: _labelKey);
  }
}
