* @ValidationCode : MjotNjExOTIyNzU1OkNwMTI1MjoxNjgzMTE1MTE1ODM1OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 03 May 2023 17:28:35
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
SUBROUTINE REDO.FORM.MESSAGE(VAR.AC.ID)

*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This deal slip routine to form the message for loan rate change.
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : TXN.ARRAY
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : H GANESH
* PROGRAM NAME : REDO.FORM.MESSAGE
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*10 Sep 2011     H Ganesh        PACS00113076 - B.16  INITIAL CREATION

* 06.04.2023       Conversion Tool       R22            Auto Conversion     - VM TO @VM
* 06.04.2023       Shanmugapriya M       R22            Manual Conversion   - Add call routine prefix
* -----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER


    GOSUB PROCESS
RETURN
*---------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------

    FN.REDO.NOTIFY.RATE.CHANGE = 'F.REDO.NOTIFY.RATE.CHANGE'
    F.REDO.NOTIFY.RATE.CHANGE = ''
    CALL OPF(FN.REDO.NOTIFY.RATE.CHANGE,F.REDO.NOTIFY.RATE.CHANGE)


    Y.ARR.ID = ''
*CALL REDO.CONVERT.ACCOUNT(VAR.AC.ID,Y.ARR.ID,OUT.ID,ERR.TEXT)
** R22 Manual conversion
* CALL APAP.TAM.REDO.CONVERT.ACCOUNT(VAR.AC.ID,Y.ARR.ID,OUT.ID,ERR.TEXT)
    CALL APAP.TAM.redoConvertAccount(VAR.AC.ID,Y.ARR.ID,OUT.ID,ERR.TEXT)
    VAR.AA.ID = OUT.ID
    CALL F.READ(FN.REDO.NOTIFY.RATE.CHANGE,VAR.AA.ID,R.NOTIFY.DETAIL,F.REDO.NOTIFY.RATE.CHANGE,NOTIFY.ERR)

    Y.MSG = R.NOTIFY.DETAIL<1>

    VAR.AC.ID = Y.MSG[1,65]:@VM:'    ':Y.MSG[66,65]:@VM:'    ':Y.MSG[132,25]


RETURN
END
