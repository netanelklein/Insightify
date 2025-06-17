# Production Deployment Setup Guide

This guide helps you set up Insightify for production deployment to Google Play Store.

## Prerequisites

Before deploying to production, ensure you have:

1. ✅ **Google Play Console Account** - Developer account with app registration
2. ✅ **Production Signing Key** - Android keystore for app signing
3. ✅ **Spotify App Registration** - Production Spotify API credentials
4. ✅ **CI/CD Pipeline** - GitHub Actions workflows (already implemented)

## 🚀 Production Deployment Checklist

### 1. Google Play Console Setup

#### A. Create App in Play Console
1. Go to [Google Play Console](https://play.google.com/console)
2. Create new app: "Insightify - Spotify Data Analyzer"
3. Complete app information:
   - **Category**: Music & Audio
   - **Content Rating**: Everyone
   - **Privacy Policy**: Required (create one)
   - **Target Audience**: All ages

#### B. Generate Service Account for CI/CD
1. Go to Setup → API access in Play Console
2. Create new service account in Google Cloud Console
3. Download JSON key file
4. Grant permissions in Play Console:
   - Release manager
   - Editor (for app info updates)

#### C. Prepare Store Listing
- **App Description**: Ready in `distribution/store_listing/`
- **Screenshots**: Capture from app (5 phones, 2 tablets minimum)
- **Feature Graphic**: 1024 x 500 px banner
- **App Icon**: Already in `android/app/src/main/res/`

### 2. Android App Signing

#### A. Generate Production Keystore
```bash
# Run this command to create production keystore
keytool -genkey -v -keystore insightify-release-key.jks \
        -keyalg RSA -keysize 2048 -validity 10000 \
        -alias insightify-key

# Convert to base64 for GitHub secrets
base64 -i insightify-release-key.jks -o keystore.base64
```

#### B. Update Build Configuration
The `android/app/build.gradle` is already configured for release signing.
Just ensure the keystore is properly referenced.

### 3. Spotify API Production Setup

#### A. Create Production Spotify App
1. Go to [Spotify Developer Dashboard](https://developer.spotify.com/dashboard)
2. Create new app: "Insightify Production"
3. Set redirect URIs:
   - `insightify://callback`
   - `https://your-domain.com/callback` (if web version planned)
4. Note down Client ID and Client Secret

#### B. Request Extended Quota (if needed)
If planning for more than 25 users, request quota extension from Spotify.

### 4. GitHub Repository Secrets

Add these secrets to your GitHub repository (Settings → Secrets and variables → Actions):

#### Required for Production Deployment:
```
GOOGLE_PLAY_SERVICE_ACCOUNT_JSON=<service-account-json-content>
ANDROID_KEYSTORE_BASE64=<base64-encoded-keystore>
ANDROID_KEYSTORE_PASSWORD=<keystore-password>
ANDROID_KEY_ALIAS=insightify-key
ANDROID_KEY_PASSWORD=<key-password>
SPOTIFY_CLIENT_ID=<production-spotify-client-id>
SPOTIFY_CLIENT_SECRET=<production-spotify-client-secret>
```

#### Optional for Enhanced CI/CD:
```
CODECOV_TOKEN=<codecov-token-for-coverage>
SLACK_WEBHOOK=<slack-webhook-for-notifications>
```

### 5. Production Release Process

#### A. Prepare Release Branch
```bash
# Ensure dev is up to date and stable
git checkout dev
git pull origin dev

# Run full test suite
flutter test
flutter analyze
./scripts/local-ci.sh

# Create release branch
git checkout -b release/v1.0.0
```

#### B. Update Version Information
1. **Update `pubspec.yaml`**:
   ```yaml
   version: 1.0.0+1  # version+build_number
   ```

2. **Update `android/app/build.gradle`**:
   ```gradle
   versionCode 1
   versionName "1.0.0"
   ```

3. **Create release notes** in `distribution/whatsnew/whatsnew-en-US`

#### C. Create Production PR
```bash
# Commit version updates
git add pubspec.yaml android/app/build.gradle distribution/whatsnew/
git commit -m "chore: bump version to 1.0.0 for production release"

# Push and create PR to main
git push origin release/v1.0.0
# Create PR: release/v1.0.0 → main
```

#### D. Deploy to Production
1. **Merge PR to main** → Triggers CD workflow
2. **Monitor deployment** in GitHub Actions
3. **Verify in Play Console** → Internal testing track
4. **Promote to Beta** → Manual approval in Play Console
5. **Release to Production** → Staged rollout (1% → 100%)

### 6. Post-Deployment Monitoring

#### A. Set Up Monitoring
- **Firebase Crashlytics**: Add to project for crash reporting
- **Firebase Performance**: Monitor app performance metrics
- **Play Console**: Monitor user feedback and ratings

#### B. Release Health Metrics
Monitor these KPIs:
- **Crash-free rate**: > 99.5%
- **ANR rate**: < 0.1%
- **App size**: < 50MB
- **Startup time**: < 3 seconds
- **User rating**: > 4.0 stars

### 7. Hotfix Process

For critical issues in production:

```bash
# Create hotfix from main
git checkout main
git checkout -b hotfix/critical-fix-v1.0.1

# Make minimal fix
# Update version to 1.0.1+2
# Test thoroughly

# Fast-track to production
git push origin hotfix/critical-fix-v1.0.1
# Create PR: hotfix/critical-fix-v1.0.1 → main
# Merge immediately after review
```

## 🔒 Security Considerations

### Secrets Management
- ✅ **Never commit secrets** to version control
- ✅ **Use GitHub Secrets** for all sensitive data
- ✅ **Rotate keys regularly** (annually for signing keys)
- ✅ **Limit access** to production secrets

### App Security
- ✅ **Code obfuscation** enabled in release builds
- ✅ **Network security** with certificate pinning
- ✅ **Input validation** implemented throughout app
- ✅ **Error handling** prevents information leakage

## 📋 Pre-Launch Checklist

Before first production release:

### Technical Requirements
- [ ] All tests passing (61/61)
- [ ] Code coverage > 80%
- [ ] No critical security vulnerabilities
- [ ] Performance benchmarks met
- [ ] Accessibility features tested
- [ ] Multiple device testing completed

### Legal & Compliance
- [ ] Privacy policy published and linked
- [ ] Terms of service created
- [ ] GDPR compliance verified
- [ ] Google Play policies reviewed
- [ ] Content rating completed

### Store Preparation
- [ ] App screenshots captured (all screen sizes)
- [ ] Store listing description finalized
- [ ] Feature graphic created
- [ ] Localization completed (if applicable)
- [ ] Beta testing completed with feedback

### CI/CD Pipeline
- [ ] All GitHub secrets configured
- [ ] Production builds tested
- [ ] Deployment pipeline verified
- [ ] Rollback procedures tested
- [ ] Monitoring systems active

## 🆘 Emergency Procedures

### Production Incident Response
1. **Identify issue** through monitoring/user reports
2. **Assess severity** (critical/high/medium/low)
3. **Create hotfix branch** if critical
4. **Deploy fix** through fast-track pipeline
5. **Monitor resolution** and user impact
6. **Document incident** for future prevention

### Contact Information
- **Primary Developer**: [Your contact]
- **Google Play Support**: [Support link]
- **Spotify Developer Support**: [Support link]

## 📚 Additional Resources

- [Google Play Console Help](https://support.google.com/googleplay/android-developer)
- [Android App Bundle Documentation](https://developer.android.com/guide/app-bundle)
- [Spotify Web API Documentation](https://developer.spotify.com/documentation/web-api)
- [Flutter Deployment Guide](https://docs.flutter.dev/deployment/android)

---

**Status**: Production infrastructure ready, waiting for significant feature addition before first release.
**Last Updated**: June 17, 2025
**Next Review**: Before first production deployment
