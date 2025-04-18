from typing import Any


def merge_stage1_question(outputs: dict[str, dict[str, Any]]):
    merged = {"question": None, "answer": None, "agent_answers": {}}
    for o in outputs.values():
        if "question" not in o or "answer" not in o:
            logging.warning(f"Missing required keys in output: {o}")
            continue
        # Only set question and answer if not already set
        if merged["question"] is None:
            merged["question"] = o["question"]
        if merged["answer"] is None:
            merged["answer"] = o["answer"]
        if "agent_answers" in o:
            merged["agent_answers"].update(o["agent_answers"])
    for agent in outputs:
        if agent not in merged["agent_answers"]:
            merged["agent_answers"][agent] = "No answer received..."
    return merged


def merge_stage2_question(outputs: dict[str, dict[str, Any]]):
    # TODO: Currently question+answer keeps getting replaced at every file. This is wasteful and can be optimized
    # TODO: If an agents' answers more than once (or >1 answer from the same agent id hash), then current implementation will only keep the last seen in the loop. Should allow for multiple answers?
    merged = {
        "question": None,
        "answer": None,
        "stage2_prompt": None,
        "agent_opinion": {},
    }
    for o in outputs.values():
        for col in ["question", "answer", "stage2_prompt"]:
            if col in o:
                merged[col] = o[col]
        if "agent_opinion" in o:
            merged["agent_opinion"].update(o["agent_opinion"])
    # Fill with default values. TODO: Decide if this is a good choice.
    for agent in outputs:
        if agent not in merged["agent_opinion"]:
            merged["agent_opinion"].update({agent: "No feedback received..."})
    return merged
