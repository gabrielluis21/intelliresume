import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart'; // Importa o package printing

// Importação necessária para o pacote 'pdf' para o exemplo de simulação
// REMOVA ISSO em uma implementação real que converta DOCX de verdade.
import 'package:pdf/pdf.dart' as pw;
import 'package:pdf/widgets.dart' as pw;

/// Tela que apresenta uma pré-visualização em PDF de um documento,
/// assumindo que o DOCX original foi convertido para PDF.
///
/// Esta tela foca apenas nas funcionalidades de pré-visualização e impressão
/// fornecidas pelo pacote 'printing'.
class PreviewDocxScreen extends StatefulWidget {
  /// Os bytes do arquivo .docx original.
  /// (Para fins de demonstração, precisaremos convertê-los para PDF)
  final Uint8List docxBytes;

  /// O nome do arquivo que será sugerido (usado aqui apenas para feedback visual).
  final String fileName;

  const PreviewDocxScreen({
    super.key,
    required this.docxBytes, // Ainda recebemos os bytes do DOCX, mas para converter
    this.fileName = 'curriculo.docx',
  });

  @override
  State<PreviewDocxScreen> createState() => _PreviewDocxScreenState();
}

class _PreviewDocxScreenState extends State<PreviewDocxScreen> {
  Uint8List? _pdfBytes;
  bool _isLoadingPdf = true;
  String? _pdfError;

  @override
  void initState() {
    super.initState();
    _loadPdfForPreview();
  }

  Future<void> _loadPdfForPreview() async {
    setState(() {
      _isLoadingPdf = true;
      _pdfError = null;
    });
    try {
      // ATENÇÃO CRÍTICA:
      // Esta é uma função **PLACEHOLDER** que simula a conversão de DOCX para PDF.
      // O pacote 'printing' não faz essa conversão.
      // Em uma aplicação real, você DEVE implementar a conversão
      // de `widget.docxBytes` para `pdfBytes`. Isso geralmente requer:
      // 1. Um serviço de backend para converter DOCX para PDF (altamente recomendado).
      // 2. Ou uma biblioteca cliente-side robusta (praticamente inexistente para DOCX).

      // PARA DEMONSTRAÇÃO: Gerando um PDF simples com o pacote 'pdf' (não converte DOCX)
      final doc = pw.Document();
      doc.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Text(
                'Pré-visualização do Documento (Simulado) - ${widget.fileName}\n\n'
                'Conteúdo do DOCX não pode ser renderizado diretamente aqui.\n'
                'Esta é uma pré-visualização em PDF gerada.',
                textAlign: pw.TextAlign.center,
              ),
            );
          },
        ),
      );
      _pdfBytes = await doc.save();
      // FIM DO BLOCO DE DEMONSTRAÇÃO
    } catch (e) {
      _pdfError = 'Erro ao carregar pré-visualização do PDF: $e';
      debugPrint('Erro ao carregar PDF para pré-visualização: $e');
    } finally {
      setState(() {
        _isLoadingPdf = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pré-visualizar Documento'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          // Botão de impressão (somente se o PDF estiver disponível)
          if (_pdfBytes != null)
            IconButton(
              icon: const Icon(Icons.print),
              onPressed: () {
                Printing.layoutPdf(onLayout: (format) async => _pdfBytes!);
              },
            ),
        ],
      ),
      body:
          _isLoadingPdf
              ? const Center(child: CircularProgressIndicator())
              : _pdfError != null
              ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Erro ao carregar pré-visualização: $_pdfError\n'
                    'A pré-visualização de DOCX como PDF requer uma conversão externa.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              )
              : _pdfBytes != null
              ? PdfPreview(
                build: (format) => _pdfBytes!,
                allowSharing: true, // Permite compartilhar o PDF
                allowPrinting: true, // Permite imprimir o PDF
                canChangePageFormat: false,
                canDebug: false,
                // Para o nome do arquivo ao baixar/compartilhar o PDF
                pdfFileName: widget.fileName.replaceAll('.docx', '.pdf'),
              )
              : const Center(
                child: Text('Nenhuma pré-visualização de PDF disponível.'),
              ),
    );
  }
}
