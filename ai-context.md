# Insightify - Spotify Data Analyzer

## Project Overview

Insightify is a Flutter mobile application that allows users to analyze their Spotify listening data. The app imports user's downloaded Spotify data files (either Extended or Account data) and provides visualizations and statistics about their listening habits, including top artists, tracks, albums, and listening patterns.

## Key Features

- Import and parse Spotify data from JSON files
- View top artists, tracks, and albums based on listening history
- View total streaming time and most streamed days
- Display average listening time per day statistics
- View listening history with sorting options
- Time of day listening pattern visualization
- Dedicated pages for artists and albums with detailed statistics
- Filter data by custom time ranges

## Core Technical Components

1. **Data Models**:
   - StreamHistoryEntry - Represents basic streaming history
   - ExtendedStreamHistoryEntry - Extended data with detailed information
   - StreamHistoryDBEntry - Database representation of streaming history

2. **State Management**:
   - Uses the Provider package for application state management
   - AppState class manages core state like time ranges, loading state, and filtering options

3. **Database**:
   - Uses SQLite through the sqflite package
   - DatabaseHelper manages database operations including querying statistics
   - Stores stream history, artists, and albums information

4. **API Integration**:
   - Connects to Spotify Web API for additional metadata
   - Fetches artist and album information not available in user data

5. **UI Components**:
   - Material design with custom theme
   - Charts and visualizations using fl_chart
   - World map visualization with countries_world_map

## Project Structure

- lib/
  - main.dart - Application entry point
  - app_state.dart - Global state management
  - auth/ - Spotify API authentication
  - src/
    - models/ - Data models
    - screens/ - Main application screens
    - services/ - API services
    - styles/ - Theme and styling
    - utils/ - Helper functions and constants
    - widgets/ - Reusable UI components

## Recent Completed Work: Immediate Security & Quality Improvements (June 2025)

### ✅ COMPLETED: Critical Security and Testing Infrastructure

**Problem**: App lacked essential security features, input validation, error reporting, and comprehensive testing infrastructure.

**Solution Implemented**:
1. **Secrets Management** - Created template system with `.gitignore` protection
2. **Input Validation & Sanitization** - Comprehensive validation utilities for all user inputs
3. **Structured Error Reporting** - Logging system with severity levels and context tracking  
4. **Test Infrastructure** - Complete unit, widget, and integration test suite
5. **Security Enhancements** - Safe JSON parsing and file upload validation
6. **Unicode Compatibility** - Fixed RegExp patterns for international content

### Key Files Created/Modified:

#### New Utilities & Services:
- `lib/auth/secrets.dart.template` - Secrets management template for new developers
- `lib/src/utils/input_validator.dart` - Comprehensive input validation and sanitization
- `lib/src/utils/error_reporting.dart` - Structured error reporting with severity levels

#### Enhanced Security Integration:
- `lib/src/widgets/top_lists/search_bar.dart` - Integrated input validation
- `lib/src/services/spotify_api_fetch.dart` - Added input sanitization for API calls  
- `lib/src/screens/welcome.dart` - Enhanced with safe JSON validation and error reporting
- `lib/main.dart` - Added global error reporting initialization
- `lib/app_state.dart` - Added test-friendly constructor with `skipInit` parameter

#### Comprehensive Test Suite:
- `test/utils/input_validator_test.dart` - 18 tests covering all validation scenarios
- `test/utils/error_reporting_test.dart` - 18 tests for error reporting functionality
- `test/integration/app_integration_test.dart` - 10 integration tests for app workflows
- `test/widget_test.dart` - Provider-based widget tests for UI components

**Branch & Development State**: `feature/immediate-improvements` - Ready for merge with all 61 tests passing.
  - auth/ - Spotify API authentication
  - src/
    - models/ - Data models
    - screens/ - Main application screens
    - services/ - API services
    - styles/ - Theme and styling
    - utils/ - Helper functions and constants
    - widgets/ - Reusable UI components

