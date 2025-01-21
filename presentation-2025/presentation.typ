#import "@preview/touying:0.5.5": *
#import themes.simple: *
#show: simple-theme.with(aspect-ratio: "16-9")

= Rupture Modelling: 2025
== SOA: Source Modelling for Multi-Segment Ruptures

#figure(
  grid(
    columns: 2,
    image("kaikoura.png", width: 80%), image("./srf.png", width: 90%),
  ),
)
== Moment Allocation
#figure(
  image("./moment.png", height: 70%),
)
== Distance Calculation
#figure(
  image("./distances.png", height: 70%),
)
== Jump Probabilities
#figure(
  image("./probabilities.png", height: 70%),
)
== Rupture Tree Generation
#figure(
  grid(
    columns: 2,
    gutter: 3cm,
    image("./tree.png", height: 70%), image("./causality.png", height: 70%),
  ),
)
== Lots of Options!
#figure(
  grid(
    columns: 2,
    gutter: 3cm,
    image("./props/Untitled-2025-01-16-1106.png", height: 70%),
    image("./props/Untitled-2025-01-16-1101.png", height: 70%),
  ),
  caption: [Rupture causality tree options for Kaikoura 2016.],
)

== Future Refinements
1. Uncertaintity in location and timing of rupture jumps.
2. Improvements to the jumping probability estimation.
3. Improvements to rupture tree generation.

== Scientific Validation
- Sensitivity studies for causality trees.
  - Cesar had ideas.
#pause
- Need to validate IMs.
  - Detailed study of Kaikōura?
#pause
- Refine hyperparameters
  - Need more data for this?
#pause
- Alpine fault ruptures (Brendon).


== SOA: Non-Linear Fault Geometry

#figure(image("./hikurangi_geometry.png", height: 82.5%))

== Overview
#table(
  columns: (auto, auto, auto),
  stroke: none,
  fill: (rgb("EAF2F5"), none),
  table.header(
    [*Rupture Prop.*],
    [*Curved Geometry*],
    [*Slip Models*],
  ),

  [
    - We can generate multi-segment ruptures.
    - Approach is not _obviously_ wrong.
  ],
  [ - Hikurangi has curved geometry.],
  [ - Contact with Gideon.],

  table.hline(),
  [
    - Scientific validation.
    - Model extension.
    - Hyperparameter refinement.
  ],
  [
    - Develop Mathematics.
    - Slip generation.
    - Testing.
  ],
  [
    - Keep in contact.
    - Explore other models.
    - Integration.
  ],
)
