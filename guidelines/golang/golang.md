# Go Programming Guidelines

## Philosophy

Write idiomatic Go for version 1.23+. Embrace simplicity, readability, and composition. Follow Go proverbs: clear is better than clever, interfaces are small, errors are values.

---

## Project Setup

### Creating a New Project

```bash
# Initialize module
go mod init github.com/username/project-name

# Add dependencies
go get github.com/pkg/errors

# Tidy dependencies
go mod tidy
```

### Project Structure

```
myproject/
├── cmd/
│   └── myapp/
│       └── main.go
├── internal/
│   ├── config/
│   ├── handler/
│   └── service/
├── pkg/
│   └── api/
├── go.mod
├── go.sum
└── README.md
```

- `cmd/` — Main applications
- `internal/` — Private code (not importable)
- `pkg/` — Public libraries (can be imported)

### go.mod

```go
module github.com/username/myproject

go 1.23

require (
    github.com/pkg/errors v0.9.1
    golang.org/x/sync v0.8.0
)
```

---

## Naming Conventions

- **Packages**: lowercase, single word, no underscores (`http`, `context`)
- **Files**: lowercase with underscores (`http_server.go`)
- **Types**: PascalCase (`HTTPServer`, `User`)
- **Functions**: PascalCase for exported, camelCase for unexported (`GetUser`, `parseInput`)
- **Variables**: camelCase (`userCount`, `maxRetries`)
- **Constants**: PascalCase or camelCase, not SCREAMING_CASE (`MaxConnections`, `defaultTimeout`)
- **Interfaces**: `-er` suffix when single method (`Reader`, `Writer`, `Closer`)
- **Acronyms**: All caps or all lowercase (`HTTPServer`, `httpClient`, `userID`)

---

## Package Organization

### Main Package

```go
// cmd/myapp/main.go
package main

import (
    "fmt"
    "log"
    
    "github.com/username/myproject/internal/config"
    "github.com/username/myproject/internal/service"
)

func main() {
    cfg := config.Load()
    svc := service.New(cfg)
    
    if err := svc.Run(); err != nil {
        log.Fatal(err)
    }
}
```

### Internal Package

```go
// internal/service/service.go
package service

type Service struct {
    config *config.Config
}

func New(cfg *config.Config) *Service {
    return &Service{config: cfg}
}

func (s *Service) Run() error {
    // Implementation
    return nil
}
```

---

## Variables and Constants

### Declaration

```go
// Variable declaration with type
var name string = "John"

// Type inference
var age = 30

// Short declaration (inside functions only)
count := 0

// Multiple variables
var (
    host = "localhost"
    port = 8080
    timeout = 30 * time.Second
)

// Constants
const MaxRetries = 3
const (
    StatusPending = "pending"
    StatusActive  = "active"
    StatusClosed  = "closed"
)

// Typed constants
const Port int = 8080
```

### Zero Values

```go
var i int       // 0
var f float64   // 0.0
var b bool      // false
var s string    // ""
var p *int      // nil
var slice []int // nil
var m map[string]int // nil
```

### iota (Enumeration)

```go
type Status int

const (
    StatusPending Status = iota  // 0
    StatusActive                 // 1
    StatusClosed                 // 2
)

// Skip values
const (
    _ = iota  // 0
    KB = 1 << (10 * iota)  // 1024
    MB                      // 1048576
    GB                      // 1073741824
)
```

---

## Types

### Basic Types

```go
// Integers
var i8 int8     // -128 to 127
var u8 uint8    // 0 to 255
var i32 int32
var u32 uint32
var i64 int64
var u64 uint64

// Floating point
var f32 float32
var f64 float64

// Complex
var c64 complex64
var c128 complex128

// String
var s string

// Boolean
var b bool

// Byte (alias for uint8)
var b byte

// Rune (alias for int32, Unicode code point)
var r rune
```

### Structs

