# Verbalized Sampling (VS) Prompt Pack

This pack adds ready‑to‑use prompt templates to increase response diversity without any code changes. It follows the paper insight: "ask the model to verbalize a distribution" (multiple candidates + self‑reported probabilities), then select one candidate (optionally with a light reranker).

What’s included
- VS‑Standard (1‑turn, K candidates + prob)
- VS‑CoT (diverse reasoning paths → answers)
- VS‑Multi (rewrite/synthesis across 2–3 sub‑steps)
- Reranker (LLM or heuristic), JSON recovery prompt
- JSON schema examples and safety notes

How to use
1) Pick a template in `docs/prompts/templates/` and paste it before your task.
2) Replace variables: `{TASK}`, `{K}`, `{MAX_CHARS}` or `{MAX_TOKENS}`, `{TAU}`.
3) Ensure the model returns STRICT JSON only. If parsing fails, run the recovery prompt.
4) Selection: self‑reported prob top‑1 or weighted sample. Optionally run the Reranker prompt.

Recommended defaults
- VS‑Standard: K=5, τ=1.0, max length 250–400 tokens
- Start with no reranker → add LLM reranker or heuristic later
- Keep safety/factual rules intact (templates already ask for it)

Files
- `templates/vs_standard_ko.txt`, `templates/vs_standard_en.txt`
- `templates/vs_cot_ko.txt`, `templates/vs_cot_en.txt`
- `templates/vs_multi_ko.txt`, `templates/vs_multi_en.txt`
- `templates/ranker_ko.txt`, `templates/ranker_en.txt`
- `templates/recovery_ko.txt`, `templates/recovery_en.txt`
- `templates/json_schema_examples.md`

Operational notes
- Diversity knob: re‑normalize probs with temperature τ (τ>1 → more diverse).
- Safety: keep existing filters; templates already ask to avoid harmful content.
- Logging (optional): store the candidate JSON, chosen id, K/τ/mode for later tuning.

