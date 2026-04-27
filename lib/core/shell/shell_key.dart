import 'package:flutter/material.dart';

/// GlobalKey del Scaffold principal. Permite abrir el drawer desde cualquier
/// página sin necesidad de pasar callbacks por el árbol de widgets.
final mainScaffoldKey = GlobalKey<ScaffoldState>();
