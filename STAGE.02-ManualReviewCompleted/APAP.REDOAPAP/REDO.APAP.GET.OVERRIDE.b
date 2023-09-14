* @ValidationCode : MjotMTMwNDYxMjQ3NzpDcDEyNTI6MTY4MDY3NjY0ODU3NzpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Apr 2023 12:07:28
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
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.GET.OVERRIDE

* Description: This routine is the nofile enquiry routine to fetch the details of
* account closure records in INAO status

*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 26-02-2011      H GANESH      PACS00034162    Initial Draft
* Date                  who                   Reference              
* 05-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION VM TO @VM AND FM TO @FM AND ++ TO += 1 
* 05-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
* ----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.USER

    GOSUB PROCESS
RETURN

* ---------------------------------------------------------------------------
PROCESS:
* ----------------------------------------------------------------------------

    MESS=O.DATA
    MSG = ''
    CTR = 0
    NO.OF.MSG = DCOUNT(MESS,@VM)
    Y.VAR2=1
    LOOP
    WHILE Y.VAR2 LE NO.OF.MSG
        MAIN.TEXT = MESS<1,Y.VAR2,1>
        OVER.CLASS.TEXT = ''
        IF MESS<1,Y.VAR2,2> THEN
            OVER.CLASS.TEXT := '*':MESS<1,Y.VAR2,2>
        END
        IF MESS<1,Y.VAR2,3> THEN
            OVER.CLASS.TEXT := '*':MESS<1,Y.VAR2,3>
        END
        CHANGE '~' TO @FM IN MAIN.TEXT

        CHANGE '{' TO @FM IN MAIN.TEXT

        CHANGE '}' TO @VM IN MAIN.TEXT

        CALL TXT(MAIN.TEXT)
        IF CTR EQ 0 THEN
            MSG = MAIN.TEXT:OVER.CLASS.TEXT
            CTR = 1
        END ELSE
            MSG = MSG:@VM:MAIN.TEXT:OVER.CLASS.TEXT
        END
        Y.VAR2 += 1  ;*R22 AUTO CONVERSTION ++ TO += 1
    REPEAT
    O.DATA=MSG

RETURN
END
