// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'DēGlitch';

  @override
  String get home => '首页';

  @override
  String get servers => '服务器';

  @override
  String get diagnostics => '诊断';

  @override
  String get profile => '个人资料';

  @override
  String get more => '更多';

  @override
  String get connected => '已连接';

  @override
  String get disconnected => '未连接';

  @override
  String get connecting => '正在连接';

  @override
  String get connectionError => '连接错误';

  @override
  String get received => '已接收';

  @override
  String get sent => '已发送';

  @override
  String get lastHandshake => '最近握手时间';

  @override
  String get quickAccess => '快捷入口';

  @override
  String get serverRecommendation => '服务器推荐';

  @override
  String get serverRecommendationDescription => '根据您的连接情况提供 AI 辅助服务器建议';

  @override
  String get runDiagnostics => '运行诊断';

  @override
  String get diagnosticsDescription => '检查连接健康状况';

  @override
  String get viewConnectionHistory => '查看连接历史';

  @override
  String get pastConnections => '查看之前的连接';

  @override
  String get profileAndSettings => '个人资料与设置';

  @override
  String get accountInformation => '账户信息';

  @override
  String get language => '语言';

  @override
  String get activityPreferences => '活动偏好';

  @override
  String get networkProfiles => '网络配置文件';

  @override
  String get securityAndPrivacy => '安全与隐私';

  @override
  String get helpAndSupport => '帮助与支持';

  @override
  String get aboutDeGlitch => '关于 DēGlitch';

  @override
  String get logOut => '退出登录';

  @override
  String get logOutQuestion => '要退出登录吗？';

  @override
  String get logoutPrompt => '确定要退出 DēGlitch 吗？';

  @override
  String get cancel => '取消';

  @override
  String get chooseLanguage => '选择语言';

  @override
  String get languageSaved => '语言偏好已保存。';

  @override
  String get languageChangeNotConfigured => '语言切换尚未连接到整个应用。请在应用根部接入语言控制器。';

  @override
  String get premium => '高级版';

  @override
  String get yourConnectivityToolkit => '您的连接工具箱';

  @override
  String get manageToolsDescription => '管理工具、连接行为和支持服务。';

  @override
  String get quickTools => '快捷工具';

  @override
  String get recommend => '推荐';

  @override
  String get findBetterRoute => '寻找更合适的线路';

  @override
  String get history => '历史记录';

  @override
  String get connectionPreferences => '连接偏好';

  @override
  String get autoConnect => '自动连接';

  @override
  String get autoConnectDescription => '应用启用此功能后自动连接';

  @override
  String get liteMode => '轻量模式';

  @override
  String get liteModeDescription => '减少非必要的后台活动';

  @override
  String get dataSaver => '流量节省';

  @override
  String get dataSaverDescription => '限制可选的后台数据使用';

  @override
  String get moreOptions => '更多选项';

  @override
  String get manageSavedConnectionPreferences => '管理已保存的连接偏好';

  @override
  String get splitTunneling => '分流隧道';

  @override
  String get splitTunnelingDescription => '选择哪些应用使用 VPN';

  @override
  String get soon => '即将推出';

  @override
  String get reviewPermissionsAndDataControls => '查看权限和数据控制';

  @override
  String get aiAssistant => 'AI 助手';

  @override
  String get aiAssistantDescription => '帮助您了解当前连接';

  @override
  String get networkBoost => '网络优化';

  @override
  String get networkBoostDescription => '检查可用的网络指标并应用受支持的优化。';

  @override
  String get networkBoostDisclaimer => '效果取决于网络、设备、端点和服务提供商。不保证固定幅度的网速提升。';

  @override
  String get askAssistant => '咨询 DēGlitch';

  @override
  String get send => '发送';

  @override
  String get assistantGreeting => '您好！我可以帮助您了解连接状态、诊断结果、服务器选择、轻量模式和受支持的设置。';

  @override
  String get assistantUnavailable => '助手服务尚未连接。您仍可使用应用中可用的设置。';

  @override
  String get connectionStatus => '连接状态';

  @override
  String get connectedFor => '已连接时长';

  @override
  String get connectionHealth => '连接健康状况';

  @override
  String get speed => '速度';

  @override
  String get stability => '稳定性';

  @override
  String get security => '安全';

  @override
  String get high => '高';

  @override
  String get stable => '稳定';

  @override
  String get protected => '已保护';

  @override
  String get aiRecommended => 'AI 推荐';

  @override
  String get allServers => '全部服务器';

  @override
  String get favorites => '收藏';

  @override
  String get recommended => '推荐';

  @override
  String get lowestMeasuredLatency => '实测延迟最低';

  @override
  String get latency => '延迟';

  @override
  String get packetLoss => '丢包率';

  @override
  String get healthScore => '健康评分';

  @override
  String get otherAvailableServers => '其他可用服务器';

  @override
  String get bestChoice => '最佳选择';

  @override
  String connectToServer(String serverName) {
    return '连接到 $serverName';
  }

  @override
  String get diagnosticsComplete => '诊断完成';

  @override
  String get checksHaveResults => '所有已完成的检查均有结果';

  @override
  String get internetConnection => '互联网连接';

  @override
  String get dns => 'DNS';

  @override
  String get packetLossTest => '丢包测试';

  @override
  String get latencyTest => '延迟测试';

  @override
  String get jitterTest => '抖动测试';

  @override
  String get serverLoad => '服务器负载';

  @override
  String get vpnEndpoint => 'VPN 端点';

  @override
  String get unavailable => '不可用';

  @override
  String get passed => '通过';

  @override
  String get runAgain => '重新运行';

  @override
  String get serverTelemetryUnavailable => '尚未连接服务器遥测数据。';

  @override
  String get tunnelStatusUnavailable => '实时隧道状态尚未接入诊断。';

  @override
  String get enabled => '已启用';

  @override
  String get disabled => '已禁用';

  @override
  String get aiResponseDisclaimer => '我可以解释现有指标并建议可执行的检查，但不能保证具体的提速幅度。';

  @override
  String get networkBoostStatus => '网络优化状态';

  @override
  String get noData => '暂无数据';

  @override
  String get clearHistory => '清除历史记录';

  @override
  String get clear => '清除';

  @override
  String get save => '保存';

  @override
  String get close => '关闭';

  @override
  String get permissionDenied => '权限被拒绝';

  @override
  String get retry => '重试';

  @override
  String get errorTryAgain => '发生错误，请重试。';

  @override
  String get noServers => '目前没有可用的服务器。';

  @override
  String get profileImported => '配置文件已导入';

  @override
  String get importSelectProfile => '导入/选择本地配置文件';

  @override
  String get activityGaming => '游戏';

  @override
  String get activityStreaming => '流媒体';

  @override
  String get activityStudy => '学习';

  @override
  String get activityWork => '工作';

  @override
  String get privacyControls => '隐私控制';

  @override
  String get notifications => '通知';

  @override
  String get languageRestartNote => '所选语言将应用于整个应用，并保存在此设备上。';

  @override
  String get aboutTagline => '更智能的连接，更好的前进方式。';

  @override
  String get serverDetails => '服务器详情';

  @override
  String get reconnect => '重新连接';

  @override
  String get disconnect => '断开连接';

  @override
  String get connect => '连接';
}

