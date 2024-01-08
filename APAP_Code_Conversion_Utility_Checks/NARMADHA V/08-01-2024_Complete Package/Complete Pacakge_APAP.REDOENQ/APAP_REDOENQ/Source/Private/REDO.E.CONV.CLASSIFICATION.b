* @ValidationCode : MjotMTg1ODM2NDI2OTpDcDEyNTI6MTY4MjA3MzM4MzAwNTpJVFNTOi0xOi0xOi0xNToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 21 Apr 2023 16:06:23
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -15
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CONV.CLASSIFICATION
*-----------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: RAMKUMAR G
* PROGRAM NAME: REDO.E.CONV.CLASSIFICATION
* ODR NO      : ODR-2010-03-0177
*----------------------------------------------------------------------
* DESCRIPTION  : This is a conversion routine attached to the Enquiry
*                REDO.ENQ.FROZ.ACCT which display the selection fields
*                based on Values inputted by the USER
*
* IN PARAMETER : O.DATA
* OUT PARAMETER: O.DATA
* LINKED WITH  :
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*    DATE        WHO           REFERENCE         DESCRIPTION
* 19 Nov 2010  RAMKUMAR G  ODR-2010-03-0177   INITIAL CREATION

* 17-APR-2023     Conversion tool   R22 Auto conversion   SM to @SM
* 17-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
*
    GOSUB PROCESS
*
RETURN

*-------
PROCESS:
*-------
    Y.FINAL = ''
* Locate the values
*
    LOCATE "ACCOUNT.TYPE" IN D.FIELDS<1> SETTING Y.AC.TY.POS THEN
        Y.AC.TYPE               = D.RANGE.AND.VALUE<Y.AC.TY.POS>
        IF Y.FINAL THEN
            Y.FINAL := ",Account Type - ":Y.AC.TYPE
        END ELSE
            Y.FINAL = "Account Type - ":Y.AC.TYPE
        END
    END
*
    LOCATE "NOTIFICATION" IN D.FIELDS<1> SETTING Y.NOTIF.POS THEN
        Y.NOTIF                = D.RANGE.AND.VALUE<Y.NOTIF.POS>
        IF Y.FINAL THEN
            Y.FINAL := ",Notification - ":Y.NOTIF
        END ELSE
            Y.FINAL = "Notification - ":Y.NOTIF
        END
    END
*
    LOCATE "BLOCK" IN D.FIELDS<1> SETTING Y.BLOCK.POS THEN
        Y.BLOCK.GARNISHMENT = D.RANGE.AND.VALUE<Y.BLOCK.POS>
        IF Y.FINAL THEN
            Y.FINAL := ",Blocked Pledge/Garnishment - ":Y.BLOCK.GARNISHMENT
        END ELSE
            Y.FINAL = "Blocked Pledge/Garnishment - ":Y.BLOCK.GARNISHMENT
        END
    END
*
    LOCATE "DATE.RANGE" IN D.FIELDS<1> SETTING Y.DATE.POS THEN
        Y.DATE               = D.RANGE.AND.VALUE<Y.DATE.POS>
        CHANGE @SM TO ' RG ' IN Y.DATE
        IF Y.FINAL THEN
            Y.FINAL := ",Date - ":Y.DATE
        END ELSE
            Y.FINAL = "Date - ":Y.DATE
        END
    END
*
    IF Y.FINAL EQ '' THEN
        O.DATA = 'ALL'
    END ELSE
        O.DATA = Y.FINAL
    END
*
RETURN
END
