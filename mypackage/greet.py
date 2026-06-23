def greet(name: str, salutation: str = "Hello") -> str:
	"""Return a friendly greeting for ``name``.

	Falls back to "World" when ``name`` is empty or only whitespace. Raises
	``TypeError`` if ``name`` is not a string.
	"""
	if not isinstance(name, str):
		raise TypeError(f"Expected name to be a string, received {type(name).__name__}")
	recipient = name.strip() or "World"
	return f"{salutation}, {recipient}!"