/// The translations for Chinese, using the Han script (`zh_Hans`).
class AppLocalizationsZhHans extends AppLocalizationsZh {
  AppLocalizationsZhHans() : super('zh_Hans');

  @override
  String get appTitle => 'DēGlitch';

  @override
  String get home => '首页';

  @override
  String get servers => '服务器';

  @override
  String get diagnostics => '诊断';

  @override
  String get profile => '个人资料';

  @override
  String get more => '更多';

  @override
  String get connected => '已连接';

  @override
  String get disconnected => '未连接';

  @override
  String get connecting => '正在连接';

  @override
  String get connectionError => '连接错误';

  @override
  String get received => '已接收';

  @override
  String get sent => '已发送';

  @override
  String get lastHandshake => '最近握手时间';

  @override
  String get quickAccess => '快捷入口';

  @override
  String get serverRecommendation => '服务器推荐';

  @override
  String get serverRecommendationDescription => '根据您的连接情况提供 AI 辅助服务器建议';

  @override
  String get runDiagnostics => '运行诊断';

  @override
  String get diagnosticsDescription => '检查连接健康状况';

  @override
  String get viewConnectionHistory => '查看连接历史';

  @override
  String get pastConnections => '查看之前的连接';

  @override
  String get profileAndSettings => '个人资料与设置';

  @override
  String get accountInformation => '账户信息';

  @override
  String get language => '语言';

  @override
  String get activityPreferences => '活动偏好';

  @override
  String get networkProfiles => '网络配置文件';

  @override
  String get securityAndPrivacy => '安全与隐私';

  @override
  String get helpAndSupport => '帮助与支持';

  @override
  String get aboutDeGlitch => '关于 DēGlitch';

  @override
  String get logOut => '退出登录';

  @override
  String get logOutQuestion => '要退出登录吗？';

  @override
  String get logoutPrompt => '确定要退出 DēGlitch 吗？';

  @override
  String get cancel => '取消';

  @override
  String get chooseLanguage => '选择语言';

  @override
  String get languageSaved => '语言偏好已保存。';

  @override
  String get languageChangeNotConfigured => '语言切换尚未连接到整个应用。请在应用根部接入语言控制器。';

  @override
  String get premium => '高级版';

  @override
  String get yourConnectivityToolkit => '您的连接工具箱';

  @override
  String get manageToolsDescription => '管理工具、连接行为和支持服务。';

  @override
  String get quickTools => '快捷工具';

  @override
  String get recommend => '推荐';

  @override
  String get findBetterRoute => '寻找更合适的线路';

  @override
  String get history => '历史记录';