## Development Considerations

- The app processes potentially large JSON files
- Performance optimization for data querying is important
- User privacy is maintained by processing all data locally
- Future plans include expanded visualizations and direct Spotify account integration

## Recent Development Work (December 2024 - June 2025)

### ✅ JSON File Upload Fix - COMPLETED (December 2024)
**Problem**: Users couldn't upload their real Spotify data files because the app expected all optional fields to be present
**Solution**: 
- Updated file type detection in both `welcome.dart` and `database_helper.dart`
- Implemented flexible key matching that only requires core essential fields
- Added comprehensive error handling and user feedback
- Successfully tested with 70,773 real user records across 4 files

**Files Modified**:
- `lib/src/screens/welcome.dart` - Enhanced file upload logic and error handling
- `lib/src/utils/database_helper.dart` - Updated database insertion logic
- `.github/copilot-instructions.md` - Added development workflow guidelines
- `.github/.ai-context` - Comprehensive project documentation

**Commits**:
- `fix: improve Spotify JSON file detection for real user data` (4c3ba28)
- `chore: update Flutter build configuration and dependencies` (785e6c3)

### ✅ Immediate Security & Quality Improvements - COMPLETED (June 2025)
**Problem**: App lacked critical security features, input validation, error reporting, and comprehensive testing
**Solution**: 
- Implemented comprehensive secrets management with template system
- Added robust input validation and sanitization utilities
- Integrated structured error reporting and crash handling
- Enhanced file upload security with safe JSON validation
- Created comprehensive test infrastructure (unit, widget, and integration tests)
- Fixed Unicode handling and RegExp compatibility issues

**Files Created/Modified**:
- `lib/auth/secrets.dart.template` - Secrets management template
- `lib/src/utils/input_validator.dart` - Input validation and sanitization utilities  
- `lib/src/utils/error_reporting.dart` - Structured error reporting and logging
- `lib/src/widgets/top_lists/search_bar.dart` - Integrated input validation
- `lib/src/services/spotify_api_fetch.dart` - Added input sanitization
- `lib/src/screens/welcome.dart` - Enhanced with safe JSON validation and error reporting
- `lib/main.dart` - Added error reporting initialization
- `test/utils/input_validator_test.dart` - Comprehensive validation tests
- `test/utils/error_reporting_test.dart` - Error reporting tests
- `test/integration/app_integration_test.dart` - App-wide integration tests
- `test/widget_test.dart` - Updated with Provider pattern

**Branch**: `feature/immediate-improvements`

**Key Improvements**:
- ✅ Secrets management with .gitignore protection
- ✅ Input validation for all user inputs (search, file uploads, URLs)
- ✅ Structured error reporting with severity levels and context
- ✅ Safe JSON parsing with comprehensive validation
- ✅ Unicode-compatible RegExp patterns for international content
- ✅ Provider-based widget testing infrastructure
- ✅ Integration tests covering file upload and app initialization
- ✅ Global error handling for uncaught exceptions

## Critical Issues Identified

### ✅ Recently Resolved (December 2024 - June 2025)
1. **JSON File Loading**: ✅ FIXED - Improved Spotify JSON file detection for real user data
   - Updated file type detection to use flexible key matching instead of requiring all optional fields
   - Fixed issue where real Spotify Extended Streaming History files were rejected due to missing optional fields like 'username'
   - Enhanced error handling and user feedback in file upload process
   - Successfully tested with 70k+ records from real user Spotify data files
   - Both welcome.dart and database_helper.dart now use consistent detection logic

2. **Security & Input Validation**: ✅ FIXED - Comprehensive security improvements
   - Implemented secrets management with template system and .gitignore protection
   - Added robust input validation and sanitization for all user inputs
   - Created structured error reporting with severity levels and context tracking
   - Enhanced file upload security with safe JSON validation and error handling
   - Fixed Unicode compatibility issues in RegExp patterns for international content