```go
// Struct definition
type User struct {
    ID        int
    Name      string
    Email     string
    CreatedAt time.Time
    isActive  bool  // unexported field
}

// Constructor
func NewUser(name, email string) *User {
    return &User{
        Name:      name,
        Email:     email,
        CreatedAt: time.Now(),
        isActive:  true,
    }
}

// Methods
func (u *User) Activate() {
    u.isActive = true
}

func (u *User) IsActive() bool {
    return u.isActive
}

// Struct embedding (composition)
type Admin struct {
    User
    Permissions []string
}

// Instantiation
user := User{
    Name:  "John",
    Email: "john@example.com",
}

// With named fields (preferred)
user := User{
    ID:    1,
    Name:  "John",
    Email: "john@example.com",
}
```

### Interfaces

```go
// Interface definition
type Reader interface {
    Read(p []byte) (n int, err error)
}

type Writer interface {
    Write(p []byte) (n int, err error)
}

// Composed interface
type ReadWriter interface {
    Reader
    Writer
}

// Empty interface (any type)
var anything interface{}
var anything any  // Go 1.18+ alias

// Type assertion
var i interface{} = "hello"
s := i.(string)

// Type assertion with check
s, ok := i.(string)
if ok {
    fmt.Println(s)
}

// Type switch
func describe(i interface{}) {
    switch v := i.(type) {
    case int:
        fmt.Printf("Integer: %d\n", v)
    case string:
        fmt.Printf("String: %s\n", v)
    case bool:
        fmt.Printf("Boolean: %v\n", v)
    default:
        fmt.Printf("Unknown type: %T\n", v)
    }
}
```

---

## Functions

### Basic Functions

```go
// Simple function
func add(x, y int) int {
    return x + y
}

// Multiple return values
func divide(x, y float64) (float64, error) {
    if y == 0 {
        return 0, errors.New("division by zero")
    }
    return x / y, nil
}

// Named return values
func split(sum int) (x, y int) {
    x = sum * 4 / 9
    y = sum - x
    return  // naked return
}

// Variadic function
func sum(numbers ...int) int {
    total := 0
    for _, n := range numbers {
        total += n
    }
    return total
}

// Function as value
var add = func(x, y int) int {
    return x + y
}
```

### Methods

```go
// Value receiver
func (u User) GetName() string {
    return u.Name
}

// Pointer receiver (can modify)
func (u *User) SetName(name string) {
    u.Name = name
}

// Use pointer receivers when:
// - Method modifies the receiver
// - Receiver is large (avoid copying)
// - Consistency (if one method uses pointer, all should)
```

### Defer

```go
// Defer executes after surrounding function returns
func process() error {
    f, err := os.Open("file.txt")
    if err != nil {
        return err
    }
    defer f.Close()  // Guaranteed to run
    
    // Work with file
    return nil
}

// Multiple defers (LIFO order)
func example() {
    defer fmt.Println("1")
    defer fmt.Println("2")
    defer fmt.Println("3")
    // Prints: 3, 2, 1
}
```

---

## Error Handling

### Basic Error Handling

```go
// Return error
func divide(x, y float64) (float64, error) {
    if y == 0 {
        return 0, errors.New("cannot divide by zero")
    }
    return x / y, nil
}

// Check error
result, err := divide(10, 0)
if err != nil {
    log.Fatal(err)
}

// Formatted error
return fmt.Errorf("failed to process user %d: %w", userID, err)
```

### Custom Errors

```go
// Custom error type
type ValidationError struct {
    Field   string
    Message string
}

func (e *ValidationError) Error() string {
    return fmt.Sprintf("validation error on %s: %s", e.Field, e.Message)
}

// Using custom error
func validate(user *User) error {
    if user.Email == "" {
        return &ValidationError{
            Field:   "email",
            Message: "email is required",
        }
    }
    return nil
}

// Check error type
if err := validate(user); err != nil {
    var valErr *ValidationError
    if errors.As(err, &valErr) {
        fmt.Printf("Validation failed on %s\n", valErr.Field)
    }
}
```

### Error Wrapping (Go 1.13+)

