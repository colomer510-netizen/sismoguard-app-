// ============================================================================
// SismoGuard — Dashboard Principal
// ============================================================================
// Pantalla principal de la aplicación que muestra el estado del sistema
// en tiempo real: nivel de amenaza, estado de comunicaciones, última
// actividad sísmica, y acciones rápidas.
// ============================================================================

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Dashboard principal de SismoGuard.
///
/// Muestra:
/// - Indicador de nivel de amenaza actual (gauge)
/// - Estado de todos los canales de comunicación
/// - Últimos eventos sísmicos detectados
/// - Panel de acciones rápidas (simulacro, mapa, configuración)
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // ─── Estado simulado (será reemplazado por BLoC) ───
  bool _isMonitoring = true;
  int _connectedPeers = 0;
  final List<String> _activeChannels = ['tcp_ip'];

  @override
  void initState() {
    super.initState();

    // Animación de pulso para el indicador de estado
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Header con logo y estado ──
            SliverToBoxAdapter(child: _buildHeader()),

            // ── Indicador de nivel de amenaza ──
            SliverToBoxAdapter(child: _buildThreatLevelGauge()),

            // ── Estado de comunicaciones ──
            SliverToBoxAdapter(child: _buildCommunicationsStatus()),

            // ── Estado del sistema ──
            SliverToBoxAdapter(child: _buildSystemStatusCard()),

            // ── Últimos eventos ──
            SliverToBoxAdapter(child: _buildRecentEventsSection()),

            // ── Panel de acciones rápidas ──
            SliverToBoxAdapter(child: _buildQuickActions()),

            // Espaciado inferior
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  HEADER
  // ═══════════════════════════════════════════════════════════

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          // Logo / Icono
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: AppColors.systemStatusGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.shield_rounded,
              color: AppColors.darkBackground,
              size: 26,
            ),
          ),
          const SizedBox(width: 12),

          // Título y subtítulo
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SismoGuard',
                  style: AppTypography.titleLarge.copyWith(
                    color: AppColors.darkTextPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Protección Sísmica Activa',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ),

          // Botón de configuración
          IconButton(
            onPressed: () {
              // TODO: Navegar a configuración
            },
            icon: const Icon(
              Icons.settings_rounded,
              color: AppColors.darkTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  INDICADOR DE NIVEL DE AMENAZA
  // ═══════════════════════════════════════════════════════════

  Widget _buildThreatLevelGauge() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.darkSurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.statusActive.withValues(
                alpha: _pulseAnimation.value * 0.5,
              ),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.statusActive.withValues(alpha: 0.1),
                blurRadius: 20 * _pulseAnimation.value,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              // Status icon con glow
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.statusActive.withValues(alpha: 0.1),
                  border: Border.all(
                    color: AppColors.statusActive.withValues(alpha: 0.5),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.statusActive,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),

              Text(
                'SIN AMENAZA DETECTADA',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.statusActive,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 4),

              Text(
                'Última verificación: ahora',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.darkTextTertiary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  ESTADO DE COMUNICACIONES
  // ═══════════════════════════════════════════════════════════

  Widget _buildCommunicationsStatus() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.cell_tower_rounded,
                  color: AppColors.accent, size: 20),
              const SizedBox(width: 8),
              Text(
                'Canales de Comunicación',
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.darkTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Grid de canales
          Row(
            children: [
              _buildChannelBadge(
                icon: Icons.wifi_rounded,
                label: 'Internet',
                color: AppColors.commInternet,
                isActive: true,
              ),
              const SizedBox(width: 8),
              _buildChannelBadge(
                icon: Icons.bluetooth_rounded,
                label: 'BLE Mesh',
                color: AppColors.commBluetooth,
                isActive: false,
              ),
              const SizedBox(width: 8),
              _buildChannelBadge(
                icon: Icons.radio_rounded,
                label: 'LoRa',
                color: AppColors.commLoRa,
                isActive: false,
              ),
              const SizedBox(width: 8),
              _buildChannelBadge(
                icon: Icons.sms_rounded,
                label: 'SMS',
                color: AppColors.commSms,
                isActive: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChannelBadge({
    required IconData icon,
    required String label,
    required Color color,
    required bool isActive,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? color.withValues(alpha: 0.12)
              : AppColors.darkSurfaceElevated,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive ? color.withValues(alpha: 0.4) : AppColors.darkBorder,
          ),
        ),
        child: Column(
          children: [
            Icon(icon,
                size: 20,
                color: isActive ? color : AppColors.darkTextTertiary),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: isActive ? color : AppColors.darkTextTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  ESTADO DEL SISTEMA
  // ═══════════════════════════════════════════════════════════

  Widget _buildSystemStatusCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.monitor_heart_rounded,
                  color: AppColors.accent, size: 20),
              const SizedBox(width: 8),
              Text(
                'Estado del Sistema',
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.darkTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          _buildStatusRow(
            'Detección Sísmica',
            _isMonitoring ? 'Activa — 50Hz' : 'Inactiva',
            _isMonitoring ? AppColors.statusActive : AppColors.statusError,
          ),
          const SizedBox(height: 8),
          _buildStatusRow(
            'Algoritmo STA/LTA',
            'En ejecución',
            AppColors.statusActive,
          ),
          const SizedBox(height: 8),
          _buildStatusRow(
            'Modelo CNN',
            'Pendiente de modelo',
            AppColors.statusWarning,
          ),
          const SizedBox(height: 8),
          _buildStatusRow(
            'Mapas Offline',
            'No descargados',
            AppColors.statusInactive,
          ),
          const SizedBox(height: 8),
          _buildStatusRow(
            'Peers Mesh',
            '$_connectedPeers conectados',
            _connectedPeers > 0
                ? AppColors.statusActive
                : AppColors.statusInactive,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String value, Color statusColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: statusColor,
                boxShadow: [
                  BoxShadow(
                    color: statusColor.withValues(alpha: 0.5),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.darkTextSecondary,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: AppTypography.labelSmall.copyWith(
            color: statusColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  EVENTOS RECIENTES
  // ═══════════════════════════════════════════════════════════

  Widget _buildRecentEventsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.history_rounded,
                  color: AppColors.accent, size: 20),
              const SizedBox(width: 8),
              Text(
                'Actividad Reciente',
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.darkTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Estado vacío
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.landscape_rounded,
                  size: 48,
                  color: AppColors.darkTextTertiary.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sin actividad sísmica reciente',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.darkTextTertiary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'El sistema está monitorizando continuamente',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.darkTextTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  ACCIONES RÁPIDAS
  // ═══════════════════════════════════════════════════════════

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Acciones Rápidas',
            style: AppTypography.titleSmall.copyWith(
              color: AppColors.darkTextPrimary,
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              _buildActionButton(
                icon: Icons.map_rounded,
                label: 'Mapa\nOffline',
                color: AppColors.accent,
                onTap: () {
                  // TODO: Navegar a mapa offline
                },
              ),
              const SizedBox(width: 12),
              _buildActionButton(
                icon: Icons.campaign_rounded,
                label: 'Iniciar\nSimulacro',
                color: AppColors.drillModeBorder,
                onTap: () {
                  // TODO: Iniciar simulacro
                },
              ),
              const SizedBox(width: 12),
              _buildActionButton(
                icon: Icons.bluetooth_searching_rounded,
                label: 'Activar\nMesh',
                color: AppColors.commBluetooth,
                onTap: () {
                  // TODO: Activar red BLE Mesh
                },
              ),
              const SizedBox(width: 12),
              _buildActionButton(
                icon: Icons.info_outline_rounded,
                label: 'Acerca\nde',
                color: AppColors.darkTextSecondary,
                onTap: () {
                  // TODO: Mostrar información
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: color.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: [
              Icon(icon, size: 28, color: color),
              const SizedBox(height: 8),
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
