#import "@preview/touying:0.5.5": *
#import themes.simple: *
#import "@preview/pintorita:0.1.3"
#import "@preview/cetz:0.3.0"
#set page(margin: (x: auto, y: auto))

#show raw.where(lang: "pintora"): it => image.decode(
  pintorita.render-svg(it.text, style: "default"),
)

#show: simple-theme.with(aspect-ratio: "16-9")

= Modernizing Earthquake Simulation Workflows at UC

= Context
== What We Do
- Support earthquake researchers at UC Civil Natural Resources department.
- Primary focus: Ground motion simulation software.
== Research Outcomes

#align(
  horizon,
  cetz.canvas({
    import cetz.draw: *
    rect(
      (-8, 0),
      (8, 1),
      fill: gradient.linear(..color.map.viridis),
      stroke: none,
      name: "complexity",
    )
    content(
      (name: "complexity", anchor: "center"),
      padding: 1,
      anchor: "south",
      [Workflow #sym.arrow.l.r Computational Complexity],
    )
    content(
      (name: "complexity", anchor: "west"),
      padding: .5,
      anchor: "east",
      [Researchers],
    )
    content(
      (name: "complexity", anchor: "east"),
      padding: .5,
      anchor: "west",
      [Cybershake],
    )
  }),
)
#pause
- *Researchers:* unique workflows, thousands of core-hours.
#pause
- *Cybershake NZ:* single workflow, millions of core-hours.


== The Old Simulation Stack
- Cybershake-centric, unfriendly to researchers.
#pause
- Entirely custom solutions for solved problems.
#pause
- Complex, brittle, hard to reproduce.
#pause
- *So much legacy code!*

= Technical Modernisation
== Container + Workflow + Realisation = Simulation
- *Container*: Reproducible software stack specification.
- *Workflow*: Declarative software execution control.
- *Realisation*: Declarative scientific parameter specification.

== Containerisation
- Apptainer containers for software deployment.
- All workflow stages within containers.
- Archivable with future Cybershake versions.

== Cylc Workflows

#slide[
  - Developed at NIWA
  - Workflow stage composition with TOML-like syntax
][
  #figure(
    image("./tui-1.png", height: 70%),
    caption: [Cylc TUI in Action!],
  )
]

== One-File Simulation Specification
#slide[- Realisation file includes:
  1. Simulation domain and source geometry
  2. Command line parameters
  3. Input file specifications
][
  #text(12pt)[```
      ┐
      ├── metadata
      │   ├── name: 3468575
      │   ├── version: 1
      │   ├── defaults_version: 24.2.2.2
      │   └── tag: gcmt
      ├── sources
      │   └── source_geometries [...]
      ├── rupture_propagation
      │   ├── rupture_causality_tree [...]
      │   ├── jump_points
      │   ├── rakes [...]
      │   ├── magnitudes [...]
      │   └── hypocentre [...]
      ├── srf
      │   ├── genslip_dt: 0.05
      │   ├── genslip_version: 5.4.2
      │   └── resolution: 0.2
      ├── seeds
      │   ├── nshm_to_realisation_seed: 554010839
      │   ├── rupture_propagation_seed: 1355831879
      │   ├── genslip_seed: 906043042
      [...]
    ```]
]
== CI/CD
#slide[- Github Actions for code testing.
  - *Hypothesis testing*.
  - 95% average code coverage target.
][

  #figure(
    image("./ci.png", height: 60%),
    caption: [CI/CD pipeline with coverage.],
  )
]
= Scientific Capabilities
== Flexible Workflow Planning
- CLI for custom workflow generation
- Resolves Cybershake and researcher workflow tensions

#text(14pt)[
  ```bash
  $ plan-workflow 2024p910344:10 flow.cylc --source gcmt --goal im_calc --excluding realisation_to_srf
  You require the following files for your simulation:
  ┐
  └── cylc-src
      └── WORKFLOW_NAME
          └── input
              ├── 2024p910344
              │   ├── realisation.json
              │   │   └── srf: Configuration for SRF generation.
              │   └── realisation.srf: Contains the slip model for the realisation.
              ...             ...
  ```
]
== Better visualisation tools
- Visualisation tools *integrated with testing strategy*.
- Executed as scripts *or Python functions* using Typer.
- Important outputs can be viewed from *multiple perspectives*.
== Real-Time GCMT Simulations
- Simplified environment + workflow planner #sym.arrow.r automatic deployment.
- Automation with GeoNet CMT solutions.
= Future Direction
== Modernising File Formats
- Currently pushing migration from CSV and custom formats to HDF5 datasets.
- Includes advanced metadata like measurement units, hashes of container used to generate formats, etc.
== Translating Old Code to Python
- Major effort to replace C code with modern Python.
- Has advantages for testing, and extension for new researchers.
== Key Takeaways
- Make your workflows *declarative*.
#pause
- Make your workflows *composable*.
#pause
- *Test* properties before implementation.
#pause
- Scientific communication is about *standardisation*.
#pause
- Design for the *least-savvy user*.
