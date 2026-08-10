import unittest

from src.score_stats import score_stats


class ScoreStatsTests(unittest.TestCase):
    def test_baseline_statistics(self):
        self.assertEqual(
            score_stats([2, 4, 9]),
            {"mean": 5, "minimum": 2, "maximum": 9},
        )

    def test_empty_scores_are_rejected(self):
        with self.assertRaises(ValueError):
            score_stats([])


if __name__ == "__main__":
    unittest.main()