  @override
  String get connectionPreferences => '连接偏好';

  @override
  String get autoConnect => '自动连接';

  @override
  String get autoConnectDescription => '应用启用此功能后自动连接';

  @override
  String get liteMode => '轻量模式';

  @override
  String get liteModeDescription => '减少非必要的后台活动';

  @override
  String get dataSaver => '流量节省';

  @override
  String get dataSaverDescription => '限制可选的后台数据使用';

  @override
  String get moreOptions => '更多选项';

  @override
  String get manageSavedConnectionPreferences => '管理已保存的连接偏好';

  @override
  String get splitTunneling => '分流隧道';

  @override
  String get splitTunnelingDescription => '选择哪些应用使用 VPN';

  @override
  String get soon => '即将推出';

  @override
  String get reviewPermissionsAndDataControls => '查看权限和数据控制';

  @override
  String get aiAssistant => 'AI 助手';

  @override
  String get aiAssistantDescription => '帮助您了解当前连接';

  @override
  String get networkBoost => '网络优化';

  @override
  String get networkBoostDescription => '检查可用的网络指标并应用受支持的优化。';

  @override
  String get networkBoostDisclaimer => '效果取决于网络、设备、端点和服务提供商。不保证固定幅度的网速提升。';

  @override
  String get askAssistant => '咨询 DēGlitch';

  @override
  String get send => '发送';

  @override
  String get assistantGreeting => '您好！我可以帮助您了解连接状态、诊断结果、服务器选择、轻量模式和受支持的设置。';

  @override
  String get assistantUnavailable => '助手服务尚未连接。您仍可使用应用中可用的设置。';

  @override
  String get connectionStatus => '连接状态';

  @override
  String get connectedFor => '已连接时长';

  @override
  String get connectionHealth => '连接健康状况';

  @override
  String get speed => '速度';

  @override
  String get stability => '稳定性';

  @override
  String get security => '安全';

  @override
  String get high => '高';

  @override
  String get stable => '稳定';

  @override
  String get protected => '已保护';

  @override
  String get aiRecommended => 'AI 推荐';

  @override
  String get allServers => '全部服务器';

  @override
  String get favorites => '收藏';

  @override
  String get recommended => '推荐';

  @override
  String get lowestMeasuredLatency => '实测延迟最低';

  @override
  String get latency => '延迟';

  @override
  String get packetLoss => '丢包率';

  @override
  String get healthScore => '健康评分';

  @override
  String get otherAvailableServers => '其他可用服务器';

  @override
  String get bestChoice => '最佳选择';

  @override
  String connectToServer(String serverName) {
    return '连接到 $serverName';
  }

  @override
  String get diagnosticsComplete => '诊断完成';

  @override
  String get checksHaveResults => '所有已完成的检查均有结果';

  @override
  String get internetConnection => '互联网连接';

  @override
  String get dns => 'DNS';

  @override
  String get packetLossTest => '丢包测试';

  @override
  String get latencyTest => '延迟测试';

  @override
  String get jitterTest => '抖动测试';

  @override
  String get serverLoad => '服务器负载';

  @override
  String get vpnEndpoint => 'VPN 端点';

  @override
  String get unavailable => '不可用';

  @override
  String get passed => '通过';

  @override
  String get runAgain => '重新运行';

  @override
  String get serverTelemetryUnavailable => '尚未连接服务器遥测数据。';

  @override
  String get tunnelStatusUnavailable => '实时隧道状态尚未接入诊断。';

  @override
  String get enabled => '已启用';

  @override
  String get disabled => '已禁用';

  @override
  String get aiResponseDisclaimer => '我可以解释现有指标并建议可执行的检查，但不能保证具体的提速幅度。';

  @override
  String get networkBoostStatus => '网络优化状态';

  @override
  String get noData => '暂无数据';

  @override
  String get clearHistory => '清除历史记录';

  @override
  String get clear => '清除';

  @override
  String get save => '保存';

  @override
  String get close => '关闭';

  @override
  String get permissionDenied => '权限被拒绝';

  @override
  String get retry => '重试';

  @override
  String get errorTryAgain => '发生错误，请重试。';

  @override
  String get noServers => '目前没有可用的服务器。';

  @override
  String get profileImported => '配置文件已导入';

  @override
  String get importSelectProfile => '导入/选择本地配置文件';

  @override
  String get activityGaming => '游戏';

  @override
  String get activityStreaming => '流媒体';

  @override
  String get activityStudy => '学习';

  @override
  String get activityWork => '工作';

  @override
  String get privacyControls => '隐私控制';

  @override
  String get notifications => '通知';

  @override
  String get languageRestartNote => '所选语言将应用于整个应用，并保存在此设备上。';

  @override
  String get aboutTagline => '更智能的连接，更好的前进方式。';

  @override
  String get serverDetails => '服务器详情';

  @override
  String get reconnect => '重新连接';

  @override
  String get disconnect => '断开连接';

  @override
  String get connect => '连接';
}
