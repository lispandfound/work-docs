#show link: this => text(this, fill: blue)
#set heading(numbering: "1.")
#set math.equation(numbering: "1.")
#set text(
  font: "New Computer Modern",
  size: 10pt,
)
#align(
  center,
  text(24pt)[
    *Source Modelling for Multi-Segment Ruptures*
  ],
)

We define a _multi-segment rupture_ to be a rupture source model consisting of one or
more segments, where each segment is a connected sequence of
planes with consistent dip and dip direction. Earthquakes such as the 2016 Kaikōura earthquake (M#sub[w] $=
7.8$) involve many segments, with the rupture jumping between nearby
segments. Often we may know the participating segments in a rupture, and the
initial hypocentre, but not how the segments are triggered or where the rupture jumps between segments. This document outlines an approach to ground motion simulations of such earthquakes using a new multi-segment rupture model.


= Defining the Multi-Segment Rupture Problem

Before discussing the proposed approach, let us make the problem concrete
through an example. We use the 2016 Kaikōura earthquake throughout this document. The geometry of the causative faults for this event is presented in @kaikoura-plan.


#figure(
  image("kaikoura.png", width: 60%),
  caption: [
    The plan view of the Kaikōura rupture. We adopt the geometry of @kaikoura2016 for this event. The hypocentre location is marked with a star. The rupture geometry consists of 11 segments.
  ],
) <kaikoura-plan>

Our goal is to take the description of the segments involved in the rupture shown in @kaikoura-plan and produce a slip model that simulates the segment jumping observed in the Kaikōura event. The output would be an #link("https://web.archive.org/web/20221207080915/http://hypocenter.usc.edu/research/SRF/srf4.pdf")[Standard Rupture Format (SRF)] file that contains the slip model (an example of which is presented in @kaikoura-srf).
Note that the segment the rupture begins on, as determined by the hypocentre, is known. We call this segment the _initial segment_. The remaining segments are hence _subsequent segments_. We will assume that each subsequent segment is triggered by exactly one other segment, and we refer to this as the _parent segment_.

#figure(
  image("srf.png", width: 90%),
  caption: [
    One slip model generated for the Kaikōura rupture using the geometry and hypocentre described in @kaikoura-plan. The numeric labels correspond to rupture times in the SRF.
  ],
) <kaikoura-srf>

Several variables affect the transformation from segment geometry to slip model:

1. The on-segment slip model,
2. The method to apportion moment to individual segments,
3. The between-segment jumping model,
4. The method used to estimate the probability of jumping between segments, and
5. The paths the rupture takes from the initial source to all other sources (collectively referred to as the _rupture propagation tree_ or _rupture causality tree_).

The on-segment slip modeling follows the process described by @graves2010 and is implemented in the `genslip-v5.4.2` binary. We use this implementation without modification.
Between-segment jumping determines where and when a rupture jumps between two segments. Our analysis considers only kinematic segment jumping.
The rupture causality tree defines which segment triggers which other segment. For a given set of segments many rupture causality trees may exist, but only some are plausible given the jumping model and jumping probabilities. We explore several approaches to determining rupture causality trees.
Each component of this problem involves multiple parameters that require optimisation and validation.

Our algorithm for generating the slip model follows these steps:

1. Allocate the total moment of the rupture to each segment in proportion to area.
2. Compute the most likely segment jumping locations between segment pairs within a fixed plausible distance (default 15 km) of each other.
3. Using these distances, determine the probability distribution for rupture jumping between each pair of plausible segments.
4. Apply a new rupture propagation algorithm to sample rupture causality trees, weighing each path by the combined probability of its successful and unsuccessful jumps.
5. Apply the @graves2010 slip model, placing hypocentres at the segment jumping locations on subsequent segments, with timing delays for downstream segments based on their parent segment's jumping location.

= Moment Allocation

Given a total moment for an event, $M_0$, and a set of participating segments $S_i$ with area $A_i "km"^2$, we assign the moment $M_i$ for $S_i$ according to its area

$ M_i = M_0 A_i / (sum_i A_i). $ <eq-moment-distribution>

This model ensures that the total moment for the rupture is still $M_0$.

== Future Development

- Introduce uncertaintity for $M_i$.
- Explore other functional forms for determining segment moment.

= Segment Jumping <jump-section>

