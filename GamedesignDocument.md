# Core Gameplay Loop

## Overview
The game is a **run-based roguelike** inspired by the classic Snake. The player controls a growing snake that must collect fruits within a time limit while avoiding collisions with itself and the environment. The run progresses through increasingly difficult stages and rewards strategic resource use between rounds.

---

## Structure of a Run

- A run consists of **3 acts**, each containing **4 rounds**.
- Each round has a **fixed time limit**.
- The goal is to collect a **minimum number of fruits** before the timer runs out.

---

## Fruit Collection

- **Fruits spawn one at a time** at random locations.
- A new fruit spawns **immediately after** the current one is collected.
- Each fruit collected **increases the snake’s length**.
- If the snake **hits a wall or itself**, one fruit is **subtracted from the current round's progress**.

> 💡 The snake enters **temporary invincibility frames** after collisions to prevent rapid chain-loss or dead ends.

---

## Round Outcome

- If the required number of fruits is **not reached**, the run ends (failure).
- **Excess fruits** collected beyond the required amount are converted into **upgrade currency**.
- These excess fruits do carry over across rounds, but **not across acts**.

---

## Between-Round Upgrades

After each round, the player can spend excess fruit to purchase **one** of the following:

1. **An offered permanent upgrade**
2. **A second different offered permanent upgrade**
3. **A standard field size upgrade** (always available, always the cheapest option):
   - Expands the playable area.
   - This upgrade **resets** with each new act.

Only **one upgrade** can be purchased per round, forcing trade-offs:
> How many times can the Player afford to skip the safe, cheap, but temporary field upgrade?
> Is it worth to pay less or even nothing in a round to afford a high cost upgrade in a later round?

---

## Snake Control $ Growth

- The snake is unable to stop moving and will move in the direction last inputted until a new dínput is recieved.
- There is a sprint meter that decreases when holding down sprint. It recharges automatically and can only be reused when full
- The snake’s **length is preserved** throughout an act (4 rounds).
- **Length resets** at the start of a **new act**.
- Players must weigh the benefit of collecting excess fruits (upgrade currency) against the difficulty of controlling a longer snake in subsequent rounds.

> 💡 The Sprint meter allows for more strategy and higher skill ceiling in the early itemless rounds.

---

## Difficulty Scaling

- Each act or round increases the challenge:
  - **Higher minimum fruit requirements**
  - **Faster snake speed**

- **Completing a full run** unlocks the **next of 3 difficulty tiers**. These increase the challenge by: 
  - **Higher minimum fruit requirements**
  - **Reduced round time**
  - **Faster snake speed**
  - **More fruit lost on collision**


  # Upgrade System

## Overview

At the end of each round, the player may choose **one of three upgrade options**. If it is **not the final round of a level**, one of the three options is always the **temporary upgrade** `Larger Area`, which resets at the beginning of the next level.

> 💡 The two upgrade prices ascend from left to right, while the upgrades themselves are of random rarity. Only the rightmost Upgrade (appearing in the final round of a level) - being the priciest - is guaranteed to be either a special upgrade or an advanced version. This way the Player is incentivised to collect even more fruits in the last rounds.

- Selecting an upgrade may unlock **advanced versions** in future upgrade pools.
- Upgrades are categorized loosely by function or effect. These categories may influence synergy interactions.
- The number of obtainable Items is limited by the available slots. Each Categorie has a different number of slots
- An upgrades price is determined by the spot it appears in as well as the slot it gets bought in: replacing another Item in a slot is cheaper than filling a new slot

---

## Upgrade Categories


| Category     | Description                                         | Slots|
|--------------|-----------------------------------------------------|-----|
| Default      | Always available upgrade (`Larger Area`)            |1|
| Active       | Requires activation by the player                   |2|
| Passive      | Always-on effect                                    |4|
| Bodymod      | Alters how the snake's body behaves or interacts    |3|
| Synergy      | Relies on or enhances combinations of other upgrades |2|
| Special      | Rule-breaking or run-defining modifiers             |1|

