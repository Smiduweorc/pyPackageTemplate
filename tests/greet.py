import unittest

from mypackage import greet


class TestGreet(unittest.TestCase):
	def test_default_salutation(self):
		self.assertEqual(greet("Ada"), "Hello, Ada!")

	def test_custom_salutation(self):
		self.assertEqual(greet("Ada", "Hi"), "Hi, Ada!")