```go
// Wrap error
if err != nil {
    return fmt.Errorf("failed to open file: %w", err)
}

// Unwrap
err := someFunction()
originalErr := errors.Unwrap(err)

// Check if error is specific type
if errors.Is(err, os.ErrNotExist) {
    // Handle file not found
}

// Extract error type
var pathErr *os.PathError
if errors.As(err, &pathErr) {
    fmt.Println(pathErr.Path)
}
```

### Panic and Recover

```go
// Panic (use sparingly, only for unrecoverable errors)
func mustConnect(addr string) *Connection {
    conn, err := connect(addr)
    if err != nil {
        panic(fmt.Sprintf("failed to connect: %v", err))
    }
    return conn
}

// Recover from panic
func safeExecute(fn func()) (err error) {
    defer func() {
        if r := recover(); r != nil {
            err = fmt.Errorf("panic recovered: %v", r)
        }
    }()
    
    fn()
    return nil
}
```

---

## Control Flow

### If Statement

```go
// Basic if
if x > 0 {
    fmt.Println("positive")
}

// If-else
if x > 0 {
    fmt.Println("positive")
} else {
    fmt.Println("non-positive")
}

// If with initialization
if err := doSomething(); err != nil {
    return err
}

// If-else if-else
if x > 0 {
    fmt.Println("positive")
} else if x < 0 {
    fmt.Println("negative")
} else {
    fmt.Println("zero")
}
```

### Switch Statement

```go
// Basic switch
switch day {
case "Monday":
    fmt.Println("Start of week")
case "Friday":
    fmt.Println("End of week")
default:
    fmt.Println("Midweek")
}

// Multiple cases
switch day {
case "Saturday", "Sunday":
    fmt.Println("Weekend")
default:
    fmt.Println("Weekday")
}

// Switch with initialization
switch err := doSomething(); err {
case nil:
    fmt.Println("Success")
default:
    fmt.Printf("Error: %v\n", err)
}

// Switch without condition (like if-else chain)
switch {
case x > 0:
    fmt.Println("positive")
case x < 0:
    fmt.Println("negative")
default:
    fmt.Println("zero")
}

// Type switch
switch v := value.(type) {
case int:
    fmt.Printf("Integer: %d\n", v)
case string:
    fmt.Printf("String: %s\n", v)
default:
    fmt.Printf("Unknown: %T\n", v)
}
```

### For Loop

```go
// Classic for loop
for i := 0; i < 10; i++ {
    fmt.Println(i)
}

// While-style loop
for condition {
    // Loop body
}

// Infinite loop
for {
    // Loop body
    if done {
        break
    }
}

// Range over slice
numbers := []int{1, 2, 3, 4, 5}
for i, num := range numbers {
    fmt.Printf("%d: %d\n", i, num)
}

// Range over map
m := map[string]int{"a": 1, "b": 2}
for key, value := range m {
    fmt.Printf("%s: %d\n", key, value)
}

// Ignore index/value with underscore
for _, value := range numbers {
    fmt.Println(value)
}

// Continue and break
for i := 0; i < 10; i++ {
    if i%2 == 0 {
        continue  // Skip even numbers
    }
    if i > 7 {
        break  // Stop at 7
    }
    fmt.Println(i)
}
```

---

## Collections

### Arrays

```go
// Fixed-size array
var arr [5]int
arr[0] = 1

// Array literal
arr := [5]int{1, 2, 3, 4, 5}

// Infer length
arr := [...]int{1, 2, 3, 4, 5}

// Iterate
for i, v := range arr {
    fmt.Printf("%d: %d\n", i, v)
}
```

### Slices

```go
// Create slice
var s []int                 // nil slice
s := []int{}                // empty slice
s := []int{1, 2, 3}         // slice literal
s := make([]int, 5)         // length 5, capacity 5
s := make([]int, 5, 10)     // length 5, capacity 10

// Append
s = append(s, 4)
s = append(s, 5, 6, 7)
s = append(s, otherSlice...)

// Slice operations
s[1:3]    // elements 1 and 2
s[:3]     // first 3 elements
s[2:]     // from element 2 to end
s[:]      // entire slice

// Length and capacity
len(s)    // number of elements
cap(s)    // capacity

// Copy
dst := make([]int, len(src))
copy(dst, src)

// Remove element
s = append(s[:i], s[i+1:]...)

// Filter
var filtered []int
for _, v := range numbers {
    if v > 10 {
        filtered = append(filtered, v)
    }
}
```

