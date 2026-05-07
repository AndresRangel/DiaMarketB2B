---
name: Design System Audit & Rules
description: Resultados de auditoría UI/UX completa (2026-05). Design system establecido con PRODUCT.md, DESIGN.md, design-system/MASTER.md y overrides por pantalla.
type: project
---

Auditoría UI/UX completa ejecutada con ui-ux-pro-max + impeccable. Archivos creados:
- `PRODUCT.md` — perfil del producto y usuarios
- `DESIGN.md` — reglas visuales completas (colores, tipografía, espaciado, radios, sombras)
- `design-system/MASTER.md` — tokens + checklists de componentes
- `design-system/pages/product_card.md` — fixes críticos (touch targets, colores)
- `design-system/pages/home_page.md` — mejoras visuales
- `design-system/pages/product_detail.md` — refactor + jerarquía de precios
- `design-system/pages/shimmer.md` — fix colores hardcodeados → theme tokens

**Why:** La app tenía buena arquitectura pero problemas sistémicos de calidad visual — colores hardcodeados, touch targets < 44px, sin escala tipográfica, sin tokens de espaciado.

**How to apply:** Antes de crear cualquier UI nueva, leer PRODUCT.md + DESIGN.md + MASTER.md. Usar tokens AppTextStyles/AppSpacing/AppRadius (pendientes de crear en lib/shared/constants/). Todas las pantallas se validan contra el checklist de MASTER.md.

**P0 pendientes:**
1. Touch targets 34px → 44px en _AddButton, _QtySelector, _InlineBtn (product_card.dart)
2. ShimmerBox: colores hardcodeados → themeProvider
3. Crear AppTextStyles, AppSpacing, AppRadius, AppShadows en lib/shared/constants/
