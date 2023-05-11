*** Settings ***
Resource        FileImports.robot

Suite Setup     Prelauncher setup
# Run command
# robot -d Results API/Tests/SanityTests.robot


*** Test Cases ***
Should be able to trigger OTP
    [Tags]    sanity    otp
    ${mobileNumber}=    Get random mobile number from the test data
    ${res}=    Trigger OTP    ${mobileNumber}    abcd
    Should Be True
    ...    (isinstance($res["id"], str) and len($res["id"]) == 32) and isinstance($res["whatsappOptInStatus"], bool)

Should be able to resend OTP
    [Tags]    sanity    otp
    ${res}=    Resend OTP    ${LOGIN_ID}
    Should Be True    isinstance($res["id"], str) and len($res["id"]) == 32

Should be able to verify OTP
    [Tags]    sanity    otp
    ${otp}=    Guess the OTP
    ${res}=    Verify OTP    ${otp}    ${LOGIN_ID}
    ${accessToken}=    Set Variable    ${res}[loginToken][accessToken]
    Set Global Variable    ${accessToken}
    # Assertions
    ${regex}=    Create Dictionary    id=^[a-z0-9]{32}$
    ...    timestamp=^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}.\\d{5,9}\\+\\d{2}:\\d{2}$
    Should Be True    isinstance($res["isNew"], bool)    # isNew
    # User Details
    Should Be True    isinstance($res["userDetails"]["name"], str) and len($res["userDetails"]["name"]) > 0
    Should Match Regexp    ${res}[userDetails][userId]    ${regex}[id]
    Should Match Regexp    ${res}[userDetails][createdAt]    ${regex}[timestamp]
    Should Be True    int($res["userDetails"]["age"]) > 0
    # Login Token
    Should Match Regexp    ${res}[loginToken][accessToken]    ${regex}[id]
    Should Match Regexp    ${res}[loginToken][expiryDate]    ${regex}[timestamp]
    ${tokenExpiry}=    Evaluate
    ...    arrow.get("""${res}[loginToken][expiryDate]""").is_between(arrow.now().shift(days=+30, seconds=-5), arrow.now().shift(days=+30, seconds=+5))
    Should Be True    ${tokenExpiry}

Should be able to update user
    [Tags]    sanity    home
    ${res}=    User    ${accessToken}
    # Assertions
    Should Be True    isinstance($res["status"], str)
    Should Match    ${res}[status]    SUCCESS

Should be able to get Home
    [Tags]    sanity    home
    ${res}=    Home    ${accessToken}
    # Assertions
    ${regex}=    Create Dictionary    id=^[a-z0-9]{32}$
    # 1. userDetails
    Should Be True    isinstance($res["userDetails"]["name"], str) and len($res["userDetails"]["name"]) > 0
    Should Be True    isinstance($res["userDetails"]["name"], str) and len($res["userDetails"]["age"]) > 0    # age
    Should Be True    isinstance($res["userDetails"]["leasingUser"], bool)    # Leasing user
    # 2. goalSummary
    Should Match Regexp    ${res}[goalSummary][0][id]    ${regex}[id]
    Should Be True    isinstance($res["goalSummary"]["0"]["name"], str) and len($res["goalSummary"]["0"]["name"]) > 0

    # 3. cardRecommendation
    # 4. listRecommendation
