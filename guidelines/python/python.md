# Python Programming Guidelines

## Philosophy

Write idiomatic Python for version 3.13+. Embrace "The Zen of Python": beautiful is better than ugly, explicit is better than implicit, simple is better than complex. Follow PEP 8 and modern type hints.

---

## Project Setup

### Creating a New Project

```bash
# Create project directory
mkdir myproject
cd myproject

# Create virtual environment
python3.13 -m venv venv

# Activate virtual environment
source venv/bin/activate  # Linux/Mac
venv\Scripts\activate     # Windows

# Install dependencies
pip install -r requirements.txt
```

### Project Structure

```
myproject/
├── src/
│   └── myproject/
│       ├── __init__.py
│       ├── main.py
│       ├── config.py
│       └── utils.py
├── tests/
│   ├── __init__.py
│   ├── test_main.py
│   └── test_utils.py
├── docs/
├── pyproject.toml
├── requirements.txt
├── requirements-dev.txt
└── README.md
```

### pyproject.toml

```toml
[project]
name = "myproject"
version = "0.1.0"
description = "A modern Python project"
requires-python = ">=3.13"
dependencies = [
    "requests>=2.31.0",
    "pydantic>=2.8.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=8.0.0",
    "ruff>=0.5.0",
    "mypy>=1.11.0",
]

[tool.ruff]
line-length = 100
target-version = "py313"

[tool.mypy]
python_version = "3.13"
strict = true
```

---

## Naming Conventions

- **Modules**: lowercase with underscores (`my_module.py`)
- **Packages**: lowercase, avoid underscores (`mypackage`)
- **Classes**: PascalCase (`MyClass`, `HTTPServer`)
- **Functions**: lowercase with underscores (`my_function`)
- **Variables**: lowercase with underscores (`my_variable`)
- **Constants**: SCREAMING_SNAKE_CASE (`MAX_SIZE`, `API_KEY`)
- **Private**: single leading underscore (`_private_method`)
- **Name mangling**: double leading underscore (`__very_private`)

---

## Type Hints (Python 3.13+)

### Basic Type Hints

```python
# Variables
name: str = "John"
age: int = 30
price: float = 19.99
is_active: bool = True

# Functions
def greet(name: str) -> str:
    return f"Hello, {name}"

def add(x: int, y: int) -> int:
    return x + y

# No return value
def log_message(message: str) -> None:
    print(message)
```

### Collections

```python
from collections.abc import Sequence, Mapping

# Lists
numbers: list[int] = [1, 2, 3]
names: list[str] = ["Alice", "Bob"]

# Tuples
point: tuple[int, int] = (10, 20)
record: tuple[str, int, bool] = ("Alice", 30, True)

# Dictionaries
scores: dict[str, int] = {"Alice": 100, "Bob": 95}
config: dict[str, str | int] = {"host": "localhost", "port": 8080}

# Sets
unique_ids: set[int] = {1, 2, 3}

# Sequences (generic)
def process(items: Sequence[str]) -> None:
    for item in items:
        print(item)
```

### Optional and Union Types

```python
# Optional (can be None)
def find_user(user_id: int) -> str | None:
    return None

# Union types (Python 3.10+ syntax)
def parse(value: str | int) -> int:
    return int(value)

# Multiple types
def process(data: str | bytes | bytearray) -> str:
    if isinstance(data, str):
        return data
    return data.decode()
```

### Generic Types

```python
from typing import TypeVar, Generic

T = TypeVar('T')

class Stack(Generic[T]):
    def __init__(self) -> None:
        self.items: list[T] = []
    
    def push(self, item: T) -> None:
        self.items.append(item)
    
    def pop(self) -> T:
        return self.items.pop()

# Usage
int_stack: Stack[int] = Stack()
int_stack.push(42)
```

### Callable Types

