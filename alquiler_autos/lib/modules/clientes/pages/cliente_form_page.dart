import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../models/cliente_model.dart';
import '../providers/cliente_provider.dart';

enum ClienteFormResult { creado, actualizado }

class ClienteFormPage extends StatefulWidget {
  static const String route = '/clientes/form';

  final Cliente? cliente;

  const ClienteFormPage({super.key, this.cliente});

  @override
  State<ClienteFormPage> createState() => _ClienteFormPageState();
}

class _ClienteFormPageState extends State<ClienteFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _documentoController = TextEditingController();

  bool _esEdicion = false;
  late int _clienteId;

  @override
  void initState() {
    super.initState();
    _cargarClienteInicial();
  }

  void _cargarClienteInicial() {
    final cliente = widget.cliente;
    if (cliente != null) {
      _esEdicion = true;
      _clienteId = cliente.idCliente;
      _nombreController.text = cliente.nombre;
      _apellidoController.text = cliente.apellido;
      _documentoController.text = cliente.numeroDocumento;
    } else {
      _clienteId = 0;
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _documentoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_esEdicion ? 'Editar Cliente' : 'Nuevo Cliente'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_esEdicion)
                Card(
                  color: AppColors.info.withValues(alpha: 20),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: AppColors.info),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Actualizando datos del cliente #$_clienteId',
                            style: TextStyles.bodyMedium.copyWith(
                              color: AppColors.info,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (_esEdicion) const SizedBox(height: 16),

              CustomTextField(
                labelText: 'Nombre',
                hintText: 'Ingrese el nombre',
                controller: _nombreController,
                prefixIcon: const Icon(Icons.person_outline),
                textCapitalization: TextCapitalization.words,
                validator: _validarNombre,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                labelText: 'Apellido',
                hintText: 'Ingrese el apellido',
                controller: _apellidoController,
                prefixIcon: const Icon(Icons.perm_identity),
                textCapitalization: TextCapitalization.words,
                validator: _validarApellido,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                labelText: 'Número de documento',
                hintText: 'Solo números',
                controller: _documentoController,
                prefixIcon: const Icon(Icons.badge_outlined),
                keyboardType: TextInputType.number,
                validator: _validarDocumento,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 8),
              _buildDocumentoHint(),
              const SizedBox(height: 24),

              CustomButton(
                text: _esEdicion ? 'Actualizar' : 'Guardar',
                onPressed: _guardarCliente,
                isFullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentoHint() {
    final documento = _documentoController.text;
    final esValido = RegExp(r'^\d{6,}$').hasMatch(documento);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
    color: esValido
      ? AppColors.success.withValues(alpha: 20)
      : AppColors.warning.withValues(alpha: 20),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: esValido
              ? AppColors.success.withValues(alpha: 77)
              : AppColors.warning.withValues(alpha: 77),
        ),
      ),
      child: Row(
        children: [
          Icon(
            esValido ? Icons.check_circle : Icons.info_outline,
            color: esValido ? AppColors.success : AppColors.warning,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              esValido
                  ? 'El número parece correcto.'
                  : 'Debe contener al menos 6 dígitos y no incluir letras.',
              style: TextStyles.bodySmall.copyWith(
                color: esValido ? AppColors.success : AppColors.warning,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _validarNombre(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingrese el nombre';
    }
    if (value.trim().length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }
    return null;
  }

  String? _validarApellido(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingrese el apellido';
    }
    if (value.trim().length < 2) {
      return 'El apellido debe tener al menos 2 caracteres';
    }
    return null;
  }

  String? _validarDocumento(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingrese el documento';
    }
    final documento = value.trim();
    if (!RegExp(r'^\d{6,}$').hasMatch(documento)) {
      return 'El documento debe contener solo números (mínimo 6)';
    }

    final provider = context.read<ClienteProvider>();
    final existe = provider.documentoExiste(
      documento,
      excluirId: _esEdicion ? _clienteId : null,
    );
    if (existe) {
      return 'Este documento ya se encuentra registrado';
    }
    return null;
  }

  void _guardarCliente() {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    final provider = context.read<ClienteProvider>();

    final cliente = Cliente(
      idCliente: _esEdicion ? _clienteId : provider.generarId(),
      nombre: _nombreController.text.trim(),
      apellido: _apellidoController.text.trim(),
      numeroDocumento: _documentoController.text.trim(),
    );

    if (_esEdicion) {
      provider.actualizar(cliente);
      Navigator.of(context).pop(ClienteFormResult.actualizado);
    } else {
      provider.agregar(cliente);
      Navigator.of(context).pop(ClienteFormResult.creado);
    }
  }
}