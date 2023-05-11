*** Settings ***
Library     RequestsLibrary
Library     OperatingSystem
Resource    ../Tests/FileImports.robot


*** Keywords ***
Load test data
    ${filePath}=    Join Path    API    Utils    TestData.json
    ${testDataFileContent}=    Get File    ${filePath}
    ${TEST_DATA}=    Evaluate    json.loads("""${testDataFileContent}""")
    Set Global Variable    ${TEST_DATA}

Prelauncher setup
    Create API session    gullak    ${API_HOST}
    Load test data
    # Login ID
    ${mobileNumber}=    Get random mobile number from the test data
    ${res}=    Trigger OTP    ${mobileNumber}    abcd
    ${LOGIN_ID}=    Set Variable    ${res}[id]
    Set Global Variable    ${LOGIN_ID}

Create API session
    [Arguments]    ${alias}    ${url}    ${headers}=${API_HEADERS}    ${timeout}=${30}
    Create Session    alias=${alias}    url=${url}    headers=${headers}    timeout=${timeout}    verify=${False}
    ...    disable_warnings=${True}

Log It
    [Arguments]    ${message}    ${level}=INFO
    Log    ${message}    level=${level}    console=${True}

Log pretty
    [Arguments]    ${msg}    ${obj}    ${console}=${True}
    ${content}=    Evaluate    json.dumps(${obj}, indent=4, ensure_ascii=False)
    Log It    ${msg}:${content}

Log API response
    [Arguments]    ${res}
    Log It    \nResponse Status Code: ${res.status_code}
    TRY
        Log pretty    Json Response Body:    ${res.json()}
    EXCEPT
        Log It    ***No Json Response***
        Log It    Response Text: ${res.text}
    END
    Log pretty    Response Headers:    ${res.headers}