```python
from collections.abc import Callable

# Function type
def apply(func: Callable[[int, int], int], x: int, y: int) -> int:
    return func(x, y)

# With variable arguments
Handler = Callable[..., None]

def register_handler(handler: Handler) -> None:
    pass
```

### Type Aliases

```python
# Simple alias
UserId = int
Username = str

# Complex alias
JsonDict = dict[str, str | int | list | dict]
Coordinate = tuple[float, float]

# Generic alias
Vector = list[float]
Matrix = list[Vector]
```

---

## Classes and Objects

### Basic Class

```python
class User:
    """Represents a user in the system."""
    
    def __init__(self, name: str, email: str) -> None:
        self.name = name
        self.email = email
        self._created_at = datetime.now()  # Private
    
    def display(self) -> str:
        return f"{self.name} <{self.email}>"
    
    def __repr__(self) -> str:
        return f"User(name={self.name!r}, email={self.email!r})"
    
    def __str__(self) -> str:
        return self.display()
```

### Dataclasses (Python 3.7+)

```python
from dataclasses import dataclass, field
from datetime import datetime

@dataclass
class User:
    """User with automatic __init__, __repr__, __eq__."""
    name: str
    email: str
    created_at: datetime = field(default_factory=datetime.now)
    is_active: bool = True
    
    def display(self) -> str:
        return f"{self.name} <{self.email}>"

# Usage
user = User(name="Alice", email="alice@example.com")
```

### Properties

```python
class Circle:
    def __init__(self, radius: float) -> None:
        self._radius = radius
    
    @property
    def radius(self) -> float:
        """Get the radius."""
        return self._radius
    
    @radius.setter
    def radius(self, value: float) -> None:
        """Set the radius."""
        if value < 0:
            raise ValueError("Radius cannot be negative")
        self._radius = value
    
    @property
    def area(self) -> float:
        """Calculate area (read-only)."""
        return 3.14159 * self._radius ** 2
```

### Class Methods and Static Methods

```python
class User:
    _users: list['User'] = []
    
    def __init__(self, name: str) -> None:
        self.name = name
    
    @classmethod
    def from_dict(cls, data: dict[str, str]) -> 'User':
        """Alternative constructor."""
        return cls(name=data['name'])
    
    @staticmethod
    def validate_email(email: str) -> bool:
        """Utility function that doesn't need instance or class."""
        return '@' in email
    
    @classmethod
    def get_all_users(cls) -> list['User']:
        """Access class variable."""
        return cls._users
```

### Inheritance

```python
class Animal:
    def __init__(self, name: str) -> None:
        self.name = name
    
    def speak(self) -> str:
        raise NotImplementedError("Subclass must implement")

class Dog(Animal):
    def speak(self) -> str:
        return f"{self.name} says Woof!"

class Cat(Animal):
    def speak(self) -> str:
        return f"{self.name} says Meow!"

# Multiple inheritance
class Flyer:
    def fly(self) -> str:
        return "Flying!"

class Bird(Animal, Flyer):
    def speak(self) -> str:
        return f"{self.name} says Chirp!"
```

### Abstract Base Classes

```python
from abc import ABC, abstractmethod

class Storage(ABC):
    @abstractmethod
    def save(self, key: str, value: str) -> None:
        """Save a key-value pair."""
        pass
    
    @abstractmethod
    def load(self, key: str) -> str | None:
        """Load a value by key."""
        pass

class FileStorage(Storage):
    def save(self, key: str, value: str) -> None:
        with open(f"{key}.txt", "w") as f:
            f.write(value)
    
    def load(self, key: str) -> str | None:
        try:
            with open(f"{key}.txt", "r") as f:
                return f.read()
        except FileNotFoundError:
            return None
```

### Magic Methods

