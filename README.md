# h264-profile-level-id
Dart utility to process H264 profile-level-id values

## API

```dart
import 'package:h264_profile_level_id/h264_profile_level_id.dart';

H264Utils. => {
  // H264 Profile identifiers.
  ProfileConstrainedBaseline,
  ProfileBaseline,
  ProfileMain,
  ProfileConstrainedHigh,
  ProfileHigh,
  // H264 Level identifiers.
  Level1_b,
  Level1,
  Level1_1,
  Level1_2,
  Level1_3,
  Level2,
  Level2_1,
  Level2_2,
  Level3,
  Level3_1,
  Level3_2,
  Level4,
  Level4_1,
  Level4_2,
  Level5,
  Level5_1,
  Level5_2,
  // Functions.
  parseProfileLevelId,
  profileLevelIdToString,
  parseSdpProfileLevelId,
  isSameProfile,
  generateProfileLevelIdForAnswer
};
// Class.
ProfileLevelId,
```

### ProfileLevelId

Class containing both H264 Profile and Level.

```dart
final ProfileLevelId profileLevelId = ProfileLevelId(
    profile: H264Utils.ProfileMain,
    level: H264Utils.Level3_1,
  );

print('profile: ${profileLevelId.profile}, level: ${profileLevelId.level}');
// => profile: 3, level: 31
```


### parseProfileLevelId(str)

Parse profile level id that is represented as a string of 3 hex bytes. Nothing will be returned if the string is not a recognized H264 profile level id.

* `@param` {String?} **str** - profile-level-id value as a string of 3 hex bytes.
* `@returns` {ProfileLevelId?} A instance of the `ProfileLevelId` class.


### profileLevelIdToString(profile_level_id)

Returns canonical string representation as three hex bytes of the profile level id, or returns nothing for invalid profile level ids.

* `@param` {ProfileLevelId} **profile_level_id** - A instance of the `ProfileLevelId` class.
* `@returns` {String?}


### parseSdpProfileLevelId(params={})

Parse profile level id that is represented as a string of 3 hex bytes contained in an SDP key-value map. A default profile level id will be returned if the profile-level-id key is missing. Nothing will be returned if the key is present but the string is invalid.

* `@param` {Object} **[params={}]** - Codec parameters object.
* `@returns` {ProfileLevelId?} A instance of the `ProfileLevelId` class.


### isSameProfile(params1={}, params2={})

Returns true if the parameters have the same H264 profile, i.e. the same H264 profile (Baseline, High, etc).

* `@param` {Object} **[params1={}]** - Codec parameters object.
* `@param` {Object} **[params2={}]** - Codec parameters object.
* `@returns` {Boolean}


### generateProfileLevelIdForAnswer(local_supported_params={}, remote_offered_params={})

Generate a profile level id that is represented as a string of 3 hex bytes suitable for an answer in an SDP negotiation based on local supported parameters and remote offered parameters. The parameters that are used when negotiating are the level part of `profile-level-id` and `level-asymmetry-allowed`.

**NOTE:** This function is just intended to manage H264 profile levels ids with same Profile (otherwise it will throw). Use `isSameProfile()` API before this one.

* `@param` {Object} **[local_supported_params={}]**
* `@param` {Object} **[remote_offered_params={}]**
* `@returns` {String?} Canonical string representation as three hex bytes of the profile level id, or null if no one of the params have `profile-level-id.`
* `@throws` {TypeError} If Profile mismatch or invalid params.