### Maps

```go
// Create map
var m map[string]int                    // nil map
m := map[string]int{}                   // empty map
m := make(map[string]int)               // empty map
m := map[string]int{"a": 1, "b": 2}     // map literal

// Set value
m["key"] = 42

// Get value
value := m["key"]

// Check if key exists
value, ok := m["key"]
if ok {
    fmt.Println(value)
}

// Delete key
delete(m, "key")

// Iterate
for key, value := range m {
    fmt.Printf("%s: %d\n", key, value)
}

// Length
len(m)
```

---

## Pointers

```go
// Create pointer
var p *int
i := 42
p = &i

// Dereference pointer
fmt.Println(*p)  // Read value
*p = 21          // Set value

// Nil pointer
var p *int       // p is nil
if p != nil {
    fmt.Println(*p)
}

// Pointer to struct
u := &User{Name: "John"}
u.Name = "Jane"  // Automatic dereferencing

// New (allocates zero value)
p := new(int)    // *p is 0
u := new(User)   // All fields are zero values
```

---

## Goroutines and Concurrency

### Goroutines

```go
// Start goroutine
go doSomething()

// Goroutine with anonymous function
go func() {
    fmt.Println("Running in goroutine")
}()

// Pass data to goroutine
go func(msg string) {
    fmt.Println(msg)
}("Hello")
```

### Channels

```go
// Create channel
ch := make(chan int)
ch := make(chan int, 10)  // Buffered channel

// Send to channel
ch <- 42

// Receive from channel
value := <-ch

// Close channel
close(ch)

// Check if closed
value, ok := <-ch
if !ok {
    fmt.Println("Channel closed")
}

// Range over channel
for value := range ch {
    fmt.Println(value)
}

// Select (multiple channels)
select {
case msg1 := <-ch1:
    fmt.Println("Received from ch1:", msg1)
case msg2 := <-ch2:
    fmt.Println("Received from ch2:", msg2)
case ch3 <- value:
    fmt.Println("Sent to ch3")
default:
    fmt.Println("No communication")
}

// Timeout pattern
select {
case result := <-ch:
    fmt.Println(result)
case <-time.After(5 * time.Second):
    fmt.Println("Timeout")
}
```

### WaitGroup

```go
import "sync"

var wg sync.WaitGroup

for i := 0; i < 5; i++ {
    wg.Add(1)
    go func(id int) {
        defer wg.Done()
        fmt.Printf("Worker %d\n", id)
    }(i)
}

wg.Wait()
```

### Mutex

```go
import "sync"

type Counter struct {
    mu    sync.Mutex
    value int
}

func (c *Counter) Increment() {
    c.mu.Lock()
    defer c.mu.Unlock()
    c.value++
}

func (c *Counter) Value() int {
    c.mu.Lock()
    defer c.mu.Unlock()
    return c.value
}
```

### RWMutex

```go
type Cache struct {
    mu   sync.RWMutex
    data map[string]string
}

func (c *Cache) Get(key string) string {
    c.mu.RLock()
    defer c.mu.RUnlock()
    return c.data[key]
}

func (c *Cache) Set(key, value string) {
    c.mu.Lock()
    defer c.mu.Unlock()
    c.data[key] = value
}
```

### Once

```go
var once sync.Once

func initialize() {
    once.Do(func() {
        fmt.Println("Initialized once")
    })
}
```

### Context

```go
import "context"

// Create context
ctx := context.Background()
ctx := context.TODO()

// With timeout
ctx, cancel := context.WithTimeout(ctx, 5*time.Second)
defer cancel()

// With deadline
deadline := time.Now().Add(10 * time.Second)
ctx, cancel := context.WithDeadline(ctx, deadline)
defer cancel()

// With cancellation
ctx, cancel := context.WithCancel(ctx)
defer cancel()

// With value
ctx := context.WithValue(ctx, "key", "value")
value := ctx.Value("key").(string)

// Use in function
func doWork(ctx context.Context) error {
    select {
    case <-time.After(2 * time.Second):
        return nil
    case <-ctx.Done():
        return ctx.Err()
    }
}
```

