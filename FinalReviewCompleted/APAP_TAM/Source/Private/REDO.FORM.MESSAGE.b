* @ValidationCode : MjotNjExOTIyNzU1OkNwMTI1MjoxNjg0ODQyMTAwOTYyOklUU1M6LTE6LTE6MTkwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 17:11:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 190
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
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
