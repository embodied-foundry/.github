# Architecture

Org-level architecture of embodied-foundry, drawn with the [C4 model](https://c4model.com) in Mermaid ([ADR-0002](../decisions/0002-diagrams-as-code-mermaid-c4.md)). This repo owns levels 1–2 (context, containers). Level 3+ (components inside a layer) lives in each layer repo and links back here.

| Doc | Covers |
| --- | --- |
| This page | System context, layers, the demonstration → policy → rollout loop |
| [contracts.md](contracts.md) | The six cross-layer contracts and the physical conventions they share |

## Level 1 — System context

```mermaid
flowchart TB
    operator["👤 Operator<br/><i>Demonstrates tasks,<br/>takes over during rollouts</i>"]:::person
    researcher["👤 Researcher<br/><i>Curates data, trains<br/>and evaluates policies</i>"]:::person

    ef["<b>embodied-foundry</b><br/><i>Collects demonstrations, turns them into<br/>datasets and policies, and runs those<br/>policies on robots</i>"]:::system

    robot["🤖 Robot<br/><i>Real hardware or simulator</i>"]:::external
    compute["☁️ Compute & storage<br/><i>GPU training, dataset / artifact storage</i>"]:::external

    operator -- "teleoperates" --> ef
    researcher -- "curates, trains, evaluates" --> ef
    ef -- "commands / observes" --> robot
    ef -- "stores datasets, runs training" --> compute

    classDef person fill:#08427b,stroke:#052e56,color:#fff
    classDef system fill:#1168bd,stroke:#0b4884,color:#fff
    classDef external fill:#6b6b6b,stroke:#4d4d4d,color:#fff
```

## Level 2 — Layers

Each box is a repository. Arrows are labelled with the contract that crosses the boundary ([contracts.md](contracts.md)).

```mermaid
flowchart LR
    subgraph ef["embodied-foundry"]
        direction LR
        core["<b>core</b> <i>(planned)</i><br/>Contract definitions:<br/>Embodiment, Robot interface,<br/>Controller, Episode"]:::planned

        teleop["<b>teleop</b><br/>Human controllers<br/>(devices → Actions)"]:::container
        inference["<b>inference</b><br/>Policy controllers<br/>(Policy artifact → Actions)"]:::container
        data["<b>data</b><br/>Ingest, validate, curate,<br/>version datasets"]:::container
        training["<b>training</b> <i>(unowned)</i><br/>Dataset → Policy artifact"]:::planned
    end

    robot["🤖 Robot / Simulator"]:::external

    teleop -- "C3 Controller → C2 Robot interface" --> robot
    inference -- "C3 Controller → C2 Robot interface" --> robot
    teleop -- "C4 Episode (demonstrations)" --> data
    inference -- "C4 Episode (rollouts, interventions)" --> data
    data -- "C5 Dataset" --> training
    training -- "C6 Policy artifact" --> inference

    core -. "defines C1–C4" .-> teleop
    core -. "defines C1–C4" .-> inference
    core -. "defines C1–C4" .-> data

    classDef container fill:#438dd5,stroke:#2e6295,color:#fff
    classDef planned fill:#fff,stroke:#438dd5,stroke-dasharray:5 5,color:#1b1b1b
    classDef external fill:#6b6b6b,stroke:#4d4d4d,color:#fff
```

Dashed boxes do not exist yet. Both are open decisions on the [roadmap](../ROADMAP.md#open-decisions).

## The key design choice: teleop and inference are interchangeable controllers

A human operator and a trained policy do the same job: read an observation and emit an action for the same robot. Both implement one **Controller** contract (C3) against one **Robot interface** (C2), and recording is a sink on that interface, not a teleop feature.

```mermaid
flowchart LR
    subgraph controllers["C3 Controller"]
        direction TB
        human["Human<br/>(teleop device)"]:::container
        policy["Policy<br/>(inference)"]:::container
    end

    arbiter{"Arbiter<br/><i>who is in control<br/>this step</i>"}
    iface["C2 Robot interface<br/>observe() / act()"]:::container
    robot["🤖 Real or sim"]:::external
    recorder["Recorder<br/>→ C4 Episode"]:::container

    human -- Action --> arbiter
    policy -- Action --> arbiter
    arbiter -- Action --> iface
    iface <--> robot
    iface -- Observation --> human
    iface -- Observation --> policy
    iface -- "Observation + Action<br/>+ controller source" --> recorder

    classDef container fill:#438dd5,stroke:#2e6295,color:#fff
    classDef external fill:#6b6b6b,stroke:#4d4d4d,color:#fff
```

What this buys us:

- **Same episode format for demos and rollouts.** `data` needs one ingest path, and every episode records which controller acted at each step.
- **Human intervention for free.** Taking over a running policy only means switching the arbiter's source. The interleaved episode is exactly the training signal that intervention-based learning needs (Phase 3 on the roadmap).
- **Sim/real parity.** A simulator is just another Robot interface implementation, so teleop and inference code do not branch on sim vs. real.

## The loop

```mermaid
flowchart LR
    demo["Demonstrate<br/><i>teleop</i>"] --> ingest["Ingest & validate<br/><i>data</i>"]
    ingest --> curate["Curate & version<br/><i>data</i>"]
    curate --> train["Train<br/><i>training</i>"]
    train --> deploy["Deploy & evaluate<br/><i>inference</i>"]
    deploy -- "rollouts +<br/>interventions" --> ingest
```
