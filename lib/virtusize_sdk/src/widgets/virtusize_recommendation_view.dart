import 'package:flutter/material.dart';
import '../recommendation.dart';
import '../recommendation_calculator.dart';
import '../size_category.dart';

// UI/UX 

class VirtusizeRecommendationView extends StatefulWidget {
  const VirtusizeRecommendationView({
    super.key,
    this.calculator = const VirtusizeCalculator(),
  });

  final VirtusizeCalculator calculator;

  @override
  State<VirtusizeRecommendationView> createState() =>
      _VirtusizeRecommendationViewState();
}

class _VirtusizeRecommendationViewState
    extends State<VirtusizeRecommendationView> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  VirtusizeRecommendation? _result;
  String? _error;

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child:
                  _result == null
                      ? _buildForm(context)
                      : _buildResult(context, _result!),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return KeyedSubtree(
      key: const ValueKey('form'),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Find Your Perfect Fit',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _heightController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Height (cm)',
                border: OutlineInputBorder(),
              ),
              validator: _validatePositiveNumber,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _weightController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Weight (kg)',
                border: OutlineInputBorder(),
              ),
              validator: _validatePositiveNumber,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _onSubmit,
              child: const Text('Get Size Recommendation here:'),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResult(BuildContext context, VirtusizeRecommendation result) {
    final size = result.size;
    return Column(
      key: const ValueKey('result'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Your Recommended Size: ${size.label}',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'BMI: ${result.bmiLabel}',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          result.message,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          size.description,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        OutlinedButton(onPressed: _reset, child: const Text('OK')),
      ],
    );
  }

  String? _validatePositiveNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a value';
    }
    final parsed = double.tryParse(value);
    if (parsed == null || parsed <= 0) {
      return 'Enter a number greater than zero';
    }
    return null;
  }

  void _onSubmit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    final height = double.parse(_heightController.text);
    final weight = double.parse(_weightController.text);

    setState(() {
      try {
        _result = widget.calculator.recommend(
          heightCm: height,
          weightKg: weight,
        );
        _error = null;
      } on ArgumentError catch (err) {
        _error = err.message?.toString();
      } catch (err) {
        _error = 'Unexpected error: $err';
      }
    });
  }

  void _reset() {
    setState(() {
      _result = null;
      _error = null;
      _formKey.currentState?.reset();
      _heightController.clear();
      _weightController.clear();
    });
  }
}
