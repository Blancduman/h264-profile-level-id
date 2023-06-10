import 'package:h264_profile_level_id/h264_profile_level_id.dart';
import 'package:test/test.dart';

void main() {
  test('TestParsingInvalid', () {
    // Malformed strings.
    expect(H264Utils.parseProfileLevelId(null), null);
    expect(H264Utils.parseProfileLevelId(''), null);
    expect(H264Utils.parseProfileLevelId(' 42e01f'), null);
    expect(H264Utils.parseProfileLevelId('4242e01f'), null);
    expect(H264Utils.parseProfileLevelId('e01f'), null);
    expect(H264Utils.parseProfileLevelId('gggggg'), null);

    // Invalid level.
    expect(H264Utils.parseProfileLevelId('42e000'), null);
    expect(H264Utils.parseProfileLevelId('42e00f'), null);
    expect(H264Utils.parseProfileLevelId('42e0ff'), null);

    // Invalid profile.
    expect(H264Utils.parseProfileLevelId('42e11f'), null);
    expect(H264Utils.parseProfileLevelId('58601f'), null);
    expect(H264Utils.parseProfileLevelId('64e01f'), null);
  });

  test('TestParsingLevel', () {
    expect(H264Utils.parseProfileLevelId('42e01f')?.level, H264Utils.Level3_1);
    expect(H264Utils.parseProfileLevelId('42e00b')?.level, H264Utils.Level1_1);
    expect(H264Utils.parseProfileLevelId('42f00b')?.level, H264Utils.Level1_b);
    expect(H264Utils.parseProfileLevelId('42C02A')?.level, H264Utils.Level4_2);
    expect(H264Utils.parseProfileLevelId('640c34')?.level, H264Utils.Level5_2);
  });

  test('TestParsingConstrainedBaseline', () {
    expect(H264Utils.parseProfileLevelId('42e01f')?.profile, H264Utils.ProfileConstrainedBaseline);
    expect(H264Utils.parseProfileLevelId('42C02A')?.profile, H264Utils.ProfileConstrainedBaseline);
    expect(H264Utils.parseProfileLevelId('4de01f')?.profile, H264Utils.ProfileConstrainedBaseline);
    expect(H264Utils.parseProfileLevelId('58f01f')?.profile, H264Utils.ProfileConstrainedBaseline);
  });

  test('TestParsingBaseline', () {
    expect(H264Utils.parseProfileLevelId('42a01f')?.profile, H264Utils.ProfileBaseline);
    expect(H264Utils.parseProfileLevelId('58A01F')?.profile, H264Utils.ProfileBaseline);
  });

  test('TestParsingMain', () {
    expect(H264Utils.parseProfileLevelId('4D401f')?.profile, H264Utils.ProfileMain);
  });

  test('TestParsingHigh', () {
    expect(H264Utils.parseProfileLevelId('64001f')?.profile, H264Utils.ProfileHigh);
  });

  test('TestParsingConstrainedHigh', () {
    expect(H264Utils.parseProfileLevelId('640c1f')?.profile, H264Utils.ProfileConstrainedHigh);
  });

  test('TestToString', () {
    expect(H264Utils.profileLevelIdToString(new ProfileLevelId(profile: H264Utils.ProfileConstrainedBaseline, level: H264Utils.Level3_1)), '42e01f');
    expect(H264Utils.profileLevelIdToString(new ProfileLevelId(profile: H264Utils.ProfileBaseline, level: H264Utils.Level1)), '42000a');
    expect(H264Utils.profileLevelIdToString(new ProfileLevelId(profile: H264Utils.ProfileMain, level: H264Utils.Level3_1)), '4d001f');
    expect(H264Utils.profileLevelIdToString(new ProfileLevelId(profile: H264Utils.ProfileConstrainedHigh, level: H264Utils.Level4_2)), '640c2a');
    expect(H264Utils.profileLevelIdToString(new ProfileLevelId(profile: H264Utils.ProfileHigh, level: H264Utils.Level4_2)), '64002a');
  });

  test('TestToStringLevel1b', () {
    expect(H264Utils.profileLevelIdToString(H264Utils.parseProfileLevelId('42e01f')!), '42e01f');
    expect(H264Utils.profileLevelIdToString(H264Utils.parseProfileLevelId('42E01F')!), '42e01f');
    expect(H264Utils.profileLevelIdToString(H264Utils.parseProfileLevelId('4d100b')!), '4d100b');
    expect(H264Utils.profileLevelIdToString(H264Utils.parseProfileLevelId('4D100B')!), '4d100b');
    expect(H264Utils.profileLevelIdToString(H264Utils.parseProfileLevelId('640c2a')!), '640c2a');
    expect(H264Utils.profileLevelIdToString(H264Utils.parseProfileLevelId('640C2A')!), '640c2a');
  });

  test('TestToStringInvalid', () {
    expect(H264Utils.profileLevelIdToString(new ProfileLevelId(profile: H264Utils.ProfileHigh, level: H264Utils.Level1_b)), null);
    expect(H264Utils.profileLevelIdToString(new ProfileLevelId(profile: H264Utils.ProfileConstrainedHigh, level: H264Utils.Level1_b)), null);
    expect(H264Utils.profileLevelIdToString(new ProfileLevelId(profile: 255, level: H264Utils.Level3_1)), null);
  });

  test('TestParseSdpProfileLevelIdEmpty', () {
    final profile_level_id = H264Utils.parseSdpProfileLevelId();

    expect(profile_level_id?.profile, H264Utils.ProfileConstrainedBaseline);
    expect(profile_level_id?.level, H264Utils.Level3_1);
  });

  test('TestParseSdpProfileLevelIdConstrainedHigh', () {
    final params = <String, String>{ 'profile-level-id': '640c2a' };
    final profile_level_id = H264Utils.parseSdpProfileLevelId(params: params);

    expect(profile_level_id?.profile, H264Utils.ProfileConstrainedHigh);
    expect(profile_level_id?.level, H264Utils.Level4_2);
  });

  test('TestParseSdpProfileLevelIdInvalid', () {
    final params = <String, String>{ 'profile-level-id': 'foobar' };

    expect(H264Utils.parseSdpProfileLevelId(params: params), null);
  });

  test('TestIsSameProfile', () {
    expect(H264Utils.isSameProfile(<String, String>{ 'foo': 'foo'}, <String, String>{ 'bar': 'bar'}), true);
    expect(H264Utils.isSameProfile(<String, String>{ 'profile-level-id': '42e01f'}, <String, String>{ 'profile-level-id': '42C02A'}), true);
    expect(H264Utils.isSameProfile(<String, String>{ 'profile-level-id': '42a01f'}, <String, String>{ 'profile-level-id': '58A01F'}), true);
    expect(H264Utils.isSameProfile(<String, String>{ 'profile-level-id': '42e01f'}, {}), true);
  });

  test('TestIsNotSameProfile', () {
    expect(H264Utils.isSameProfile({}, <String, String>{ 'profile-level-id': '4d001f' }), false);
    expect(H264Utils.isSameProfile(<String, String>{ 'profile-level-id': '42a01f' }, <String, String>{ 'profile-level-id': '640c1f' }), false);
    expect(H264Utils.isSameProfile(<String, String>{ 'profile-level-id': '42000a' }, <String, String>{ 'profile-level-id': '64002a' }), false);
  });

  test('TestGenerateProfileLevelIdForAnswerEmpty', () {
    expect(H264Utils.generateProfileLevelIdForAnswer(local_supported_params: {}, remote_offered_params: {}), null);
  });

  test('TestGenerateProfileLevelIdForAnswerLevelSymmetryCapped', () {
    final low_level = <String, String>{ 'profile-level-id': '42e015' };
    final high_level = <String, String>{ 'profile-level-id': '42e015' };

    expect(H264Utils.generateProfileLevelIdForAnswer(local_supported_params: low_level, remote_offered_params: high_level), '42e015');
    expect(H264Utils.generateProfileLevelIdForAnswer(local_supported_params: high_level, remote_offered_params: low_level), '42e015');
  });

  test('TestGenerateProfileLevelIdForAnswerConstrainedBaselineLevelAsymmetry', () {
    final local_params = <String, String>{
      'profile-level-id': '42e01f',
      'level-asymmetry-allowed': '1',
    };
    final remote_params = <String, String>{
      'profile-level-id': '42e015',
      'level-asymmetry-allowed' : '1',
    };

    expect(H264Utils.generateProfileLevelIdForAnswer(local_supported_params: local_params, remote_offered_params: remote_params), '42e01f');
  });
}