---

## Upgrade List

### 🟢 Default
- **Larger Area** (resets each act): Increases the size of the playable field.
  - → advanced version enlarges even further
  - → third advancement brings area to maximum size

---

### 🔴 Active

- **Crossroad Spawner**  
  - Spawn a crossroad on which you may intersect your body 
  - → Spawn a 3×3 invincible zone  
  - → Two 4×4 invincible zones  
  - *(Each tile can only be intersected twice to avoid infinite invincibility.)*

- **Pause & Reverse**  
  - Use 2 manual stops  
  - → beyond stopping you may move in reverse
  - → 3 reverse moves

- **Wormhole**  
  - Enter a wormhole and place an exit anywhere  
  - → Place two wormholes per round

- **Fruit Relocator**  
  - Relocate all fruit up to 2 times  
  - → 4 times  

---

### 🟠 Passive

- **Auto-Tongue Collection**  
  - Collects fruit two tiles ahead  
  - → Radius-based auto-collection  
  - → Larger collection radius

- **Hyperspeed Enhancement**  
  - Larger hyperspeed gauge  
  - → Gauge fills faster  
  - → Unlimited hyperspeed

- **Edge Wrap**  
  - Leaving the map on one side makes you appear on the opposite side
  - → Doing so immediately refills your hyperspeed gauge

- **Smart Spawn**  
  - Fruit will not spawn in enclosed areas  
  - → When fruit would've spawned there, spawn two copies elsewhere

- **Double Fruit Spawn**  
  - Two fruit spawn at once  
  - → fruit are worth more and more when left uncollected
  - → Three fruits spawn at once

---

### 🟡 Bodymod

- **Center Invincibility**  
  - Touching the center of a long straight bodysection grants brief invincibility

- **Corner Phasing**  
  - Snake can pass through its own corners

- **Tail Cut-Off**  
  - Touching your tail will cut it off (up to 3 times per run)

- **Headlight**  
  - Head emits light in dark levels, lets see through roofs and kills ghosts on contact

- **Wall Immunity (while in Hyperspeed)**  
  - Colliding with a wall during hyperspeed does not cost a fruit
---

### 🔵 Synergy

- **Refill on Objective**  
  - Active items refill automatically upon reaching the fruit goal

- **Magnet Surge**  
  - When your head passes your body, all fruits move toward you

- **Bodymod Amplifier**  
  - Bodymods cover double the snake's length/effectiveness (Wall immunity now also grants snakebody immuniity)

---

### 🟣 Special (Rule-breaking / transformative)

- **Length Lock**  
  - Snake length cannot change while any body part is in an unreachable area  
  - Cannot purchase `Larger Area` anymore

- **Timed Fruit Spawns**  
  - Fruits appear in timed intervals  
  - Gain one fruit for every uncollected fruit left on the field

- **Manual Movement**  
  - Move freely back and forth (no auto-forward)  
  - Collision causes you to lose **double** fruits

- **Double Shop**  
  - Can purchase two upgrades at the end of a round  
  - Lose all current Bodymod upgrades

- **Area Collector**
  - Every empty Item Slot gets filled with junk (Except Default Slot)
  - Get a random (passive?) upgrade everytime you purchase area upgrades (Items obtained that way can replace junk) 

# Round Modifiers

## Concept

Each round except the first is affected by a **random Modifier**, which alters core gameplay conditions. Modifiers aim to:
- **Counter or enhance specific builds** (e.g. active item-based, multiple fruit spawns, hyperspeed build).
- **Provoke meaningful player decisions** by changing expected patterns.
- **Scale with progression**: some appear more often in early rounds (1–2), others in late rounds (3–4).
- While in the shopping phase the player sees the upcoming modifier
- The same modifier never appears two times **in the same act**


> 💡 This system introduces **run-level variety** and exponential challenge development across levels. The clue on the upcoming modifier gives players room for more informed decisions, for example to replace possessed upgrades

