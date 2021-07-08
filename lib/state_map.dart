library state_map;

///
/// Copyright (C) 2021 Andrious Solutions
///
/// Licensed under the Apache License, Version 2.0 (the "License");
/// you may not use this file except in compliance with the License.
/// You may obtain a copy of the License at
///
///    http://www.apache.org/licenses/LICENSE-2.0
///
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.
///
///          Created  07 July 2021
///
///

import 'package:flutter/material.dart';

extension StateMapStatefulWidgetExtension on StatefulWidget {
  //
  State? get state => StateMap.of(this);

  bool setState(VoidCallback fn) => StateMap.setStateOf(fn, this);

  bool refresh() => StateMap.refresh(this);
}

/// If this works!!
extension StateMapStateExtension on State {
  static State? of(StatefulWidget widget) => StateMap.of(widget);
}

/// Manages the collection of State objects extended by the SetState class
mixin StateMap<T extends StatefulWidget> on State<T> {
  /// The static map of StateSet objects.
  static final Map<StatefulWidget, State> _states = {};

  static State? of(StatefulWidget? widget) =>
      widget == null ? null : _states[widget];

  /// Return true if successful
  static bool setStateOf(VoidCallback fn, StatefulWidget widget) {
    bool set;

    final state = of(widget);

    set = state != null;

    if (set) {
      set = state.mounted;
    }

    if (set) {
      state!.setState(fn);
    }
    return set;
  }

  /// Return true if successful
  static bool refresh(StatefulWidget widget) => setStateOf(() {}, widget);

  /// Return true if successful
  static bool rebuild(StatefulWidget widget) => setStateOf(() {}, widget);

  @override
  void initState() {
    super.initState();
    _states[widget] = this;
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    _states[widget] = this;
    _states.removeWhere((key, value) => key == oldWidget);
    super.didUpdateWidget(oldWidget);
  }

  /// Remove objects from the static Maps if not already removed.
  /// add this function to the State object's dispose function instead
  @override
  void dispose() {
    _states.removeWhere((key, value) => value == this);
    super.dispose();
  }
}