We model a rupture jumping between segments as occurring between their closest points. We make a further simplifying assumption that a segment cannot be triggered more than once in the same rupture. While both the timing and location of jumping could later incorporate uncertainty, we have adopted a simplified model at this stage.
The segment jumping process is illustrated in @segment-jumping. We do not consider jumps between segments separated by more than 15 km.

#figure(
  image("rupture_jump.png", width: 60%),
  caption: [A pair of segments, with their closest points marked A and B. Assuming the segment containing A is the initial segment, the rupture triggers the subsequent segment at B.],
) <segment-jumping>
The rupture time at point B in @segment-jumping is calculated as:

$ T_r + d / V_s, $ <eq-rupture-delay>

where $T_r$ is the initial rupture time at A, $d$ the distance in kilometres between A and B, and $V_s$ the average rupture speed between $A$ and $B$. We assume $V_s = 3.5 "km/s"$. The segment delay calculation could also be made stochastic in the future developments.

== Future Developments
This model could be enhanced in two key areas:

- Introduction of uncertainty in segment jumping locations, both at the origin on the parent segment and at the destination on the subsequent segment.
- Implementation of variable time delays in segment jumping events.

Both enhancements would require empirical data to develop appropriate probability distributions for modeling these variations.

= Jumping Probabilities <probability-section>

We use the first-order model of @shaw2007 to estimate the probability that a rupture jumps from $S_i$ to $S_j$ with the functional form

$
  P(#text([Segment $S_i$ jumps to $S_j$ at distance $r "km"$])) = e^(-r / r_0),
$ <eq-jump-probability>

where $r_0 = 3$ is assumed from limited data. This model informs the rupture propagation algorithm described in @rupture-propagation.


== Future Development
We could further improve this model by:

- Refining the $r_0$ variable, because @shaw2007 admits to using only limited data to arrive at $r_0 = 3$.
- Using a more complicated model that accounts for jumping between segments with differing strike, dip or other characteristics.

= Rupture Propagation <rupture-propagation>

The method of jumping in @jump-section and the probability model
in @probability-section are not sufficient to fully determine
the rupture path. The jumping probability model of @shaw2007 is a local
model that computes pairwise jump probabilities. To compute a likely
rupture path, we must create a _rupture causality tree_ that describes
the parent relationship between all the segments. An example of this tree
is given in @kaikoura-rupture-tree.

#figure(
  image("kaikoura-rupture-tree.png", width: 60%),
  caption: [A possible Kaikōura rupture causality tree. Arrows point in the opposite direction of causality, that is, if segment A triggers segment B, then an arrow is drawn from A to B. Arrows do not indicate jumping locations.],
) <kaikoura-rupture-tree>

With the jump plausibility cutoff of 15 km, there are approximately
180,000 possible ways the rupture can propagate through the
segments. Even by increasing the model complexity to determine pairwise
segment jumping probabilities (accounting for differences in strike, etc.),
the combinatorial explosion in rupture causality tree numbers ensures that
many possible rupture causality trees will exist for any model. The vast
majority of these scenarios are highly unlikely, but how can we quantify
this? The proposed rupture model borrows concepts from graph theory to
prune this search space, narrowing it down to a few of the most likely
rupture causality trees. It also provides two sampling methods to obtain
trees without iterating over the tens of thousands of implausible options.

The graph theory-based algorithm samples rupture causality trees $T$ according to the probability

$
  P(T) prop product_((S, S') in T) P(#text([$S$ triggers $S'$])) product_((S, S') in.not T) (1 - P(#text([$S$ triggers $S'$]))),
$ <eq-tree-probability>

where $(S, S') in T$ if and only if the segment $S'$ is triggered by the segment $S$ in the tree described by $T$. Using this probability distribution over rupture trees, we have two sampling methods:

1. A fair sampling method using Wilson's algorithm @wilson1996generating. This method samples rupture causality trees according to $P(T)$.
2. A maximum likelihood method using maximum spanning trees. This method only returns the most likely rupture causality tree and is useful when simulating only a few instances of single event.

The second method finds a likelihood-maximising rupture causality tree for the Kaikōura event, shown in @most-likely-tree. @rupture-trees shows more trees sampled from the first method.
In @tree-probability-distribution, we present the probability distribution for trees representing 99\% of the probability mass. Aside from the anomaly of equal probability rupture trees, a power-law distribution is observed. This distribution is typical for this algorithm. A similar investigation carried out for the Darfield 2010 event (M#sub[w] $=
7.1$) event using the source geometry of @atzori2012 has similar findings. In that event just three spanning trees account for 80% of the probability mass, and the CDF in @darfield-cdf also displays this power-law behaviour. Further analysis of the Darfield event and detailed descriptions of the mathematics used to generate the trees can be found in the #link("https://github.com/ucgmsim/source_modelling/wiki/Rupture-Propagation#the-rupture-propagation-model")[ucgmsim/source_modelling repository].


#figure(
  image("most-likely-tree.png", width: 60%),
  caption: [The most likely rupture causality tree selected by the second sampling method. Note that multiple trees for this event have equal probability.],
) <most-likely-tree>