3. **Test Infrastructure**: ✅ FIXED - Comprehensive testing framework
   - Created unit tests for input validation and error reporting utilities
   - Implemented widget tests with proper Provider pattern integration
   - Added integration tests covering file upload and app initialization workflows
   - Fixed RegExp Unicode handling and AppState context issues in tests

### High Priority (Next Phase)
1. **CI/CD Pipeline Setup**: Implement automated testing and Google Play deployment infrastructure
2. **Memory Management**: Large JSON file processing could cause memory issues on low-end devices
3. **API Efficiency**: Spotify API calls noted as inefficient (multiple TODO comments)
4. **Performance Monitoring**: Add real-time performance tracking and memory usage monitoring

### Medium Priority (Phase 1)
1. **Code Organization**: Some TODOs remain unaddressed in codebase
2. **Performance**: No pagination for large datasets in UI components
3. **Proper Logging**: Replace print statements with structured logging

### Future Priority - Comprehensive Test Coverage
**Note**: While we now have solid test infrastructure for validation and error reporting (61 tests), we should eventually expand test coverage to the entire application. This includes:
- All UI components and screens
- Database operations and data models
- Spotify API integration
- Chart and visualization components
- State management flows
- User interaction workflows

This is not urgent but represents good practice for long-term maintainability and reliability.

### Development Workflow Recommendations

#### Git Branching Strategy
1. **Main Branch**: Production-ready code only
2. **Dev Branch**: Integration branch for all feature development
3. **Feature Branches**: Individual branches for each feature (e.g., `feature/track-pages`, `feature/search-functionality`)
4. **Hotfix Branches**: For critical bug fixes that need immediate deployment

#### Suggested Branch Naming Convention
- `feature/description` (e.g., `feature/dedicated-track-pages`)
- `bugfix/description` (e.g., `bugfix/json-import-error`)
- `hotfix/description` (e.g., `hotfix/database-crash`)
- `chore/description` (e.g., `chore/update-dependencies`)

#### Development Process
1. Create feature branch from dev
2. Implement feature with tests
3. Code review via pull request
4. Merge to dev branch
5. Integration testing
6. Merge dev to main for releases

## Improvement Roadmap

### Phase 1: Foundation & Stability (Current - Next Month)
**Branch: `dev` → `feature/foundation-improvements`**
- ✅ **Error Handling & Validation**: COMPLETED - Added comprehensive error handling and user feedback for file uploads
- ✅ **Test Infrastructure**: COMPLETED - Set up testing framework with unit/integration tests
- ✅ **Input Validation & Security**: COMPLETED - Implemented comprehensive input validation and secrets management
- **CI/CD Pipeline**: HIGH PRIORITY - Implement automated testing and Google Play deployment pipeline
- **Performance Optimization**: Implement pagination and optimize database queries
- **Code Cleanup**: Address existing TODOs and improve API efficiency
- **Proper Logging**: Replace print statements with structured logging framework

### Phase 2: Core Feature Enhancements (1-2 months)
**Branches from `dev`:**
- `feature/dedicated-track-pages`: Detailed view of individual tracks with listening history
- `feature/search-functionality`: Global search across top lists, history, artists, and albums
- `feature/time-visualizations`: Timeline view showing listening evolution over time
- `feature/genre-analysis`: Genre categorization and distribution visualizations

### Phase 3: Technical Improvements (2-3 months)
**Branches from `dev`:**
- `feature/offline-caching`: Local caching of artist and album images
- `feature/data-import-enhancement`: Background processing with validation and progress
- `feature/repository-pattern`: Implement repository pattern for better data abstraction
- `feature/accessibility`: Screen reader support and visual accessibility improvements

