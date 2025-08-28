#!/bin/bash
# Remove any existing provisioning profile specifiers
sed -i '' '/PROVISIONING_PROFILE_SPECIFIER/d' Runner.xcodeproj/project.pbxproj

# Add provisioning profile specifier after each DEVELOPMENT_TEAM line
sed -i '' '/DEVELOPMENT_TEAM = ".*";/{
a\
				PROVISIONING_PROFILE_SPECIFIER = "asim-prod";
}' Runner.xcodeproj/project.pbxproj
