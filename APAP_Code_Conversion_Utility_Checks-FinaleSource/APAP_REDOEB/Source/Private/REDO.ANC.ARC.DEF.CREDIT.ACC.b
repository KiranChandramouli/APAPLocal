* @ValidationCode : MjotMjE0MTQyNzMyMjpVVEYtODoxNzAyOTkwNjMxOTQ0OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Dec 2023 18:27:11
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOEB
SUBROUTINE REDO.ANC.ARC.DEF.CREDIT.ACC
*-------------------------------------------------------

*Comments
*-------------------------------------------------------

*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 12-APR-2023     Conversion tool   R22 Auto conversion   FM TO @FM, VM to @VM
* 12-APR-2023      Harishvikram C   Manual R22 conversion      No changes
* 18-12-2023      Narmadha V        Manual R22 Conversion   Change Hardcoded value to ID variable.
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AI.REDO.ARCIB.PARAMETER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.STANDING.ORDER


    FN.AI.REDO.ARCIB.PARAMETER = 'F.AI.REDO.ARCIB.PARAMETER'
    F.AI.REDO.ARCIB.PARAMETER  = ''
    Y.ID = "SYSTEM"
* CALL OPF(FN.AI.REDO.ARCIB.PARAMETER,F.AI.REDO.ARCIB.PARAMETER)
* CALL CACHE.READ(FN.AI.REDO.ARCIB.PARAMETER,'SYSTEM',R.AI.REDO.ARCIB.PARAMETER,AI.REDO.ARCIB.PARAMETER.ERR)
    CALL CACHE.READ(FN.AI.REDO.ARCIB.PARAMETER,Y.ID,R.AI.REDO.ARCIB.PARAMETER,AI.REDO.ARCIB.PARAMETER.ERR) ;*Manual R22 Conversion

    IF NOT(AI.REDO.ARCIB.PARAMETER.ERR) THEN
        Y.ARC.TXN.TYPE = R.AI.REDO.ARCIB.PARAMETER<AI.PARAM.TRANSACTION.TYPE>
        Y.CR.ACCT.NO   = R.AI.REDO.ARCIB.PARAMETER<AI.PARAM.ACCOUNT.NO>
        Y.ARC.TXN.CODE = R.AI.REDO.ARCIB.PARAMETER<AI.PARAM.TRANSACTION.CODE>
    END
    CHANGE @VM TO @FM IN Y.CR.ACCT.NO
    CHANGE @VM TO @FM IN Y.ARC.TXN.CODE

    GOSUB PROCESS
RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        Y.TXN.CODE = R.NEW(FT.TRANSACTION.TYPE)
        LOCATE Y.TXN.CODE IN Y.ARC.TXN.CODE SETTING TXN.CODE.POS THEN
            R.NEW(FT.CREDIT.ACCT.NO) = Y.CR.ACCT.NO<TXN.CODE.POS>
        END
    END

    IF APPLICATION EQ 'STANDING.ORDER' THEN
        Y.TXN.CODE = R.NEW(STO.PAY.METHOD)
        LOCATE Y.TXN.CODE IN Y.ARC.TXN.CODE SETTING TXN.CODE.POS THEN
            R.NEW(STO.CPTY.ACCT.NO)  = Y.CR.ACCT.NO<TXN.CODE.POS>
        END
    END

RETURN
*---------------------------------------------------------------
END
