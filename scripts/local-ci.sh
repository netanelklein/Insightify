#!/bin/bash

# Local CI/CD Testing Script
# This script helps test the CI/CD pipeline locally before pushing to GitHub

set -e

echo "🚀 Insightify Local CI/CD Testing Script"
echo "========================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Flutter is installed
check_flutter() {
    print_status "Checking Flutter installation..."
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter is not installed or not in PATH"
        exit 1
    fi
    
    FLUTTER_VERSION=$(flutter --version | head -n 1)
    print_success "Flutter found: $FLUTTER_VERSION"
}

# Check Flutter doctor
check_flutter_doctor() {
    print_status "Running Flutter doctor..."
    flutter doctor
    echo
}

# Clean and get dependencies
setup_dependencies() {
    print_status "Setting up dependencies..."
    flutter clean
    flutter pub get
    print_success "Dependencies setup complete"
}

# Create development secrets file
create_dev_secrets() {
    print_status "Creating development secrets file..."
    mkdir -p lib/auth
    
    if [ ! -f "lib/auth/secrets.dart" ]; then
        cat > lib/auth/secrets.dart << EOF
class Secrets {
  static const String spotifyClientId = 'dev_client_id';
  static const String spotifyClientSecret = 'dev_client_secret';
  static const String spotifyRedirectUri = 'insightify://callback';
}
EOF
        print_success "Development secrets file created"
    else
        print_warning "Secrets file already exists, skipping creation"
    fi
}

# Run code formatting check
check_formatting() {
    print_status "Checking code formatting..."
    if dart format --output=none --set-exit-if-changed .; then
        print_success "Code formatting check passed"
    else
        print_error "Code formatting check failed"
        echo "Run 'dart format .' to fix formatting issues"
        return 1
    fi
}

# Run static analysis
run_analysis() {
    print_status "Running static analysis..."
    if flutter analyze; then
        print_success "Static analysis passed"
    else
        print_error "Static analysis failed"
        return 1
    fi
}

# Run tests
run_tests() {
    print_status "Running tests..."
    if flutter test --coverage; then
        print_success "All tests passed"
        
        # Show coverage summary if lcov is available
        if command -v lcov &> /dev/null; then
            print_status "Generating coverage summary..."
            lcov --summary coverage/lcov.info
        fi
    else
        print_error "Tests failed"
        return 1
    fi
}

# Build different flavors
build_flavors() {
    print_status "Building different flavors..."
    
    # Build debug APK for dev flavor
    print_status "Building dev flavor (debug)..."
    if flutter build apk --debug --flavor dev; then
        print_success "Dev flavor build successful"
    else
        print_error "Dev flavor build failed"
        return 1
    fi
    
    # Build release APK for dev flavor
    print_status "Building dev flavor (release)..."
    if flutter build apk --release --flavor dev; then
        print_success "Dev flavor release build successful"
    else
        print_error "Dev flavor release build failed"
        return 1
    fi
    
    print_warning "Note: Prod flavor build requires proper signing configuration"
}

# Check for security issues
security_check() {
    print_status "Running basic security checks..."
    
    # Check for hardcoded secrets
    if grep -r "sk_" lib/ 2>/dev/null || grep -r "pk_" lib/ 2>/dev/null; then
        print_error "Potential hardcoded API keys found!"
        return 1
    fi
    
    # Check if secrets.dart is in gitignore
    if grep -q "lib/auth/secrets.dart" .gitignore; then
        print_success "Secrets file is properly gitignored"
    else
        print_warning "Secrets file should be added to .gitignore"
    fi
    
    print_success "Basic security checks passed"
}

# Generate build summary
generate_summary() {
    print_status "Generating build summary..."
    
    echo
    echo "📊 Build Summary"
    echo "================"
    echo "Flutter Version: $(flutter --version | head -n 1 | cut -d' ' -f2)"
    echo "Dart Version: $(dart --version | cut -d' ' -f4)"
    echo "Build Date: $(date)"
    echo "Git Branch: $(git branch --show-current 2>/dev/null || echo 'Not a git repository')"
    echo "Git Commit: $(git rev-parse --short HEAD 2>/dev/null || echo 'Not a git repository')"
    
    if [ -f "coverage/lcov.info" ]; then
        echo "Coverage Report: coverage/lcov.info generated"
    fi
    
    echo "Build Artifacts:"
    find build/app/outputs -name "*.apk" -o -name "*.aab" 2>/dev/null | while read file; do
        echo "  - $file ($(du -h "$file" | cut -f1))"
    done
    
    echo
    print_success "Local CI/CD testing completed successfully! 🎉"
}

# Main execution
main() {
    echo "Starting local CI/CD pipeline simulation..."
    echo
    
    # Parse command line arguments
    SKIP_BUILDS=false
    SKIP_TESTS=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --skip-builds)
                SKIP_BUILDS=true
                shift
                ;;
            --skip-tests)
                SKIP_TESTS=true
                shift
                ;;
            --help)
                echo "Usage: $0 [options]"
                echo "Options:"
                echo "  --skip-builds    Skip building APK files"
                echo "  --skip-tests     Skip running tests"
                echo "  --help          Show this help message"
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                exit 1
                ;;
        esac
    done
    
    # Run all checks
    check_flutter
    check_flutter_doctor
    setup_dependencies
    create_dev_secrets
    check_formatting
    run_analysis
    
    if [ "$SKIP_TESTS" = false ]; then
        run_tests
    else
        print_warning "Skipping tests as requested"
    fi
    
    security_check
    
    if [ "$SKIP_BUILDS" = false ]; then
        build_flavors
    else
        print_warning "Skipping builds as requested"
    fi
    
    generate_summary
}

# Handle script interruption
trap 'print_error "Script interrupted"; exit 1' INT TERM

# Run main function
main "$@"