### Phase 4: Advanced Features & Integration (3-4 months)
**Branches from `dev`:**
- `feature/spotify-integration`: OAuth authentication and real-time data syncing
- `feature/data-export`: Export analysis results as images or PDFs
- `feature/ui-personalization`: Customizable dashboard and theme options
- `feature/playlist-analysis`: Visualization and cross-analysis of playlist data

### Phase 5: Future Vision (4+ months)
**Branches from `dev`:**
- `feature/social-features`: Friend comparison capabilities (privacy-respecting)
- `feature/ml-integration`: Mood analysis and personalized insights
- `feature/advanced-visualizations`: Interactive charts with animations
- `feature/mobile-optimization`: Platform-specific optimizations

## CI/CD Pipeline & Deployment Infrastructure

### Priority: High - Production Deployment Pipeline

**Objective**: Implement a comprehensive CI/CD pipeline for automated testing, building, and deployment to Google Play Store.

#### **Phase 1: Core CI/CD Setup**
**Branch: `feature/cicd-pipeline`**

##### **GitHub Actions Workflows:**
1. **Continuous Integration (`ci.yml`)**:
   - Triggered on all PRs and pushes to `dev` and `main`
   - Flutter environment setup (stable channel)
   - Dependency installation (`flutter pub get`)
   - Code quality checks:
     - `flutter analyze` (static analysis)
     - `dart format --set-exit-if-changed .` (formatting)
     - `flutter test` (run all 61+ tests)
     - Coverage reporting with codecov integration
   - Build verification for Android APK

2. **Continuous Deployment (`cd.yml`)**:
   - Triggered on pushes to `main` branch (production releases)
   - Automated versioning (semantic versioning)
   - Build signed Android App Bundle (AAB)
   - Deploy to Google Play Console:
     - Internal testing track (automatic)
     - Beta track (manual approval)
     - Production track (manual approval with staged rollout)

##### **Security & Secrets Management:**
- **GitHub Secrets** for sensitive configuration:
  - `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`: Service account for Play Console API
  - `ANDROID_KEYSTORE_BASE64`: Base64 encoded signing keystore
  - `ANDROID_KEYSTORE_PASSWORD`: Keystore password
  - `ANDROID_KEY_ALIAS`: Key alias for signing
  - `ANDROID_KEY_PASSWORD`: Key password
  - `SPOTIFY_CLIENT_ID`: Production Spotify API credentials
  - `SPOTIFY_CLIENT_SECRET`: Production Spotify API secret

##### **Build Configuration:**
- **Flavors Setup**:
  - `dev`: Development builds with debug features
  - `staging`: Pre-production testing with production-like config
  - `prod`: Production builds for Google Play release
- **Automated Version Management**:
  - Semantic versioning based on conventional commits
  - Automatic changelog generation
  - Build number increment for each release

##### **Code Quality Gates:**
- **Required Checks**:
  - All tests must pass (61+ tests)
  - Code coverage threshold: 80%+ for new code
  - No critical security vulnerabilities (using dart audit)
  - Performance benchmarks (app startup time, memory usage)
  - No breaking changes in public APIs

#### **Phase 2: Advanced Deployment Features**
**Branch: `feature/advanced-deployment`**

##### **Release Management:**
- **Automated Release Notes**: Generate from conventional commits
- **Staged Rollouts**: Start with 1% → 5% → 20% → 50% → 100%
- **Rollback Capabilities**: Automatic rollback on crash rate increase
- **A/B Testing Infrastructure**: Support for feature flags and experiments

##### **Monitoring & Analytics:**
- **Crash Reporting**: Firebase Crashlytics integration
- **Performance Monitoring**: Firebase Performance integration
- **User Analytics**: Privacy-focused analytics for usage patterns
- **Release Health Metrics**: Track adoption, crash rates, and user satisfaction

##### **Quality Assurance:**
- **Automated Testing**:
  - End-to-end testing with integration test suite
  - Visual regression testing for UI components
  - Performance testing (memory leaks, battery usage)
  - Accessibility testing (screen reader compatibility)
