# GitHub Repository Configuration Guide

This document outlines the required GitHub repository settings to fully enable the CI/CD pipeline.

## Required GitHub Secrets

The following secrets must be configured in your GitHub repository settings (Settings → Secrets and variables → Actions):

### Google Play Store Deployment
- `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`: Service account JSON for Google Play Console API access
- `ANDROID_KEYSTORE_BASE64`: Base64 encoded Android signing keystore
- `ANDROID_KEYSTORE_PASSWORD`: Password for the Android keystore
- `ANDROID_KEY_ALIAS`: Key alias for signing
- `ANDROID_KEY_PASSWORD`: Password for the signing key

### Spotify API Integration
- `SPOTIFY_CLIENT_ID`: Production Spotify API client ID
- `SPOTIFY_CLIENT_SECRET`: Production Spotify API client secret

## Branch Protection Rules

Configure the following branch protection rules in GitHub (Settings → Branches):

### Main Branch (`main`)
- ✅ Require a pull request before merging
- ✅ Require approvals: 1
- ✅ Dismiss stale PR approvals when new commits are pushed
- ✅ Require status checks to pass before merging
  - Required status checks:
    - `Test and Analyze`
    - `Security Scan`
- ✅ Require branches to be up to date before merging
- ✅ Require linear history
- ✅ Include administrators

### Development Branch (`dev`)
- ✅ Require a pull request before merging
- ✅ Require status checks to pass before merging
  - Required status checks:
    - `Test and Analyze`
- ✅ Require branches to be up to date before merging

## GitHub Environments

Create the following environments in GitHub (Settings → Environments):

### `internal`
- **Protection rules**: No special restrictions
- **Description**: Internal testing builds for QA team

### `beta`
- **Protection rules**: Required reviewers (add project maintainers)
- **Description**: Beta testing builds for external testers

### `production`
- **Protection rules**: Required reviewers (add all project maintainers)
- **Description**: Production releases to Google Play Store

## Repository Settings

### General Settings
- **Default branch**: `main`
- **Template repository**: Disabled
- **Issues**: Enabled
- **Projects**: Enabled
- **Wiki**: Disabled
- **Discussions**: Optional

### Pull Requests
- ✅ Allow merge commits
- ✅ Allow squash merging
- ❌ Allow rebase merging
- ✅ Always suggest updating pull request branches
- ✅ Allow auto-merge
- ✅ Automatically delete head branches

### Actions
- ✅ Allow all actions and reusable workflows
- **Artifact retention**: 30 days
- **Log retention**: 30 days

## Google Play Console Setup

### Prerequisites
1. **Google Play Developer Account**: Ensure you have an active Google Play Developer account
2. **App Registration**: Register the app with package name `com.insightify.spotify_analyzer`

### Service Account Setup
1. Go to Google Cloud Console
2. Create a new project or select existing
3. Enable Google Play Developer API
4. Create a service account with following permissions:
   - Service Account User
   - Service Account Token Creator
5. Download the service account JSON key
6. In Google Play Console, go to Settings → API access
7. Link the Google Cloud project
8. Grant access to the service account with permissions:
   - View app information and download bulk reports
   - Manage production releases
   - Manage testing track releases

### App Signing
1. In Google Play Console, go to your app → Release → Setup → App signing
2. Choose "Google Play App Signing" (recommended)
3. Upload your signing key or let Google generate one
4. Download the deployment certificate for CI/CD use

## Codecov Integration (Optional)

For test coverage reporting:

1. Go to [codecov.io](https://codecov.io)
2. Sign in with GitHub
3. Add your repository
4. Copy the repository token
5. Add `CODECOV_TOKEN` to GitHub secrets (if repository is private)

## Security Scanning (Optional but Recommended)

### TruffleHog Secret Scanning
- Already configured in the CI workflow
- No additional setup required

### Dependabot
Enable Dependabot in GitHub settings:
1. Go to Settings → Security & analysis
2. Enable "Dependabot alerts"
3. Enable "Dependabot security updates"
4. Create `.github/dependabot.yml` for dependency updates

## Testing the Setup

1. **Push to feature branch**: Should trigger preview build
2. **Create PR to dev**: Should trigger CI tests and preview build
3. **Merge to dev**: Should trigger CI tests
4. **Push to main**: Should trigger full CI/CD pipeline with deployment

## Troubleshooting

### Common Issues

1. **Build failures**: Check Flutter version compatibility
2. **Signing issues**: Verify keystore and key properties
3. **Google Play upload failures**: Check service account permissions
4. **Test failures**: Ensure all dependencies are properly mocked

### Debug Steps

1. Check GitHub Actions logs for detailed error messages
2. Verify all secrets are correctly configured
3. Test builds locally using the same commands as CI
4. Check Google Play Console for upload status and errors

## Monitoring and Maintenance

### Regular Tasks
- Review dependency update PRs weekly
- Monitor security alerts and address promptly
- Review Google Play Console for app performance metrics
- Update CI/CD workflows as needed for new Flutter versions

### Performance Monitoring
- Set up Firebase Crashlytics for crash reporting
- Monitor app bundle size increases
- Track CI/CD pipeline performance and optimization opportunities
