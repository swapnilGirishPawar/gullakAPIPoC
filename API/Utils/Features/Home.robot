*** Settings ***
Library     RequestsLibrary
Resource    ../../Tests/FileImports.robot


*** Keywords ***
User
    [Arguments]    ${accessToken}    ${expected_status}=200
    ${payload}=    Create Dictionary    Name=MYUSER    age=22
    ${headers}=    Create Dictionary    Content-Type=application/json    X-Login-Token=${accessToken}
    ${res}=    POST On Session    gullak    /user    json=${payload}    headers=${headers}
    ...    expected_status=${expected_status}
    Log API response    ${res}
    RETURN    ${res.json()}

Home
    [Arguments]    ${accessToken}    ${expected_status}=200
    ${payload}=    Create Dictionary    apps=
    ${headers}=    Create Dictionary    Content-Type=application/json    X-Login-Token=${accessToken}
    ${res}=    GET On Session    gullak    /home    json=${payload}    headers=${headers}
    ...    expected_status=${expected_status}
    Log API response    ${res}
    RETURN    ${res.json()}