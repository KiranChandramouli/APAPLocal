* @ValidationCode : MjoyMDExNTUyNDE4OlVURi04OjE3MDI5NzUyNTg4NDE6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Dec 2023 14:10:58
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.TRG.OFS.STRING(Y.LIST.NAME)
*------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*21-04-2023       Conversion Tool        R22 Auto Code conversion          INSERT FILE MODIFIED,COUNT.I + 1 TO +=1
*21-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*19-12-2023    Narmadha V          Manual R22 Conversion    Call Routine Format Modified
*------------------------------------------------------------------------------------------

*Routine to process OFS STRING. OFS STRING are stored in savedlists STRING.IDS

    $INSERT I_COMMON   ;*R22 AUTO CODE CONVERSION
    $INSERT I_EQUATE    ;*R22 AUTO CODE CONVERSION
    $USING  EB.Interface ;*Manual R22 Conversion

    GOSUB INITIALISE
    GOSUB PROCESS
RETURN
********************************************************************************
INITIALISE:
    OPEN '','&SAVEDLISTS&' TO SAVEDLISTS ELSE
        ERR.OPEN ='EB.RTN.CANT.OPEN.&SAVEDLISTS'
    END
    options = ''; OFS.REQ = ''; theResponse = ''
    options<1> = "AA.COB"

RETURN
********************************************************************************
PROCESS:

*READ OFS.LIST FROM SAVEDLISTS,'STRING.IDS' ELSE
*PRINT 'CANNOT READ SAVEDLIST'
*END
    Y.LIST.NAME = 'STRING.IDS'
    READ OFS.LIST FROM SAVEDLISTS,Y.LIST.NAME ELSE
        PRINT 'CANNOT READ SAVEDLIST'
    END
    COUNT.I = 0
    LOOP
        REMOVE STR.ID FROM OFS.LIST SETTING STR.POS
    WHILE STR.ID:STR.POS
        COUNT.I += 1     ;*R22 AUTO CODE CONVERSION
*CRT "Processing string count = ":COUNT.I
*CRT "Processing string = ":STR.ID
        OFS.REQ = STR.ID
*CALL OFS.CALL.BULK.MANAGER(options,OFS.REQ,theResponse,'')
        EB.Interface.OfsCallBulkManager(options,OFS.REQ,theResponse,'') ;*Manual R22 Conversion - Call Routine Modified
*CRT "Response ":theResponse
        theResponse = ''
    REPEAT
RETURN
END