---

## Generics (Go 1.18+)

### Generic Functions

```go
// Generic function
func Min[T constraints.Ordered](a, b T) T {
    if a < b {
        return a
    }
    return b
}

// Usage
minInt := Min(3, 5)
minFloat := Min(3.14, 2.71)
minString := Min("apple", "banana")

// Multiple type parameters
func Map[T, U any](slice []T, fn func(T) U) []U {
    result := make([]U, len(slice))
    for i, v := range slice {
        result[i] = fn(v)
    }
    return result
}
```

### Generic Types

```go
// Generic struct
type Stack[T any] struct {
    items []T
}

func (s *Stack[T]) Push(item T) {
    s.items = append(s.items, item)
}

func (s *Stack[T]) Pop() (T, bool) {
    if len(s.items) == 0 {
        var zero T
        return zero, false
    }
    item := s.items[len(s.items)-1]
    s.items = s.items[:len(s.items)-1]
    return item, true
}

// Usage
stack := Stack[int]{}
stack.Push(1)
stack.Push(2)
value, ok := stack.Pop()
```

### Constraints

```go
import "golang.org/x/exp/constraints"

// Use built-in constraints
func Sum[T constraints.Integer](numbers []T) T {
    var sum T
    for _, n := range numbers {
        sum += n
    }
    return sum
}

// Custom constraint
type Number interface {
    int | int64 | float64
}

func Add[T Number](a, b T) T {
    return a + b
}

// Constraint with methods
type Stringer interface {
    String() string
}

func Print[T Stringer](items []T) {
    for _, item := range items {
        fmt.Println(item.String())
    }
}
```

---

## Standard Library Patterns

### io Package

```go
import "io"

// Reader
func readData(r io.Reader) ([]byte, error) {
    data, err := io.ReadAll(r)
    return data, err
}

// Writer
func writeData(w io.Writer, data []byte) error {
    _, err := w.Write(data)
    return err
}

// Copy
_, err := io.Copy(dst, src)
```

### http Package

```go
import "net/http"

// HTTP server
func main() {
    http.HandleFunc("/", handleRoot)
    http.HandleFunc("/api/users", handleUsers)
    
    if err := http.ListenAndServe(":8080", nil); err != nil {
        log.Fatal(err)
    }
}

func handleRoot(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "Hello, World!")
}

// HTTP client
resp, err := http.Get("https://api.example.com/data")
if err != nil {
    return err
}
defer resp.Body.Close()

body, err := io.ReadAll(resp.Body)
```

### json Package

```go
import "encoding/json"

// Marshal (struct to JSON)
user := User{Name: "John", Email: "john@example.com"}
data, err := json.Marshal(user)

// MarshalIndent (pretty print)
data, err := json.MarshalIndent(user, "", "  ")

// Unmarshal (JSON to struct)
var user User
err := json.Unmarshal(data, &user)

// JSON tags
type User struct {
    Name  string `json:"name"`
    Email string `json:"email,omitempty"`
    Age   int    `json:"-"`  // Ignored
}
```

### time Package

```go
import "time"

// Current time
now := time.Now()

// Parse time
t, err := time.Parse("2006-01-02", "2024-03-15")

// Format time
formatted := now.Format("2006-01-02 15:04:05")

// Duration
duration := 5 * time.Second
time.Sleep(duration)

// Timer
timer := time.NewTimer(5 * time.Second)
<-timer.C

// Ticker
ticker := time.NewTicker(1 * time.Second)
defer ticker.Stop()
for range ticker.C {
    fmt.Println("Tick")
}
```

---

## Testing

### Basic Tests

