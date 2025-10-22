# JSON Schema Examples (VS)

VS‑Standard array (strict):

```
[
  { "id": "A", "text": "...", "prob": 0.330, "style_tag": ["tone:witty","perspective:expert","structure:list","persona:marketer"] },
  { "id": "B", "text": "...", "prob": 0.220, "style_tag": ["tone:formal","perspective:third","structure:paragraph","persona:teacher"] },
  { "id": "C", "text": "...", "prob": 0.200, "style_tag": ["tone:casual","perspective:first","structure:dialog","persona:writer"] },
  { "id": "D", "text": "...", "prob": 0.150, "style_tag": ["tone:humor","perspective:observer","structure:bullet","persona:engineer"] },
  { "id": "E", "text": "...", "prob": 0.100, "style_tag": ["tone:direct","perspective:novice","structure:table","persona:analyst"] }
]
```

VS‑CoT packed object:

```
{
  "cot": [
    { "id": "A", "rationale": "Approach A ..." },
    { "id": "B", "rationale": "Approach B ..." },
    { "id": "C", "rationale": "Approach C ..." }
  ],
  "candidates": [
    { "id": "A1", "from_cot": "A", "text": "...", "prob": 0.420, "style_tag": ["tone:formal","structure:paragraph"] },
    { "id": "B1", "from_cot": "B", "text": "...", "prob": 0.350, "style_tag": ["tone:analytical","structure:list"] },
    { "id": "C1", "from_cot": "C", "text": "...", "prob": 0.230, "style_tag": ["tone:creative","structure:dialog"] }
  ]
}
```

VS‑Multi packed object:

```
{
  "initial": [
    { "id": "I1", "text": "...", "style_tag": ["tone:humor"] },
    { "id": "I2", "text": "...", "style_tag": ["tone:formal"] }
  ],
  "rewrite": [
    { "from": "I1", "id": "R1", "text": "...", "style_tag": ["perspective:third"] },
    { "from": "I2", "id": "R2", "text": "...", "style_tag": ["structure:list"] }
  ],
  "final": [
    { "id": "F1", "from": ["I1","R1"], "text": "...", "prob": 0.600, "style_tag": ["tone:humor","perspective:third"] },
    { "id": "F2", "from": ["I2","R2"], "text": "...", "prob": 0.400, "style_tag": ["tone:formal","structure:list"] }
  ]
}
```

Reranker output:

```
{
  "scores": [
    { "id": "A", "accuracy": 0.92, "safety": 0.99, "relevance": 0.88, "novelty": 0.41, "final": 0.83 }
  ],
  "winner_id": "A"
}
```

Notes
- STRICT JSON only (no markdown).
- prob must be 3‑decimal and in [0,1]; sum ≈ 1 (±0.05).
- Enforce diversity via `style_tag` across tone/perspective/structure/persona.
- If parsing fails, use the recovery prompt to repair JSON.