```python
class Vector:
    def __init__(self, x: float, y: float) -> None:
        self.x = x
        self.y = y
    
    def __repr__(self) -> str:
        return f"Vector({self.x}, {self.y})"
    
    def __str__(self) -> str:
        return f"({self.x}, {self.y})"
    
    def __add__(self, other: 'Vector') -> 'Vector':
        return Vector(self.x + other.x, self.y + other.y)
    
    def __eq__(self, other: object) -> bool:
        if not isinstance(other, Vector):
            return NotImplemented
        return self.x == other.x and self.y == other.y
    
    def __len__(self) -> int:
        return 2
    
    def __getitem__(self, index: int) -> float:
        if index == 0:
            return self.x
        elif index == 1:
            return self.y
        raise IndexError("Vector index out of range")
```

---

## Functions and Decorators

### Function Arguments

```python
# Positional and keyword arguments
def greet(name: str, greeting: str = "Hello") -> str:
    return f"{greeting}, {name}!"

# Variable positional arguments
def sum_all(*numbers: int) -> int:
    return sum(numbers)

# Variable keyword arguments
def create_user(**kwargs: str) -> dict[str, str]:
    return kwargs

# Keyword-only arguments (after *)
def divide(numerator: float, denominator: float, *, precision: int = 2) -> float:
    result = numerator / denominator
    return round(result, precision)

# Positional-only arguments (before /)
def power(base: float, exponent: float, /) -> float:
    return base ** exponent
```

### Lambda Functions

```python
# Simple lambda
add = lambda x, y: x + y

# In sorting
users = [("Alice", 30), ("Bob", 25), ("Charlie", 35)]
sorted_users = sorted(users, key=lambda user: user[1])

# In filter
evens = list(filter(lambda x: x % 2 == 0, range(10)))

# In map
doubled = list(map(lambda x: x * 2, range(5)))
```

### Decorators

```python
from functools import wraps
from time import time

# Simple decorator
def timer(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        start = time()
        result = func(*args, **kwargs)
        end = time()
        print(f"{func.__name__} took {end - start:.4f} seconds")
        return result
    return wrapper

# Usage
@timer
def slow_function():
    time.sleep(1)

# Decorator with arguments
def repeat(times: int):
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            for _ in range(times):
                result = func(*args, **kwargs)
            return result
        return wrapper
    return decorator

@repeat(3)
def greet(name: str) -> None:
    print(f"Hello, {name}")

# Class-based decorator
class Memoize:
    def __init__(self, func):
        self.func = func
        self.cache = {}
    
    def __call__(self, *args):
        if args not in self.cache:
            self.cache[args] = self.func(*args)
        return self.cache[args]

@Memoize
def fibonacci(n: int) -> int:
    if n < 2:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)
```

---

## Error Handling

### Basic Exception Handling

```python
# Try-except
try:
    result = 10 / 0
except ZeroDivisionError:
    print("Cannot divide by zero")

# Multiple exceptions
try:
    value = int(input())
except (ValueError, TypeError) as e:
    print(f"Invalid input: {e}")

# Catch all (use sparingly)
try:
    risky_operation()
except Exception as e:
    print(f"Error: {e}")

# Finally (always executes)
try:
    f = open("file.txt")
    data = f.read()
finally:
    f.close()

# Else (executes if no exception)
try:
    result = calculate()
except ValueError:
    print("Calculation failed")
else:
    print(f"Result: {result}")
```

### Custom Exceptions

```python
class ValidationError(Exception):
    """Raised when validation fails."""
    pass

class ConfigError(Exception):
    """Raised when configuration is invalid."""
    
    def __init__(self, key: str, message: str) -> None:
        self.key = key
        self.message = message
        super().__init__(f"Config error for '{key}': {message}")

# Usage
def validate_age(age: int) -> None:
    if age < 0:
        raise ValidationError("Age cannot be negative")
    if age > 150:
        raise ValidationError("Age is unrealistically high")

# Catching custom exceptions
try:
    validate_age(-5)
except ValidationError as e:
    print(e)
```

### Context Managers

