"""Small baseline intentionally missing median support."""


def score_stats(scores: list[float]) -> dict[str, float]:
    """Return basic statistics for a non-empty score list."""
    if not scores:
        raise ValueError("scores must not be empty")
    return {
        "mean": sum(scores) / len(scores),
        "minimum": min(scores),
        "maximum": max(scores),
    }
