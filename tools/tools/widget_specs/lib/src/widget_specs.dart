// Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';

/// A class describing the specifications of a custom flutter widget.
class WidgetSpecs implements Comparable<WidgetSpecs> {
  /// Creates a new instance of [WidgetSpecs] class with the given parameters.
  WidgetSpecs({
    this.packageName,
    this.name,
    this.path,
    this.pathFromFuchsiaRoot,
    this.doc,
    this.classElement,
  });

  /// Name of the package in which this widget is defined.
  final String packageName;

  /// Name of the widget.
  final String name;

  /// Relative path of the dart file (under `lib`) where this widget is defined.
  final String path;

  /// Relative path of this file under the fuchsia root.
  final String pathFromFuchsiaRoot;

  /// Contents of the document comments associated with the widget.
  final String doc;

  /// The [ClassElement] corresponding to this widget.
  final ClassElement classElement;

  /// Gets the default [ConstructorElement] of this widget.
  ConstructorElement get constructor => classElement?.constructors?.firstWhere(
        (ConstructorElement constructor) => constructor.isDefaultConstructor,
        orElse: () => null,
      );

  /// Gets the example value specified for the given parameter.
  dynamic getExampleValue(ParameterElement param) {
    ElementAnnotation annotation = getExampleValueAnnotation(param);
    DartObject valueObj = annotation.computeConstantValue().getField('value');

    // TODO(youngseokyoon): handle more types.
    switch (param.type.name) {
      case 'int':
        return valueObj.toIntValue();
      case 'bool':
        return valueObj.toBoolValue();
      case 'double':
        return valueObj.toDoubleValue();
      case 'String':
        return valueObj.toStringValue();
      default:
        return null;
    }
  }

  /// Gets the `ExampleValue` annotation associated with the given
  /// [ParameterElement].
  ElementAnnotation getExampleValueAnnotation(ParameterElement param) {
    for (ElementAnnotation annotation in param.metadata) {
      DartObject annotationValue = annotation.computeConstantValue();
      if (annotationValue?.type?.name == 'ExampleValue') {
        return annotation;
      }
    }

    return null;
  }

  @override
  int compareTo(WidgetSpecs other) {
    return this.name.compareTo(other.name);
  }

  @override
  String toString() => '''WidgetSpecs: $name

$doc''';
}
