// Copyright 2015 Esri.

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#ifndef GORENDERERS_H
#define GORENDERERS_H

#include "Map.h"
#include "MapView.h"
#include "Viewpoint.h"

class GoRenderers : public QWidget
{
  Q_OBJECT

public:
  explicit GoRenderers(QWidget* parent = 0);
  virtual ~GoRenderers();

private:
  Esri::ArcGISRuntime::Map* m_map;
  Esri::ArcGISRuntime::MapView* m_mapView;
  void addGraphicsOverlay();
  void createUi();
};

#endif // GORENDERERS_H
