* @ValidationCode : Mjo1MDI2NzExMDc6Q3AxMjUyOjE2ODM4OTI2MjM3NDY6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 May 2023 17:27:03
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.GET.DISBURSED.AMT(ARR.ID,Y.DISB.AMOUNT)
*---------------------------------------------------------
*Description: This routine returns the disbursed amount of the loan.
* Input Arg  :  Arrangement ID.
* Output Arg :  Disbursed Amount.
** 10-04-2023 R22 Auto Conversion no changes
** 10-04-2023 Skanda R22 Manual Conversion - No changes
*---------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE


    GOSUB INIT
    GOSUB PROCESS
RETURN
*---------------------------------
INIT:
*---------------------------------
    Y.DISB.AMOUNT = 0
RETURN
*---------------------------------
PROCESS:
*---------------------------------

    IF ARR.ID ELSE
        RETURN
    END
    IN.PROPERTY.CLASS = 'TERM.AMOUNT'
    R.OUT.AA.RECORD   = ''
    OUT.PROPERTY      = ''
*    CALL REDO.GET.PROPERTY.NAME(ARR.ID,IN.PROPERTY.CLASS,R.OUT.AA.RECORD,OUT.PROPERTY,OUT.ERR)
    CALL APAP.TAM.redoGetPropertyName(ARR.ID,IN.PROPERTY.CLASS,R.OUT.AA.RECORD,OUT.PROPERTY,OUT.ERR) ;* R22 Menaul Conversion

    IN.ACC.ID = ''
    OUT.ID = ''
*    CALL REDO.CONVERT.ACCOUNT(IN.ACC.ID,ARR.ID,OUT.ID,ERR.TEXT)
    CALL APAP.TAM.redoConvertAccount(IN.ACC.ID,ARR.ID,OUT.ID,ERR.TEXT) ;* R22 Menaul Conversion
    Y.ARR.ACC.ID = OUT.ID
    BALANCE.TO.CHECK = 'CUR':OUT.PROPERTY
    CUR.AMOUNT=''
    Y.TODAY = TODAY
    CALL AA.GET.ECB.BALANCE.AMOUNT(Y.ARR.ACC.ID,BALANCE.TO.CHECK,Y.TODAY,CUR.AMOUNT,RET.ERROR)
    CUR.AMOUNT = ABS(CUR.AMOUNT)

    BALANCE.TO.CHECK = 'TOT':OUT.PROPERTY
    TOT.AMOUNT       = ''
    CALL AA.GET.ECB.BALANCE.AMOUNT(Y.ARR.ACC.ID,BALANCE.TO.CHECK,Y.TODAY,TOT.AMOUNT,RET.ERROR)
    TOT.AMOUNT = ABS(TOT.AMOUNT)

    Y.DISB.AMOUNT = TOT.AMOUNT - CUR.AMOUNT

RETURN
END
