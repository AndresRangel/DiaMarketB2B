# PRODUCT.md — EntregasB2B / Dia Market B2B

## Product Purpose

B2B mobile commerce platform for wholesale buyers (tiendas, minimarkets, restaurantes, cafeterías). Users place large orders from a distributor's catalog on a daily or weekly cadence. This is a **transactional, high-frequency, work tool** — not a consumer shopping app. Speed, clarity, and trust are the primary UX values.

## Register

**product** — app UI, dashboard, tool: design SERVES the product.

## Users

**Primary:** Dueños/encargados de tiendas de barrio, minimarkets, restaurantes pequeños. Ages 28–55. Mobile-native. Spanish-speaking (primarily es-CO). Use the app while managing their business, often distracted, with limited time. They know their products by name and SKU. They order the same ~20-50 items repeatedly with occasional exploration.

**Secondary:** Sales reps / account managers who support these buyers. They need to understand cart state quickly.

## Brand Tone

Professional, trustworthy, efficient. NOT playful, NOT consumer-facing, NOT generic SaaS. The visual language should communicate: "this is your business tool." Every interaction must feel fast and deliberate. Warmth comes from clarity and reliability, not from decorative elements.

## Anti-references

- Consumer grocery apps (Rappi, Mercado Libre) — too playful, wrong information density
- Generic Flutter UI templates — flat, no character, looks like a tutorial project
- AI-generated purple/gradient UI — looks untrustworthy to B2B buyers
- Material Design defaults without customization — screams "demo app"
- Dashboard clichés: hero metric cards with gradients, identical card grids, modal-first flows

## Strategic Principles

1. **Speed over discovery.** Reorder > explore. Surface what users already know.
2. **Trust through numbers.** Price breakdowns, inventory counts, and order history must be legible at a glance.
3. **Density with breathing room.** B2B users need more info per screen than consumers, but not at the cost of legibility.
4. **One primary action per screen.** Don't compete for attention. The cart CTA always wins.
5. **White-label integrity.** Every visual decision must work across any brand color (navy, red, green, purple). No hardcoded aesthetics that assume a specific hue.

## White-Label Constraint

The entire visual system must be expressed through **theme tokens** from `ThemeNotifier` / `themeProvider`. Every color decision in UI must use:
- `primaryColor` — main brand action color
- `accentColor` — secondary highlight
- `backgroundColor` — page background
- `surfaceColor` — card/container background
- `textPrimaryColor` / `textSecondaryColor`
- Semantic: `errorColor`, `warningColor`, `successColor`

No hardcoded hex values in production widgets. Exceptions: shimmer base/highlight (tied to theme in next iteration), placeholder icon color (linked to textSecondary).