---

## Modifier Types

Each modifier is tagged:
- `E` – **Early Modifier** (common in Rounds 2-3)
- `L` – **Late Modifier** (common in Rounds 3–4)
- `?` – **Needs Design Review** (may lack mechanical impact)

---

## Modifier List

| ID  | Name           | Type | Description                                                                 |
|-----|----------------|------|-----------------------------------------------------------------------------|
| 1   | Classic        | —    | Much higher fruit threshold must be met                                    |
| 2   | Tetrifruits    | L    | Eaten fruits occupy space in large blocks inside the snake (e.g., 2×2)     |
| 3   | Telefruits     | —    | Two fruits spawn. Collecting one teleports you to the location of the other |
| 4   | Intruder       | L    | Randomly moving ghost NPCs block paths                                     |
| 5   | Caffeinated    | L    | Higher base snake speed. If `Manual Move` upgrade is active, you slide 1 tile further after stopping |
| 6   | High Protein   | ?    | Special fruits appear that grow the snake twice as much. _(Note: currently lacks synergy or meaningful counterplay.)_ |
| 7   | Rice Paper     | —    | Using Active Items increases your snake’s length                           |
| 8   | Fruitbody      | —    | Passing over your own body enlarges the snake                              |
| 9   | Kids’ Menu     | E    | Overstock fruit is capped low (only enough for small/standard upgrades). Fruits move toward you at default speed. Cannot appear in final round |
| 10  | Lasers         | L    | Sporadic lasers cross the screen horizontally or vertically                |
| 11  | Darkness       | E    | Only the snake’s body emits light. The rest of the map is dark             |
| 12  | Corner Limit   | E    | Having fewer than 3 corners increases your snake’s length                  |
| 13  | No Hyperspeed  | E    | Hyperspeed is disabled unless you enclose space with your body             |
| 14  | Tail Aura      | E    | A 5×5 aura around your tail deducts a fruit if entered                     |

---

> 💡 Modifiers also help distribute difficulty **non-linearly** across a run, making the pacing more dynamic and forcing players to adapt.


# Map Design

## Design Philosophy

Maps are not only static environments — they are **active challenges** that interact with the player’s build, upgrades, and movement strategy. The design follows several core principles:

- **Synergy & Counterplay**: Certain upgrades make specific maps easier to navigate or survive.
- **Evolving Complexity**: Later maps introduce **moving elements**, **dynamic hazards**, and **interactive objects**.
- **Spatial Identity**: Each map is immediately recognizable by its **shape**, **layout**, and **greymap silhouette**.

---

## Map Catalog

| ID  | Name         | Level | Description                                                                                   |
|-----|--------------|--------|-----------------------------------------------------------------------------------------------|
| 1   | Fields       | 1      | Mostly open map with occasional rocks and hills. Smaller play area to balance accessibility. |
| 2   | Tomb         | 1      | Chessboard-like blocked tiles with partial openness. Maze-like movement.                     |
| 3   | Office       | 2      | Divided into rooms with doors that open and close at set intervals. Timing is essential.     |
| 4   | Beach        | 3      | Tides shift periodically, shrinking or expanding 5-tile water zones that separate landmasses.|
| 5   | Tree Park?   | 2      | Multilevel area with bridges and height variation. May require path planning across floors.  |
| 6   | Swim Pool    | 3      | Ring corridors surround a central pool. Entry points between rings rotate clockwise/counter. |
| 7   | Stadium      | 1      | Open central field with narrow grandstands around the perimeter.                            |
| 8   | Space Station| 3      | Three moving platforms scroll horizontally, offset like a checkerboard.                     |
| 9   | Ice Cave     | 2      | A sliding ice block moves continuously like a puzzle element, pushing through open lanes.    |
| 10  | Restaurant   | 1      | Open dining area with narrow access to kitchen and exits.        |
| 11  | Central Station | 2   | Large central plaza with left/right train platforms. Trains block paths for extended time.  |

