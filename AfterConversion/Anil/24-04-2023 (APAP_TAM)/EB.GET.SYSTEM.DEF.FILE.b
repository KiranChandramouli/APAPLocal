* @ValidationCode : MjoyMTQ3NDQ5MzM0OkNwMTI1MjoxNjgyMzEzODcxMzc3OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Apr 2023 10:54:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE EB.GET.SYSTEM.DEF.FILE

************************************************************************
* Utility to get the system definition file
* TODO - Replace XX with table name
************************************************************************
*** <region name= Modification History>
***
************************************************************************
* Modification History:
*
* 23/10/09 - Creation of API
* Date                   who                   Reference              
* 24-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - $INCLUDE TO $INSERT AND = TO EQ AND I TO I.VAR AND REM TO DISPLAY.MESSAGE(TEXT, '')
* 24-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*
*-----------------------------------------------------------------------------
*** </region>
*** <region name= Inserts>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT JBC.h

*** </region>
*** <region name= Main section>

    GOSUB INITIALISE          ;* Initialise variables required

    GOSUB PROCESS   ;* to get the system definition file

RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= INIT>
INITIALISE:
***********

    THE.REQUEST = ''          ;*Hold the request
    THE.RESPONSE = ''         ;*Hold the response
    GET.COMP = ''   ;*get the component array
    REAL.COMP = ''  ;*Hold the componebts list
    PRD = ''        ;*get the product array
    REAL.PRD = ''   ;*Hold the product list
    COMP.REVISION = ''        ;*get the revision details for all component
    REAL.REVISION = ''        ;*corresponding revision for each component
    COMP.ARRAY = '' ;*Hold the compoent request array
    NEW.LINE = CHARX(010)     ;*new line char
    TAB = CHARX(009)          ;* Tab char
RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= PROCESS>
PROCESS:
********
    REQUEST = "READ.SPF"      ;*assign the request as READ.SPF
    GOSUB ADD.REQUEST         ;*form THE.REQUEST
    CALL EB.SYSTEM.INFO(THE.REQUEST, THE.RESPONSE, '', '')  ;*get the SPF informations
* THE.RESPONSE is in encrypted for so, decrypt the response
    THE.RESPONSE = FIELD(THE.RESPONSE,'<xmlRecord>',2)      ;*get the encrption part
    THE.RESPONSE = FIELD(THE.RESPONSE,'</xmlRecord>',1,1)
    THE.RESPONSE = DECRYPT(THE.RESPONSE, '', JBASE_CRYPT_BASE64 )     ;*decrypt the response
    SPF.RESPONSE = THE.RESPONSE         ;*assign this response as SPF.RESPONSE

    REQUEST = "READ.JDIAG"    ;*Assign the request as READ.JDIAG
    GOSUB ADD.REQUEST         ;*form THE.REQUEST
    CALL EB.SYSTEM.INFO(THE.REQUEST, THE.RESPONSE, '', '')  ;*Get th jdiag information
    JDIAG.RESPONSE = THE.RESPONSE       ;*assign this response as JDIAG.RESPONSE

    REQUEST = "READ.PRODUCT.COMPONENTS" ;*Request is READ.PRODUCT.COMPONENTS
    GOSUB ADD.REQUEST         ;*form the request
    CALL EB.SYSTEM.INFO(THE.REQUEST, THE.RESPONSE, '', '')  ;*get the installed components informations
    COMPONENTS.RESPONSE = THE.RESPONSE  ;*assign this response as COMPONENT.RESPONSE

    REQUEST = "T24.libs"      ;*Assign the request as T24.libs
    GOSUB ADD.REQUEST         ;*form the request
    CALL EB.SYSTEM.INFO(THE.REQUEST, THE.RESPONSE, '', '')  ;*get the revision of each component
    T24.libs.RESPONSE = THE.RESPONSE    ;*assign this response as T24.libs.RESPONSE

    REQUEST = "TAF.libs"      ;*Request is TAF.libs
    GOSUB ADD.REQUEST         ;*form the request
    CALL EB.SYSTEM.INFO(THE.REQUEST, THE.RESPONSE, '', '')  ;*get the component revision details of TAFC and TAFJ
    TAF.libs.RESPONSE = THE.RESPONSE    ;*assign this response as TAF.libs.RESPONSE

    REQUEST = 'CREATE.SYS.DEF'          ;*To get the system definition file
    GOSUB ADD.REQUEST         ;*form the request

    GOSUB SYSTEM.NAME         ;*  ;*get the system name
    GOSUB GET.COMPONENTS      ;* get the component lists
    GOSUB GET.REVISION        ;* get the revision details of each component
    GOSUB BUILD.COMPONENTS    ;*form the component list with revision and product
    GOSUB BUILD.SYS.DEF.REQUEST         ;*build the final request
RETURN


*** </region>
*-----------------------------------------------------------------------------
*** <region name= ADD.REQUEST>
ADD.REQUEST:
*** <desc> form the request details </desc>

    IF REQUEST EQ 'CREATE.SYS.DEF' THEN  ;*request is a CREATE.SYS.DEF dont add the </requestParams> tag
        THE.REQUEST = '<action>':REQUEST:'</action><responseEncryption></responseEncryption><requestEncryption></requestEncryption><requestParams>'
    END ELSE
        THE.REQUEST = '<action>':REQUEST:'</action><responseEncryption></responseEncryption><requestEncryption></requestEncryption><requestParams></requestParams>'
    END
RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= SYSTEM.NAME>
SYSTEM.NAME:
*** <desc> extract the system name from SPF.RESPONSE </desc>

    TOT = DCOUNT(SPF.RESPONSE,'<field name="')    ;*count the total number of fields
    FOR I.VAR = 1 TO TOT
        RESP = FIELD(SPF.RESPONSE,'<field name="',I.VAR+1,1)    ;*get each fied and value
        IF RESP[1,9] EQ "SITE.NAME" THEN          ;*check whether the field name is SITE.NAME
            RESULT = FIELD(RESP,'>',2,1)          ;*get the field name with value
            TOT.LEN = LEN(RESULT)
            SYS.NAME = RESULT[1,TOT.LEN-7]        ;*get the value of the field (i.e: system name)
            I.VAR = TOT
        END
    NEXT I.VAR
RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= GET.COMPONENTS>
GET.COMPONENTS:
*** <desc> Extract the component and product information from COMPONENTS.RESPONSE</desc>

    TOT.COMP = DCOUNT(COMPONENTS.RESPONSE,'<component id=') ;*count the total number of components
    FOR I.VAR = 1 TO TOT.COMP
        GET.COMP<I.VAR> = FIELD(COMPONENTS.RESPONSE,'<component id=',I.VAR+1,1)         ;*get eache companent name with product name
        REAL.COMP<I.VAR> = FIELD(GET.COMP<I.VAR>,' desc="',1,1)     ;* save component name separately
        PRD<I.VAR> = FIELD(GET.COMP<I.VAR>,'product=',2,1)          ;*get the product details
        REAL.PRD<I.VAR> = PRD<I.VAR>[1,4]       ;*save the product information separately
    NEXT I.VAR
RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= GET.REVISION>
GET.REVISION:
*** <desc> </desc>

    FOR I.VAR = 1 TO TOT.COMP
        COMP.REVISION<I.VAR> = FIELD(T24.libs.RESPONSE,REAL.COMP<I.VAR>,2,1)  ;*get the revision for each component T24.libs.RESPONSE
        IF NOT(COMP.REVISION<I.VAR>) THEN
            COMP.REVISION<I.VAR> = FIELD(TAF.libs.RESPONSE,REAL.COMP<I.VAR>,2,1)        ;*if component may present in AF.libs.RESPONSE
        END
        REAL.REVISION<I.VAR> = FIELD(COMP.REVISION<I.VAR>,'/>',1,1) ;*get the revision nymber from the tag value
    NEXT I.VAR
RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= BUILD.COMPONENTS>
BUILD.COMPONENTS:
*** <desc> form the component array with component name,product name and revision number</desc>

    FOR I.VAR = 1 TO TOT.COMP
        IF REAL.COMP<I.VAR> AND REAL.REVISION<I.VAR> AND REAL.PRD<I.VAR> THEN     ;*if component,revision and product is present in the saved list
            COMP.ARRAY:='<component name=':REAL.COMP<I.VAR>:REAL.REVISION<I.VAR>:' product=':REAL.PRD<I.VAR>:' />'        ;*form the component array
        END
    NEXT I.VAR
RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= BUILD.SYS.DEF.REQUEST>
BUILD.SYS.DEF.REQUEST:
*** <desc> build the request to get the system definition information and save the response to a file</desc>

    FINAL.REQUEST =THE.REQUEST:'<sysDef><systemDesc>':SYS.NAME:'</systemDesc><components>':COMP.ARRAY:'</components></sysDef></requestParams>'        ;*Form the request to get the system definition file
    THE.REQUEST = FINAL.REQUEST         ;*assign this request as THE.REQUEST
    CALL EB.SYSTEM.INFO(THE.REQUEST, THE.RESPONSE, '', '')  ;*get the sys definition information
*response is in encrypted form, so decrypt it
    THE.RESPONSE = FIELD(THE.RESPONSE,'<sysdef>',2,1)       ;*get the encrypted portion of the code
    SYS.DEFINITION.FILE = FIELD(THE.RESPONSE,'</sysdef>',1,1)
    SYS.DEFINITION.FILE = DECRYPT(SYS.DEFINITION.FILE, '', JBASE_CRYPT_BASE64 ) ;*decrypt the information
    CHANGE '><' TO '>':NEW.LINE:'<' IN SYS.DEFINITION.FILE  ;*allign the response
    CHANGE '<data' TO TAB:'<data' IN SYS.DEFINITION.FILE    ;*allign the response
    OPEN '','F.UPDATES.XML' TO F.UPDATES.XML ELSE ;* open the file UPDATE.XML from run directory
        EXE.CMD = "CREATE.FILE F.UPDATES.XML TYPE=UD"       ;*if file not present then create the file
        EXECUTE EXE.CMD
        OPEN '','F.UPDATES.XML' TO F.UPDATES.XML ELSE       ;*get the file path
            E = "UNABLE TO OPEN F.UPDATES.XML"    ;*still file not present thrown an error message
            CALL STORE.END.ERROR
        END
    END
    IF NOT(E) THEN
        WRITE SYS.DEFINITION.FILE TO F.UPDATES.XML,SYS.NAME:"_SysDef.xml"       ;*write this system definition file to UPDATES.XML
        TEXT = "UPDATES XML CREATED"
        CALL TXT(TEXT)
        CALL DISPLAY.MESSAGE(TEXT, '')  ;*R22 AUTO CONVERSTION REM TO DISPLAY.MESSAGE(TEXT, '')
    END
RETURN

*** </region>
*-----------------------------------------------------------------------------
END
