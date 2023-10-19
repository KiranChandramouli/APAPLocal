* @ValidationCode : MjoxODc1MzgzMzM5OkNwMTI1MjoxNjgwNzE4ODA2MzEyOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Apr 2023 23:50:06
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.GET.FINAL.ACCOUNT
************************************************************
*----------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : SHANKAR RAJU
* Program Name : REDO.GET.FINAL.ACCOUNT
*----------------------------------------------------------

* Description   :
* Linked with   :
* In Parameter  : None
* Out Parameter : None
*----------------------------------------------------------------------
*DATE           WHO             REFERENCE         DESCRIPTION
*10.10.2010   SHANKAR RAJU     ODR-2010-08-0031   INITIAL CREATION
*06.04.2023   Conversion Tool       R22            Auto Conversion     - No changes
*06.04.2023   Shanmugapriya M       R22            Manual Conversion   - No changes
*
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.CLOSE.ACCT
    $INSERT I_EB.EXTERNAL.COMMON
    $INSERT I_System

    GOSUB OPEN
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
OPEN:
    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.CLOSE.ACCT ='F.REDO.CLOSE.ACCT'
    F.REDO.CLOSE.ACCT = ''
    CALL OPF(FN.REDO.CLOSE.ACCT,F.REDO.CLOSE.ACCT)


RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    BACK.ODATA = O.DATA

    CALL F.READ(FN.REDO.CLOSE.ACCT,O.DATA,R.REDO.CLOSE.ACCT,F.REDO.CLOSE.ACCT,ERR.CLS.AC)

    IF R.REDO.CLOSE.ACCT THEN
        IF R.REDO.CLOSE.ACCT<REDO.ACCT.LIQ.ACCOUNT> NE '' THEN
            O.DATA = R.REDO.CLOSE.ACCT<REDO.ACCT.LIQ.ACCOUNT>
        END
    END ELSE
        O.DATA = BACK.ODATA
    END

RETURN
*-----------------------------------------------------------------------------
END