---

## Map Mechanics & Strategic Interactions

- **Dynamic Elements**:
  - `Swim Pool`, `Central Station`, `Beach`, `Space Station` add movement, rotation, or timing elements.
- **Upgrade-Relevant Features**:
  - `Corner Phasing` or `Crossroad Spawner` is powerful on maps with cross paths (e.g. `Tomb`).
  - `Stop & Reverse` is powerful on maps with Timed Elements (e.g. `Office` or `Space Station`).
  - `Wormhole` or `Invincibility` upgrades gain value in compartmentalized maps (`Central Station`, `Restaurant`).
- **Modifier Synergies**:
  - `Ice Cave` can become dangerous when paired with the `Darkness` modifier.
  - Collecting `Telefruits` can become dangerous during `High Tides`
  - `Laser` puts you in dead ends in twisted maps

---
# Meta Progression

## Overview

Meta progression is driven by **excess fruits** collected in **every act** of a successful run. These fruits can be spent after the run to **lower the cost of unlocking progression chests**. Each chest eventually reveals a **clue letter** that hints at how to unlock a secret playable character.

> 💡 To invoke a feeling of accomplishment after lost runs, the collected overstock fruit in every run should still partially be able to lower the cost of unlocking the chests

---

## Chest System

- Each **difficulty tier** offers **3 progression chests**, each costing ~1 run worth of fruits
- **Fruit can be spend freely among the Chests of same or lower difficulty**.
  - If a chest’s price reaches **0**, it reveals three **stylized letters** of which one can be opened.
  - The unopened letters visually fly into the next box of the same difficulty tier to show that the next choice will be between two, and then only one.

> 💡 Letters are designed in the **visual style of the characters** they refer to, reinforcing their identity even before unlocking them.

---

## Example Letter Clues (Unlock Conditions)

Each letter provides a **cryptic gameplay challenge**. The player must complete the task in a run to unlock a **new character**.

| ID | Letter Clue                                               | Condition Description | Synergizing Upgrades |
|----|------------------------------------------------------------|------------------------|----------------------|
| 1  | *"Pass the flower fields in the correct flower order."*   | Navigate specific tiles in a precise sequence. |
| 2  | *"Break down every office door... in one go."*              | Slam into every Office map's door repeatedly in one round (without letting it recover). |Tail Contact invincibility, Wall immunity|
| 3  | *"Four goals. Four rounds. Score them all."*              | Shoot a goal in the `Stadium` map in **each of the four rounds**. |
| 4  | *"The statues are watching... surround them all tightly."*| Fully encircle all 3 statues. They subtly react if enclosed. |
| 5  | *"Don’t blink. Just stare into its eyes."*                | Stay still and look directly at a specific object/creature. | Pause $ reverse, Manual Movement|
| 6  | *"Catch what hides from the snake."*                      | Intercept a character that only disappears into rooms **not occupied by the snake**. | Wormhole |
| 7  | *"Sometimes... skipping reveals more than choosing."*     | Press the “skip” button **during chest cash-in**. Only appears in later difficulty tiers. |
| 8  |"Reach the furthest corner."                               |Buy every Area Upgrade on a specific (Lvl 1) Map
| 9  | *"100m sprint. Beat the clock."*                          | Reach a start/finish line within a specific digital timer (visible stopwatch) threshold. | Hyperspeed Enhancement, Caffeinated (Modifier)
| 10 | *"Find the island. Reach it. Come back alive."*           | Use `Wormhole` to reach a secluded island on the `Beach` map. A return portal spawns on arrival. | Wormhole|

## Further Meta Completion

- Besides characters there are two toher Achievement a player can hunt down over the course of multiole runs:
  1. Classic Achievements, provoking challenge runs or improbable item combos
  2. Upgrade Gallery, displaying **every Upgrade equipped in a won run**, with a badge showing the highest difficulty tier it was done
---