```python
# Using context manager
with open("file.txt", "r") as f:
    data = f.read()

# Multiple context managers
with open("input.txt") as fin, open("output.txt", "w") as fout:
    fout.write(fin.read())

# Custom context manager (class-based)
class Timer:
    def __enter__(self):
        self.start = time.time()
        return self
    
    def __exit__(self, exc_type, exc_val, exc_tb):
        self.end = time.time()
        print(f"Elapsed: {self.end - self.start:.4f}s")
        return False  # Don't suppress exceptions

with Timer():
    time.sleep(1)

# Custom context manager (function-based)
from contextlib import contextmanager

@contextmanager
def temporary_file(filename: str):
    try:
        f = open(filename, "w")
        yield f
    finally:
        f.close()
        os.remove(filename)

with temporary_file("temp.txt") as f:
    f.write("temporary data")
```

---

## Collections and Data Structures

### Lists

```python
# Create
numbers = [1, 2, 3, 4, 5]
empty = []
mixed = [1, "two", 3.0, True]

# Access
first = numbers[0]
last = numbers[-1]
slice_result = numbers[1:4]  # [2, 3, 4]

# Modify
numbers.append(6)
numbers.extend([7, 8, 9])
numbers.insert(0, 0)
numbers.remove(3)  # Remove first 3
del numbers[0]
popped = numbers.pop()  # Remove and return last

# List comprehension
squares = [x**2 for x in range(10)]
evens = [x for x in range(10) if x % 2 == 0]
pairs = [(x, y) for x in range(3) for y in range(3)]

# Nested comprehension
matrix = [[i * j for j in range(3)] for i in range(3)]
```

### Dictionaries

```python
# Create
user = {"name": "Alice", "age": 30}
empty = {}
from_keys = dict.fromkeys(["a", "b", "c"], 0)

# Access
name = user["name"]
age = user.get("age", 0)  # With default

# Modify
user["email"] = "alice@example.com"
user.update({"age": 31, "city": "NYC"})
del user["age"]
removed = user.pop("city", None)

# Dict comprehension
squares = {x: x**2 for x in range(5)}
filtered = {k: v for k, v in user.items() if v is not None}

# Iterate
for key in user:
    print(key)

for value in user.values():
    print(value)

for key, value in user.items():
    print(f"{key}: {value}")

# Merge (Python 3.9+)
dict1 = {"a": 1, "b": 2}
dict2 = {"b": 3, "c": 4}
merged = dict1 | dict2  # {"a": 1, "b": 3, "c": 4}
```

### Sets

```python
# Create
numbers = {1, 2, 3, 4, 5}
empty = set()

# Add/remove
numbers.add(6)
numbers.remove(3)  # Raises KeyError if not found
numbers.discard(3)  # Safe removal

# Set operations
a = {1, 2, 3, 4}
b = {3, 4, 5, 6}

union = a | b
intersection = a & b
difference = a - b
symmetric_diff = a ^ b

# Set comprehension
squares = {x**2 for x in range(10)}
```

### Tuples

```python
# Create (immutable)
point = (10, 20)
single = (42,)  # Note the comma
empty = ()

# Named tuples
from collections import namedtuple

Point = namedtuple('Point', ['x', 'y'])
p = Point(10, 20)
print(p.x, p.y)

# Unpacking
x, y = point
first, *rest = (1, 2, 3, 4)  # first=1, rest=[2, 3, 4]
```

### Collections Module

```python
from collections import defaultdict, Counter, deque

# defaultdict
word_count = defaultdict(int)
word_count["hello"] += 1  # No KeyError

# Counter
words = ["apple", "banana", "apple", "cherry", "banana", "apple"]
counter = Counter(words)
print(counter.most_common(2))  # [('apple', 3), ('banana', 2)]

# deque (double-ended queue)
queue = deque([1, 2, 3])
queue.append(4)        # Add to right
queue.appendleft(0)    # Add to left
queue.pop()            # Remove from right
queue.popleft()        # Remove from left
```

