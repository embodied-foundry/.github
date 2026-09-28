# Architecture

The architecture is one [LikeC4](https://likec4.dev) model in [`model/`](model/), following the [C4 model](https://c4model.com) ([ADR-0002](../decisions/0002-architecture-as-model-likec4.md)). Every diagram is a view generated from that model, so an element is defined once and shows up consistently everywhere it appears.

## Viewing

```sh
npm ci
npm run arch:dev        # interactive viewer at http://localhost:5173 (click an element to drill down)
npm run arch:export     # PNG of every view into out/architecture/
```

Every pull request that touches the model also gets the rendered PNGs as a workflow artifact, so reviewers can see the result without running anything.

## Views

| View | Shows |
| --- | --- |
| `index` | System context: people, robot, devices, compute around embodied-foundry |
| `layers` | Each layer repo and the contracts that flow between them |
| `runtime` | Teleop and inference as interchangeable controllers on one robot interface |
| `contracts` | C1–C6 and how they reference each other |
| `loop` | Step-by-step: demonstrate → train → deploy → intervene |

Every element also has a generated drill-down view (`implicitViews`), so component detail added to a layer file is immediately navigable.

## Model layout

| File | Owner | Contains |
| --- | --- | --- |
| `model/specification.c4` | maintainers | Element kinds, relationship kinds, tags |
| `model/landscape.c4` | maintainers | People, external systems, the layers themselves |
| `model/layers/<layer>.c4` | that layer's team | The layer's components and their relationships |
| `model/views.c4` | maintainers | Cross-cutting views |

A layer team adds detail only in its own file, by `extend ef.<layer> { … }`. Cross-layer relationships are declared in the file of the layer that initiates them.

## The key design choice: teleop and inference are interchangeable controllers

A human operator and a trained policy do the same job: read an observation and emit an action for the same robot. Both implement the **C3 Controller** contract and drive the **C2 Robot interface** through an **Arbiter**, and the Recorder sits on that interface rather than inside teleop. See the `runtime` view.

- **One episode format.** Demonstrations and policy rollouts are both C4 Episodes with per-step controller source, so `data` needs one ingest path.
- **Human intervention for free.** Taking over a running policy only switches the Arbiter's source. The interleaved episode is exactly the training signal that intervention-based learning needs (Phase 3 on the [roadmap](../ROADMAP.md)).
- **Sim/real parity.** A simulator is another C2 implementation, so teleop and inference do not branch on sim vs. real.

The contracts themselves are specified in [contracts.md](contracts.md).
