# Java guidelines

## Code Style and Standards
- Follow existing code patterns and conventions in the project
- Use Java 21 features appropriately
- Follow Spring Boot and Spring WebFlux best practices
- Maintain reactive programming patterns (Mono/Flux)
- Use MapStruct for DTO mapping
- Apply proper error handling with Zalando Problem library

## Commit Instructions
### Before Committing
```bash
# Build and test
mvn clean verify

# Check code style
mvn checkstyle:check

# Run Sonar analysis (if available)
mvn sonar:sonar
```


## Testing Guidelines

### Test Structure
- Unit tests in `src/test/java`
- Test resources in `src/test/resources`
- Use JUnit 5 and Spring Boot Test
- Use Reactor Test for reactive code (StepVerifier)

### Running Tests
```bash
# All tests
mvn test

# Specific test class
mvn test -Dtest=BusServiceTest

# Integration tests
mvn verify
```

---

## Build and Release Process

### Local Build
```bash
# Clean build
mvn clean package

# Skip tests
mvn package -DskipTests

# With CNES profile
mvn package -s settings_maven.xml -P CNES
```

### Version Management
Versions managed in parent POM:
- Development: `99.9.9-SNAPSHOT`
- Release: Update to specific version (e.g., `1.2.3`)

### Docker Build
```bash
cd sds-ope-bootstrap/src/main/docker
./build.sh
```

## Dependency Update
When POM dependencies change:
```bash
# 1. Extract key dependencies
mvn dependency:tree | grep -E "compile|runtime"

# 2. Update "Moyens" section with new versions
# 3. Update "Composition" section for major component changes
```