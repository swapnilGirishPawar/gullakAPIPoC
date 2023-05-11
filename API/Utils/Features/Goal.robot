*** Settings ***
Library     RequestsLibrary
Resource    ../../Tests/FileImports.robot

*** Keywords ***
newApiCall
    [Arguments]    ${accessToken}    ${expected_status}=200
    ${payload}=    Create Dictionary    
    ${headers}=    Create Dictionary    Content-Type=application/json    X-Login-Token=${accessToken}
    ${res}=    GET On Session    gullak    /...    json=${payload}    headers=${headers}
    ...    expected_status=${expected_status}
    Log API response    ${res}
    RETURN    ${res.json()}