---

## Iterators and Generators

### Iterators

```python
# Iterate over any iterable
for item in [1, 2, 3]:
    print(item)

# Manual iteration
it = iter([1, 2, 3])
print(next(it))  # 1
print(next(it))  # 2

# Custom iterator
class Counter:
    def __init__(self, max_count: int) -> None:
        self.max_count = max_count
        self.count = 0
    
    def __iter__(self):
        return self
    
    def __next__(self) -> int:
        if self.count >= self.max_count:
            raise StopIteration
        self.count += 1
        return self.count

for num in Counter(5):
    print(num)
```

### Generators

```python
# Generator function
def countdown(n: int):
    while n > 0:
        yield n
        n -= 1

for i in countdown(5):
    print(i)

# Generator expression
squares = (x**2 for x in range(10))

# Benefits: memory efficient, lazy evaluation
def read_large_file(file_path: str):
    with open(file_path) as f:
        for line in f:
            yield line.strip()

# Generator with send
def echo():
    while True:
        value = yield
        print(f"Received: {value}")

gen = echo()
next(gen)  # Prime the generator
gen.send("Hello")
```

### itertools

```python
from itertools import chain, cycle, islice, combinations, permutations

# Chain multiple iterables
combined = chain([1, 2], [3, 4], [5, 6])

# Cycle through iterable infinitely
cycled = cycle([1, 2, 3])
first_six = list(islice(cycled, 6))  # [1, 2, 3, 1, 2, 3]

# Combinations and permutations
items = ['A', 'B', 'C']
combos = list(combinations(items, 2))  # [('A', 'B'), ('A', 'C'), ('B', 'C')]
perms = list(permutations(items, 2))   # [('A', 'B'), ('A', 'C'), ...]
```

---

## File I/O

### Reading Files

```python
# Read entire file
with open("file.txt", "r") as f:
    content = f.read()

# Read lines
with open("file.txt", "r") as f:
    lines = f.readlines()

# Iterate over lines (memory efficient)
with open("file.txt", "r") as f:
    for line in f:
        print(line.strip())

# Read binary
with open("image.png", "rb") as f:
    data = f.read()
```

### Writing Files

```python
# Write (overwrite)
with open("file.txt", "w") as f:
    f.write("Hello, World!")

# Append
with open("file.txt", "a") as f:
    f.write("\nNew line")

# Write lines
lines = ["Line 1\n", "Line 2\n", "Line 3\n"]
with open("file.txt", "w") as f:
    f.writelines(lines)

# Write binary
with open("output.bin", "wb") as f:
    f.write(b"\x00\x01\x02")
```

### Path Operations

```python
from pathlib import Path

# Create Path object
path = Path("data/file.txt")

# Check existence
if path.exists():
    print("File exists")

# Read/write
content = path.read_text()
path.write_text("New content")

# Path operations
parent = path.parent
name = path.name
stem = path.stem
suffix = path.suffix

# Create directory
Path("data/logs").mkdir(parents=True, exist_ok=True)

# List directory
for file in Path("data").iterdir():
    if file.is_file():
        print(file)

# Glob patterns
for file in Path("data").glob("*.txt"):
    print(file)
```

---

## Async/Await (Python 3.5+)

### Basic Async

```python
import asyncio

async def fetch_data(url: str) -> str:
    await asyncio.sleep(1)  # Simulate network request
    return f"Data from {url}"

async def main():
    result = await fetch_data("https://example.com")
    print(result)

# Run
asyncio.run(main())
```

### Concurrent Tasks

```python
async def main():
    # Run concurrently
    results = await asyncio.gather(
        fetch_data("url1"),
        fetch_data("url2"),
        fetch_data("url3"),
    )
    print(results)

# Create tasks
async def main():
    task1 = asyncio.create_task(fetch_data("url1"))
    task2 = asyncio.create_task(fetch_data("url2"))
    
    result1 = await task1
    result2 = await task2
```

