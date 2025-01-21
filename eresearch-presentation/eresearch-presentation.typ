#import "@preview/touying:0.5.5": *
#import themes.simple: *
#import "@preview/pintorita:0.1.3"
#show raw.where(lang: "pintora"): it => image.decode(
  pintorita.render-svg(it.text, style: "default"),
)

#show: simple-theme.with(aspect-ratio: "16-9")


= Title Slide
= Context
== What we do
- We (who?) support earthquake researchers at UC in Civil Nat. Res department.
- The primary software application is ground motion simulation.
#pause
SPECTRUM DIAGRAM HERE
== Scale of NZ Cybershake
- Simulations of possible future events in the NSHM.
- Thousands of events simulated dozens of times each.
- Fixed workflow with millions of core-hours.
== Custom Researcher Workflows
- Unique workflows using components developed by RSE team.
- Possibly limited HPC background.
- Rapidly iterating.
== The Old Simulation Stack
- Cybershake-first, researcher second. Inflexible.
- Everything custom. NIH syndrome.
- Complicated environment. Brittle and difficult to reproduce.
= Technical Modernisation
== Container + Workflow + Realisation = Simulation
- *Container*: Exactly specifies the software stack in a reproducible fashion.
- *Workflow*: Declaratively specifies how the software is executed (control flow).
- *Realisation*: Declaratively specifies the scientific parameters in the workflow.
== Containerisation
== Cylc workflows
== One-File Simulation Specification
== CI/CD
= Scentific Capabilities
== Flexible workflow planning
== Better visualisation tools
== Real-Time GCMT Simulations
= Future Direction
== Modernising File Formats
== Translating Old Code to Python
= Key Takeaways