#figure(
  image("tree-probability-distribution.png", width: 60%),
  caption: [The rupture probabilities assigned to the most likely trees representing 99% of the probability mass. Many trees have equal probability because some segments in @kaikoura2016 touch.],
) <tree-probability-distribution>

#figure(
  grid(
    columns: 2,
    gutter: 2mm,
    grid.cell([#figure(
        image("props/Untitled-2025-01-16-1106.png", width: 90%),
      )]),
    grid.cell([#figure(
        image("props/Untitled-2025-01-16-1103.png", width: 90%),
      )]),
    "(a)", "(b)",
    grid.cell([#figure(
        image("props/Untitled-2025-01-16-1101.png", width: 90%),
      )]),
    grid.cell([#figure(
        image("props/Untitled-2025-01-16-1100.png", width: 90%),
      )]),
    "(c)", "(d)",
    grid.cell([#figure(
        image("props/Untitled-2025-01-16-1058.png", width: 90%),
      )]),
    "",
    "(e)"
  ),
  caption: [Five rupture causality trees sampled via the first method. Rupture trees are broadly similar apart from different causality choices in the centre of each event. Note that (d) shows the same rupture tree as @kaikoura-rupture-tree.],
)<rupture-trees>


#figure(
  image("cumulative_distribution.png", width: 60%),
  caption: [The CDF for rupture causality trees in the Darfield event, using source geometry provided by @atzori2012.],
)<darfield-cdf>

== Future Development

- Introduce asymmetric jumping probabilities. Currently, the code for the graph-based model assumes $P(#text([$S$ triggers $S'$])) = P(#text([$S'$ triggers $S$]))$. Variants of Wilson's algorithm allow for asymmetric jumping probabilities.
- Support restricting the rupture trees to simple paths. This is computationally expensive compared to the tree approach.

= Validation of the Approach
Although our approach represents a simple extension of the genslip
kinematic rupture generator for single planar faults, we seek to
validate it independently against historical events. We consider two
main validation approaches:

1. Examination of segment-jumping probability distributions across historical and potential future events.
2. Analysis of how segment-jumping time delays affect overall source rupture duration across historical and potential future events.

Our primary application is simulating ruptures from the 2022 New Zealand
National Seismic Hazard Model (NZ NSHM), so we apply the method to
fault geometries from this seismic source model. We additionally use the
#link("http://equake-rc.info/srcmod/")[SRCMOD] database as a catalogue
of finite fault rupture inversions. While we have not yet applied our
generation method to SRCMOD fault geometries, we use the SRCMOD inverted
faults for a preliminary comparison with the NZ NSHM sources.

@srcmod-comparison compares the total rupture durations—defined as the
time interval containing 5% to 95% of the total moment release—between
NZ NSHM sources and the SRCMOD database. The results show broad agreement
except for the largest ruptures in the NZ NSHM. These ruptures, including
but not limited to Alpine Fault scenarios, exhibit larger length-to-width
(L/W) ratios than those in the SRCMOD database. @ratios illustrates how
rupture durations relate to L/W ratios after accounting for magnitude
effects.

#figure(
  image("./srcmod_comparison_groups.png", width: 60%),
  caption: [Comparison of rupture release times between selected slip models generated for ruptures from the NZ NSHM and the SRCMOD database. Generated slip models for the Darfield and Kaikōura ruptures are highlighted.],
) <srcmod-comparison>

#figure(
  image("./aspect_ratio.png", width: 60%),
  caption: [The relationship between moment release and length-to-width ratios for selected slip models from the NZ NSHM.],
) <ratios>

== Future development
- Apply rupture generator to specific geometries in the SRCMOD database to enable direct comparison of results.

#bibliography("bib.yml", style: "springer-basic-author-date")

