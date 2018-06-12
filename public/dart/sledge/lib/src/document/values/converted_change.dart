// Copyright 2018 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// TODO: consider making Changes immutable.

/// Interface to get changes applied to MapValue.
class MapChange<K, V> {
  /// Changed entries in the MapValue.
  Map<K, V> changedEntries;

  /// Set of keys deleted from the MapValue.
  Set<K> deletedKeys;

  /// Constructor from ConvertedChange.
  MapChange(ConvertedChange<K, V> change)
      : changedEntries = new Map<K, V>.from(change.changedEntries),
        deletedKeys = new Set<K>.from(change.deletedKeys);
}

/// Interface to get changes applied to SetValue.
class SetChange<E> {
  /// Set of inserted elements.
  Set<E> insertedElements;

  /// Set of deleted elements.
  Set<E> deletedElements;

  /// Constructor from MapChange.
  SetChange(ConvertedChange<E, bool> change)
      : insertedElements = change.changedEntries.keys.toSet(),
        deletedElements = new Set<E>.from(change.deletedKeys);
}

/// Change in inner represention of Sledge data types.
class ConvertedChange<K, V> {
  /// Collection of key value pairs to be set.
  final Map<K, V> changedEntries;

  /// Collection of keys to be deleted.
  final Set<K> deletedKeys;

  /// Constructor.
  ConvertedChange([changedEntries, deletedKeys])
      : changedEntries = changedEntries ?? <K, V>{},
        deletedKeys = deletedKeys ?? new Set<K>();

  /// Copy constructor.
  ConvertedChange.from(ConvertedChange<K, V> change)
      : changedEntries = new Map.from(change.changedEntries),
        deletedKeys = new Set.from(change.deletedKeys);

  /// Clears all changes.
  void clear() {
    changedEntries.clear();
    deletedKeys.clear();
  }
}
