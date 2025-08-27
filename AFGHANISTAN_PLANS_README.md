# Afghanistan eSIM Plans Implementation

## Overview
Successfully updated the Asim platform landing page to display Afghanistan-specific eSIM plans based on the CSV data provided.

## Changes Made

### 1. Created Data Models (`lib/core/models/esim_plan.dart`)
- `EsimPlan` class to represent eSIM plan data
- CSV parsing functionality 
- Data extraction methods for amount, duration, and pricing
- Popular plan identification logic

### 2. Created Service Layer (`lib/core/services/esim_plan_service.dart`)
- `EsimPlanService` for loading and processing CSV data
- Filtered Afghanistan-specific plans from the CSV
- Featured plans selection logic
- Caching mechanism for performance

### 3. Updated Landing Page (`lib/screens/landing_page.dart`)
- Converted from StatelessWidget to StatefulWidget to handle async data loading
- Added Afghanistan-specific hero section content
- Dynamic plan cards showing real Afghanistan eSIM data
- Updated features section to focus on Afghanistan coverage
- Real purchase links to the actual eSIM provider

### 4. Added Assets (`assets/esim-plans.csv`)
- Copied the provided CSV file to the assets directory
- Updated `pubspec.yaml` to include the CSV asset

### 5. Created Tests (`test/afghanistan_plans_test.dart`)
- Comprehensive test suite to verify data loading
- Tests for featured plans selection
- Data parsing validation
- All tests passing

## Afghanistan Plans Available
The system now loads and displays 9 Afghanistan-specific eSIM plans:

1. **Afghanistan 500MB/Day** - $4.24
2. **Afghanistan 1GB/Day** - $5.89  
3. **Afghanistan 1GB 7Days** - $6.48
4. **Afghanistan 2GB/Day** - $9.30
5. **Afghanistan 3GB 15Days** - $15.06
6. **Afghanistan 3GB 30Days** - $15.89
7. **Afghanistan 5GB 30Days** - $24.24
8. **Afghanistan 10GB 30Days** - $44.48
9. **Afghanistan 20GB 30Days** - $81.89

## Key Features
- **Real-time data loading** from CSV asset
- **Responsive plan cards** with Afghanistan-specific styling
- **Direct purchase links** to the actual eSIM provider
- **Multilingual support** (English, Dari, Pashto)
- **Featured plans selection** for optimal user experience
- **Error handling** and loading states

## Technical Implementation
- Uses Flutter's asset loading system
- Async data loading with proper state management
- CSV parsing without external dependencies
- Comprehensive error handling
- Mobile and web responsive design

The landing page now successfully showcases Afghanistan eSIM plans with real data from the CSV file, providing users with accurate pricing and direct purchase options.
