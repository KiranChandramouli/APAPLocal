$PACKAGE APAP.TAM
SUBROUTINE REDO.NO.PAY.MADE(NO.OF.PAID)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :PRABHU.N
*Program   Name    :REDO.V.VAL.ADV.AMT
*---------------------------------------------------------------------------------

*DESCRIPTION       :It is a deal slip routine for FT and TT payment
*LINKED WITH       :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who           Reference            Description
* 3-JUN-2010        Prabhu.N       ODR-2010-01-0081    Initial Creation
** 13-04-2023 R22 Auto Conversion no changes
** 13-04-2023 Skanda R22 Manual Conversion - No changes
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.ACCOUNT


    FN.AA.ACCOUNT.DETAILS='F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS =''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)
    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    VAR.AC.ID=NO.OF.PAID
    CALL F.READ(FN.ACCOUNT,VAR.AC.ID,R.ACCOUNT,F.ACCOUNT,ERR)
    VAR.AA.ID=R.ACCOUNT<AC.ARRANGEMENT.ID>

    CALL F.READ(FN.AA.ACCOUNT.DETAILS,VAR.AA.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,ERR)
    VAR.SET.STATUS.LIST=R.AA.ACCOUNT.DETAILS<AA.AD.SET.STATUS>
    NO.OF.PAID=COUNT(VAR.SET.STATUS.LIST,'REPAID')
RETURN
END
