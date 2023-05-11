*** Settings ***
Library     RequestsLibrary
Resource    ../../Tests/FileImports.robot


*** Keywords ***
Trigger OTP
    [Arguments]    ${mobileNumber}    ${appHash}    ${expected_status}=200
    ${payload}=    Create Dictionary    mobile=${mobileNumber}    appHash=${appHash}
    ${res}=    POST On Session    gullak    /triggerOTP    json=${payload}    expected_status=${expected_status}
    Log API response    ${res}
    RETURN    ${res.json()}

Resend OTP
    [Arguments]    ${loginId}    ${expected_status}=200
    ${payload}=    Create Dictionary    id=${loginId}
    ${res}=    POST On Session    gullak    /resendOTP    json=${payload}    expected_status=${expected_status}
    Log API response    ${res}
    RETURN    ${res.json()}

Verify OTP
    [Arguments]    ${OTP}    ${loginId}    ${expected_status}=200
    ${deviceDetails}=    Create Dictionary    os=Android    fcmToken=test    id=DEVICE_ID12    referrer=okc
    ${payload}=    Create Dictionary    otp=${OTP}    id=${loginId}    device=${deviceDetails}
    ${res}=    POST On Session    gullak    /verifyOTP    json=${payload}    expected_status=${expected_status}
    Log API response    ${res}
    RETURN    ${res.json()}
