* @ValidationCode : MjoyMTE2MDg4NzQ2OkNwMTI1MjoxNjgxMjk1Mjg5OTgzOmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Apr 2023 15:58:09
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*12-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   VM to @VM , SM to @SM
*12-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




SUBROUTINE REDO.APAP.DT.PYMT.INS(PYMT.INS)
*---------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : GANESH R
* Program Name  : REDO.APAP.DT.PYMT.INS
* ODR NUMBER    : ODR-2010-07-0074
*----------------------------------------------------------------------------------

*Description:  REDO.APAP.DT.PYMT.INS is a deal slip routine for the DEAL.SLIP.FORMAT FX.DEAL.TICKET,
*              the routine reads the field value from OUR.ACCOUNT.PAY and
*              if not then reads from CPARTY.CORR.NO+CPY.CORR.ADD+CPARTY.BANK.ACC
* In parameter  : None
* out parameter : PYMT.INS
*----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FOREX

    GOSUB PROCESS.PARA
RETURN

PROCESS.PARA:
    GOSUB GET.PYMT.INS
RETURN

GET.PYMT.INS:
*Get the Payment Details

    IF R.NEW(FX.OUR.ACCOUNT.PAY) THEN
        PYMT.INS  = R.NEW(FX.OUR.ACCOUNT.PAY)
    END
    ELSE
        Y.CPARTY.NO = R.NEW(FX.CPARTY.CORR.NO)
        Y.CPY.ADD = R.NEW(FX.CPY.CORR.ADD)
        CHANGE @VM TO ' ' IN Y.CPY.ADD
        CHANGE @SM TO ' ' IN Y.CPY.ADD
        Y.CPY.BANK.ACC = R.NEW(FX.CPARTY.BANK.ACC)
        PYMT.INS = Y.CPARTY.NO:' ':Y.CPY.ADD:' ':Y.CPY.BANK.ACC
        RETURN
    END
END