- **Manual Testing Workflows**:
  - Internal testing checklist automation
  - Beta tester feedback collection
  - Release candidate validation process

#### **Phase 3: Production Operations**
**Branch: `feature/production-ops`**

##### **Infrastructure as Code:**
- **Google Cloud Platform Setup**:
  - Cloud Build for advanced build pipelines
  - Cloud Storage for build artifacts and app bundles
  - Cloud Functions for webhook processing
  - IAM roles and service accounts management

##### **Release Pipeline:**
- **Multi-Environment Strategy**:
  - `dev` → Internal testing (automatic)
  - `staging` → Beta testing (manual approval)
  - `main` → Production release (manual approval + staged rollout)
- **Feature Branch Previews**: Build preview APKs for feature branches
- **Hotfix Pipeline**: Fast-track critical bug fixes to production

##### **Compliance & Security:**
- **Security Scanning**:
  - Dependency vulnerability scanning
  - Static application security testing (SAST)
  - Secret scanning prevention
- **Compliance Requirements**:
  - GDPR compliance validation
  - Google Play policy compliance checks
  - Privacy policy automation

#### **Required Setup Tasks:**

##### **Google Play Console Configuration:**
1. **App Registration**: Register Insightify in Google Play Console
2. **Service Account**: Create service account with Play Developer API access
3. **Signing Key**: Generate and configure app signing key
4. **Store Listing**: Prepare app description, screenshots, and metadata
5. **Content Rating**: Complete content rating questionnaire
6. **Privacy Policy**: Deploy privacy policy and link in Play Console

##### **GitHub Repository Setup:**
1. **Branch Protection Rules**: Require PR reviews and status checks for `main`
2. **Secrets Configuration**: Add all required secrets to repository settings
3. **Workflow Files**: Create `.github/workflows/` directory with CI/CD workflows
4. **Issue Templates**: Create templates for bug reports and feature requests
5. **Pull Request Template**: Standardize PR descriptions and checklists

##### **Development Environment:**
1. **Android Signing**: Generate production keystore and configure signing
2. **Flavor Configuration**: Set up build flavors in `android/app/build.gradle`
3. **Environment Variables**: Configure different API endpoints per flavor
4. **Version Management**: Implement automated version bumping strategy

#### **Success Metrics:**
- **Deployment Frequency**: Multiple deployments per week to beta, weekly to production
- **Lead Time**: < 2 hours from code commit to production availability
- **Change Failure Rate**: < 5% of deployments require hotfix or rollback
- **Mean Time to Recovery**: < 4 hours for critical issues
- **Test Coverage**: Maintain > 80% code coverage for all new features
- **User Satisfaction**: App store rating > 4.5 stars

#### **Risk Mitigation:**
- **Automated Rollbacks**: Trigger rollback on crash rate > 2% increase
- **Canary Releases**: Test with small user percentage before full rollout
- **Feature Flags**: Ability to disable features without app update
- **Emergency Procedures**: Documented process for critical hotfixes
- **Backup Strategy**: Regular backups of signing keys and configuration

## Technical Debt & Code Quality

### ✅ Immediate Actions - COMPLETED (June 2025)
1. ✅ **Add secrets.dart template**: Created `lib/auth/secrets.dart.template` for new developers
2. ✅ **Add input sanitization**: Implemented validation for all user inputs and API responses
3. ✅ **Create error reporting**: Added crash reporting and structured logging for production builds
4. ✅ **Test Infrastructure**: Set up comprehensive unit and integration testing
5. **Add performance monitoring**: Track app performance and memory usage (Next Phase)

### Code Quality Standards
1. **Documentation**: Add comprehensive code comments and README updates
2. **Linting**: Ensure all code passes Flutter linting rules
3. **Type Safety**: Add explicit types where missing
4. **Constants Management**: Centralize magic numbers and strings
5. **Widget Decomposition**: Break down large widgets into smaller, reusable components
