*** Settings ***
Library     RequestsLibrary
Resource    ../../Tests/FileImports.robot


*** Keywords ***
Guess the OTP
    ${otp}=    Evaluate    int(arrow.now().format("YYMMDD"))
    RETURN    ${otp}

Get random mobile number from the test data
    ${mobileNumber}=    Evaluate    random.choice(${TEST_DATA}[mobileNumbers])
    RETURN    ${mobileNumber}