```go
// mypackage_test.go
package mypackage

import "testing"

func TestAdd(t *testing.T) {
    result := Add(2, 3)
    expected := 5
    
    if result != expected {
        t.Errorf("Add(2, 3) = %d; want %d", result, expected)
    }
}

// Table-driven tests
func TestAddTable(t *testing.T) {
    tests := []struct {
        name     string
        a, b     int
        expected int
    }{
        {"positive", 2, 3, 5},
        {"negative", -2, -3, -5},
        {"mixed", -2, 3, 1},
    }
    
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            result := Add(tt.a, tt.b)
            if result != tt.expected {
                t.Errorf("got %d, want %d", result, tt.expected)
            }
        })
    }
}

// Helper functions
func TestHelper(t *testing.T) {
    helper := func(t *testing.T, input, expected int) {
        t.Helper()
        result := Double(input)
        if result != expected {
            t.Errorf("got %d, want %d", result, expected)
        }
    }
    
    helper(t, 2, 4)
    helper(t, 5, 10)
}
```

### Benchmarks

```go
func BenchmarkAdd(b *testing.B) {
    for i := 0; i < b.N; i++ {
        Add(2, 3)
    }
}

// Run with: go test -bench=.
```

### Examples

```go
func ExampleAdd() {
    result := Add(2, 3)
    fmt.Println(result)
    // Output: 5
}
```

---

## Common Patterns

### Options Pattern

```go
type Server struct {
    host    string
    port    int
    timeout time.Duration
}

type Option func(*Server)

func WithHost(host string) Option {
    return func(s *Server) {
        s.host = host
    }
}

func WithPort(port int) Option {
    return func(s *Server) {
        s.port = port
    }
}

func NewServer(opts ...Option) *Server {
    s := &Server{
        host:    "localhost",
        port:    8080,
        timeout: 30 * time.Second,
    }
    
    for _, opt := range opts {
        opt(s)
    }
    
    return s
}

// Usage
server := NewServer(
    WithHost("0.0.0.0"),
    WithPort(3000),
)
```

### Worker Pool

```go
func worker(id int, jobs <-chan int, results chan<- int) {
    for job := range jobs {
        fmt.Printf("Worker %d processing job %d\n", id, job)
        results <- job * 2
    }
}

func main() {
    jobs := make(chan int, 100)
    results := make(chan int, 100)
    
    // Start workers
    for w := 1; w <= 3; w++ {
        go worker(w, jobs, results)
    }
    
    // Send jobs
    for j := 1; j <= 9; j++ {
        jobs <- j
    }
    close(jobs)
    
    // Collect results
    for a := 1; a <= 9; a++ {
        <-results
    }
}
```

### Pipeline Pattern

```go
func generator(nums ...int) <-chan int {
    out := make(chan int)
    go func() {
        for _, n := range nums {
            out <- n
        }
        close(out)
    }()
    return out
}

func square(in <-chan int) <-chan int {
    out := make(chan int)
    go func() {
        for n := range in {
            out <- n * n
        }
        close(out)
    }()
    return out
}

func main() {
    // Pipeline: generate -> square
    for n := range square(generator(1, 2, 3, 4)) {
        fmt.Println(n)
    }
}
```

---

## Best Practices

### Error Handling

```go
// Always check errors
if err != nil {
    return err
}

// Don't use panic for normal errors
// Bad
if err != nil {
    panic(err)
}

// Good
if err != nil {
    return fmt.Errorf("operation failed: %w", err)
}

// Wrap errors with context
if err != nil {
    return fmt.Errorf("failed to process user %d: %w", userID, err)
}
```

### Interface Usage

```go
// Accept interfaces, return structs
func ProcessData(r io.Reader) (*Result, error) {
    // Implementation
}

// Keep interfaces small
type Storer interface {
    Store(key, value string) error
}

// Define interfaces where they are used (not where implemented)
// Bad: defining interface in implementation package
// Good: define in consumer package
```

### Struct Initialization

```go
// Use constructors for complex initialization
func NewServer(addr string) *Server {
    return &Server{
        addr:    addr,
        timeout: 30 * time.Second,
        clients: make(map[string]*Client),
    }
}

// Use named fields
user := User{
    Name:  "John",
    Email: "john@example.com",
}
```