### Async Context Managers

```python
class AsyncResource:
    async def __aenter__(self):
        print("Acquiring resource")
        await asyncio.sleep(0.1)
        return self
    
    async def __aexit__(self, exc_type, exc_val, exc_tb):
        print("Releasing resource")
        await asyncio.sleep(0.1)

async def main():
    async with AsyncResource() as resource:
        print("Using resource")
```

### Async Iterators

```python
class AsyncCounter:
    def __init__(self, max_count: int) -> None:
        self.count = 0
        self.max_count = max_count
    
    def __aiter__(self):
        return self
    
    async def __anext__(self) -> int:
        if self.count >= self.max_count:
            raise StopAsyncIteration
        await asyncio.sleep(0.1)
        self.count += 1
        return self.count

async def main():
    async for num in AsyncCounter(5):
        print(num)
```

---

## Testing

### unittest

```python
import unittest

class TestMath(unittest.TestCase):
    def setUp(self):
        """Run before each test."""
        self.calculator = Calculator()
    
    def tearDown(self):
        """Run after each test."""
        pass
    
    def test_add(self):
        result = self.calculator.add(2, 3)
        self.assertEqual(result, 5)
    
    def test_divide_by_zero(self):
        with self.assertRaises(ZeroDivisionError):
            self.calculator.divide(10, 0)
    
    def test_values(self):
        self.assertTrue(True)
        self.assertFalse(False)
        self.assertIsNone(None)
        self.assertIn(3, [1, 2, 3])

if __name__ == "__main__":
    unittest.main()
```

### pytest

```python
# test_math.py
import pytest

def test_add():
    assert add(2, 3) == 5

def test_divide_by_zero():
    with pytest.raises(ZeroDivisionError):
        divide(10, 0)

# Fixtures
@pytest.fixture
def sample_data():
    return [1, 2, 3, 4, 5]

def test_sum(sample_data):
    assert sum(sample_data) == 15

# Parametrize
@pytest.mark.parametrize("a,b,expected", [
    (2, 3, 5),
    (0, 0, 0),
    (-1, 1, 0),
])
def test_add_parametrized(a, b, expected):
    assert add(a, b) == expected

# Run with: pytest test_math.py
```

### Mocking

```python
from unittest.mock import Mock, patch, MagicMock

# Mock object
mock = Mock()
mock.return_value = 42
result = mock()  # 42

# Mock method
mock.method.return_value = "mocked"
result = mock.method()  # "mocked"

# Patch function
with patch('module.function') as mock_func:
    mock_func.return_value = 100
    result = module.function()  # 100

# Patch decorator
@patch('module.api_call')
def test_function(mock_api):
    mock_api.return_value = {"status": "ok"}
    result = my_function()
    assert result == "ok"
```

---

## Common Patterns

### Context Manager Pattern

```python
from contextlib import contextmanager

@contextmanager
def managed_resource(*args, **kwargs):
    # Setup
    resource = acquire_resource(*args, **kwargs)
    try:
        yield resource
    finally:
        # Cleanup
        release_resource(resource)
```

### Singleton Pattern

```python
class Singleton:
    _instance = None
    
    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance

# Or use a module (Python modules are singletons)
```

### Factory Pattern

```python
class Animal:
    pass

class Dog(Animal):
    pass

class Cat(Animal):
    pass

class AnimalFactory:
    @staticmethod
    def create_animal(animal_type: str) -> Animal:
        if animal_type == "dog":
            return Dog()
        elif animal_type == "cat":
            return Cat()
        raise ValueError(f"Unknown animal type: {animal_type}")
```

### Observer Pattern

```python
class Subject:
    def __init__(self):
        self._observers = []
    
    def attach(self, observer):
        self._observers.append(observer)
    
    def detach(self, observer):
        self._observers.remove(observer)
    
    def notify(self, *args, **kwargs):
        for observer in self._observers:
            observer.update(*args, **kwargs)

class Observer:
    def update(self, *args, **kwargs):
        print(f"Received: {args}, {kwargs}")
```

