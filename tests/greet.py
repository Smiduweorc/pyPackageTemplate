import unittest

from mypackage import greet


class TestGreet(unittest.TestCase):
	def test_greets_a_name(self):
		self.assertEqual(greet("Ada"), "Hello, Ada!")

	def test_custom_salutation(self):
		self.assertEqual(greet("Ada", "Hi"), "Hi, Ada!")

	def test_trims_surrounding_whitespace(self):
		self.assertEqual(greet("  Ada  "), "Hello, Ada!")

	def test_empty_name_falls_back_to_world(self):
		self.assertEqual(greet("   "), "Hello, World!")

	def test_non_string_name_raises_type_error(self):
		with self.assertRaises(TypeError):
			greet(42)  # type: ignore[arg-type]


if __name__ == "__main__":
	unittest.main()
