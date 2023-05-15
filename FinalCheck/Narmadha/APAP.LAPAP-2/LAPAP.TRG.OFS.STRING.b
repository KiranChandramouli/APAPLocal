* @ValidationCode : MjotMjE0NzM4MzA1MDpDcDEyNTI6MTY4MjA3MDIwMTI3NDpzYW1hcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Apr 2023 15:13:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.TRG.OFS.STRING(Y.LIST.NAME)
*------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*21-04-2023       Conversion Tool        R22 Auto Code conversion          INSERT FILE MODIFIED,COUNT.I + 1 TO +=1
*21-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*------------------------------------------------------------------------------------------

*Routine to process OFS STRING. OFS STRING are stored in savedlists STRING.IDS

    $INSERT I_COMMON   ;*R22 AUTO CODE CONVERSION
    $INSERT I_EQUATE    ;*R22 AUTO CODE CONVERSION

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
        CALL OFS.CALL.BULK.MANAGER(options,OFS.REQ,theResponse,'')
*CRT "Response ":theResponse
        theResponse = ''
    REPEAT
RETURN
END