---

## Best Practices

### Code Style

```python
# Use list comprehensions over loops when simple
squares = [x**2 for x in range(10)]

# Use enumerate instead of range(len())
for i, value in enumerate(my_list):
    print(f"{i}: {value}")

# Use zip to iterate over multiple sequences
for name, age in zip(names, ages):
    print(f"{name} is {age} years old")

# Use dict.get() with defaults
value = config.get("key", "default")

# Use f-strings for formatting
message = f"Hello, {name}! You are {age} years old."

# Use pathlib instead of os.path
from pathlib import Path
path = Path("data") / "file.txt"

# Use context managers
with open("file.txt") as f:
    data = f.read()

# Chain comparisons
if 0 <= x <= 100:
    print("In range")
```

### Pythonic Idioms

```python
# Check for empty sequences
if not my_list:
    print("Empty")

# Check for None
if value is None:
    print("None")

# Swap variables
a, b = b, a

# Multiple assignment
x, y, z = 1, 2, 3

# Extended unpacking
first, *middle, last = [1, 2, 3, 4, 5]

# Dictionary default
counts = {}
for item in items:
    counts[item] = counts.get(item, 0) + 1

# Or use defaultdict
from collections import defaultdict
counts = defaultdict(int)
for item in items:
    counts[item] += 1
```

### Performance Tips

```python
# Use generators for large datasets
def large_dataset():
    for i in range(1000000):
        yield i

# Use set for membership testing (O(1) vs O(n))
unique_items = set(items)
if item in unique_items:
    pass

# Use dict for lookups instead of lists
user_dict = {user.id: user for user in users}
user = user_dict.get(user_id)

# Use local variables (faster than global)
def process():
    local_func = some_function
    for item in items:
        local_func(item)

# Use __slots__ for memory optimization
class Point:
    __slots__ = ['x', 'y']
    
    def __init__(self, x, y):
        self.x = x
        self.y = y
```

---

## Common Tools

```bash
# Install packages
pip install requests
pip install -r requirements.txt

# Create virtual environment
python -m venv venv
source venv/bin/activate

# Format code (ruff)
ruff format .

# Lint code (ruff)
ruff check .
ruff check --fix .

# Type checking (mypy)
mypy src/

# Run tests
pytest
pytest -v
pytest --cov=src

# Run specific test
pytest tests/test_module.py::test_function

# Generate requirements
pip freeze > requirements.txt

# Install in editable mode
pip install -e .
```

---

## Documentation

```python
def calculate_total(items: list[float], tax_rate: float = 0.1) -> float:
    """
    Calculate the total cost including tax.
    
    Args:
        items: List of item prices
        tax_rate: Tax rate as a decimal (default: 0.1)
    
    Returns:
        Total cost including tax
    
    Raises:
        ValueError: If tax_rate is negative
    
    Examples:
        >>> calculate_total([10.0, 20.0], 0.1)
        33.0
    """
    if tax_rate < 0:
        raise ValueError("Tax rate cannot be negative")
    
    subtotal = sum(items)
    return subtotal * (1 + tax_rate)
```

---

## Checklist

- [ ] Using Python 3.13+ features
- [ ] Type hints for all function signatures
- [ ] Docstrings for all public functions and classes
- [ ] Following PEP 8 style guide
- [ ] Using f-strings for string formatting
- [ ] Using pathlib for file paths
- [ ] Using context managers for resources
- [ ] Using dataclasses for simple data containers
- [ ] Proper exception handling (no bare except)
- [ ] Tests cover main functionality
- [ ] Code passes ruff checks
- [ ] Code passes mypy type checking
- [ ] No unused imports
- [ ] Using list/dict comprehensions where appropriate
- [ ] Using generators for large datasets