### Avoid Global State

```go
// Bad
var db *sql.DB

func init() {
    db = connectDB()
}

// Good
type Service struct {
    db *sql.DB
}

func NewService(db *sql.DB) *Service {
    return &Service{db: db}
}
```

### Use Context

```go
// Pass context as first parameter
func ProcessRequest(ctx context.Context, data []byte) error {
    // Implementation
}

// Respect context cancellation
func worker(ctx context.Context) error {
    for {
        select {
        case <-ctx.Done():
            return ctx.Err()
        default:
            // Do work
        }
    }
}
```

---

## Common Tools

```bash
# Format code
go fmt ./...
gofmt -w .

# Import management
goimports -w .

# Linting
golangci-lint run

# Static analysis
go vet ./...

# Build
go build
go build -o myapp cmd/myapp/main.go

# Run
go run main.go
go run cmd/myapp/main.go

# Test
go test ./...
go test -v ./...
go test -cover ./...
go test -race ./...

# Benchmark
go test -bench=.
go test -bench=. -benchmem

# Get dependencies
go get github.com/pkg/errors
go get -u github.com/pkg/errors  # Update

# Tidy dependencies
go mod tidy

# Vendor dependencies
go mod vendor

# Generate code
go generate ./...

# Profile
go test -cpuprofile=cpu.prof -memprofile=mem.prof
go tool pprof cpu.prof
```

---

## Documentation

```go
// Package-level documentation
// Package mypackage provides utilities for data processing.
//
// This package includes functions for parsing, validating,
// and transforming data from various sources.
package mypackage

// Function documentation
// ProcessData processes the input data and returns the result.
//
// The function validates the input, applies transformations,
// and returns an error if any step fails.
//
// Example:
//
//     result, err := ProcessData(data)
//     if err != nil {
//         log.Fatal(err)
//     }
func ProcessData(data []byte) (*Result, error) {
    // Implementation
    return nil, nil
}

// Type documentation
// User represents a user in the system.
type User struct {
    // ID is the unique identifier for the user.
    ID int
    
    // Name is the user's full name.
    Name string
}
```

---

## Performance Tips

### Preallocate Slices

```go
// Bad
var users []User
for i := 0; i < 1000; i++ {
    users = append(users, User{ID: i})
}

// Good
users := make([]User, 0, 1000)
for i := 0; i < 1000; i++ {
    users = append(users, User{ID: i})
}
```

### Use Pointers for Large Structs

```go
// Bad (copying large struct)
func process(data LargeStruct) {
    // ...
}

// Good (passing pointer)
func process(data *LargeStruct) {
    // ...
}
```

### Avoid String Concatenation in Loops

```go
// Bad
var result string
for _, s := range strings {
    result += s
}

// Good
var builder strings.Builder
for _, s := range strings {
    builder.WriteString(s)
}
result := builder.String()
```

### Use sync.Pool for Frequent Allocations

```go
var bufferPool = sync.Pool{
    New: func() interface{} {
        return new(bytes.Buffer)
    },
}

func process() {
    buf := bufferPool.Get().(*bytes.Buffer)
    defer bufferPool.Put(buf)
    buf.Reset()
    
    // Use buffer
}
```

---

## Checklist

- [ ] Using Go 1.23+ features
- [ ] Code is formatted with `gofmt`
- [ ] Imports are organized with `goimports`
- [ ] All errors are checked and handled
- [ ] Errors are wrapped with context using `%w`
- [ ] No naked returns in long functions
- [ ] Exported functions and types are documented
- [ ] Using pointer receivers consistently
- [ ] No global mutable state
- [ ] Context is passed as first parameter
- [ ] Interfaces are small and focused
- [ ] Tests follow table-driven pattern
- [ ] Goroutines are properly synchronized
- [ ] Channels are properly closed
- [ ] Resources are cleaned up with defer
- [ ] Code passes `go vet`
- [ ] Code passes `golangci-lint`
- [ ] No race conditions (`go test -race`)