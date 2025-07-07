import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chat_bloc.dart';
import '../models/message.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Configuración'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Sección de Tema
              _buildSectionCard(
                context,
                state.isDark,
                'Apariencia',
                Icons.palette,
                [
                  _buildThemeToggle(context, state.isDark),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Sección de Información de la App
              _buildSectionCard(
                context,
                state.isDark,
                'Información de la Aplicación',
                Icons.info,
                [
                  _buildInfoTile(
                    'Nombre',
                    'ChatBot IA',
                    Icons.chat_bubble,
                    state.isDark,
                  ),
                  _buildInfoTile(
                    'Versión',
                    '1.0.0',
                    Icons.tag,
                    state.isDark,
                  ),
                  _buildInfoTile(
                    'Modelo de IA',
                    'Mistral 7B Instruct',
                    Icons.psychology,
                    state.isDark,
                  ),
                  _buildInfoTile(
                    'Desarrollado en',
                    'Flutter',
                    Icons.flutter_dash,
                    state.isDark,
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Sección del Creador
              _buildSectionCard(
                context,
                state.isDark,
                'Creador',
                Icons.person,
                [
                  _buildCreatorCard(state.isDark),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Sección de Características
              _buildSectionCard(
                context,
                state.isDark,
                'Características',
                Icons.star,
                [
                  _buildFeatureTile(
                    'Chat Inteligente',
                    'Conversaciones naturales con IA',
                    Icons.chat,
                    state.isDark,
                  ),
                  _buildFeatureTile(
                    'Timestamps Automáticos',
                    'Actualización en tiempo real',
                    Icons.access_time,
                    state.isDark,
                  ),
                  _buildFeatureTile(
                    'Tema Oscuro/Claro',
                    'Interfaz adaptable',
                    Icons.brightness_6,
                    state.isDark,
                  ),
                  _buildFeatureTile(
                    'Diseño Moderno',
                    'Interfaz intuitiva y atractiva',
                    Icons.design_services,
                    state.isDark,
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Sección de Estadísticas
              _buildSectionCard(
                context,
                state.isDark,
                'Estadísticas',
                Icons.analytics,
                [
                  _buildStatTile(
                    'Mensajes en esta sesión',
                    '${state.messages.length}',
                    Icons.message,
                    state.isDark,
                  ),
                  _buildStatTile(
                    'Última actualización',
                    _getLastUpdateTime(state.messages),
                    Icons.update,
                    state.isDark,
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              Center(
                child: Text(
                  '© 2025 ChatBot IA',
                  style: TextStyle(
                    color: state.isDark ? Colors.white30 : Colors.black38,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionCard(BuildContext context, bool isDark, String title, IconData icon, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6C63FF), Color(0xFF5A52FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildThemeToggle(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                color: isDark ? Colors.white : Colors.black,
              ),
              const SizedBox(width: 12),
              Text(
                'Tema oscuro',
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          Switch(
            value: isDark,
            onChanged: (value) {
              context.read<ChatBloc>().add(ToggleTheme());
            },
            activeColor: const Color(0xFF6C63FF),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String title, String value, IconData icon, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: isDark ? Colors.white70 : Colors.black54, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreatorCard(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF5A52FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Luis Mendoza',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Desarrollador',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.code,
                      color: Colors.white70,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Junior',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureTile(String title, String description, IconData icon, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (isDark ? Colors.white : const Color(0xFF6C63FF)).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: isDark ? Colors.white : const Color(0xFF6C63FF),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatTile(String title, String value, IconData icon, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: isDark ? Colors.white70 : Colors.black54, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getLastUpdateTime(List<Message> messages) {
    if (messages.isEmpty) return 'Sin mensajes';
    
    final lastMessage = messages.last;
    final now = DateTime.now();
    final difference = now.difference(lastMessage.timestamp);
    
    if (difference.inDays > 0) {
      return 'hace ${difference.inDays} día${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return 'hace ${difference.inHours} hora${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inMinutes > 0) {
      return 'hace ${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'ahora mismo';
    }
  }
}
