$PACKAGE APAP.TAM
SUBROUTINE REDO.VAL.DEFAULT.CURRENCY
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This Auto New content routine is used to dispaly to default currency
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.VAL.DEFAULT.CURRENCY
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE         DESCRIPTION
* PROGRAM NAME : REDO.VAL.DEFAULT.CURRENCY

** 18-04-2023 R22 Auto Conversion 
** 18-04-2023 Skanda R22 Manual Conversion - No changes
*-----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_System
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.PAYMENT.STOP.ACCOUNT

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    R.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    Y.ACC.ID = System.getVariable("CURRENT.ACCT.NO")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;* R22 Auto conversion 
        Y.ACC.ID = "" ;* R22 Auto conversion
    END ;* R22 Auto conversion
    CALL F.READ(FN.ACCOUNT,Y.ACC.ID,R.ACCOUNT,F.ACCOUNT,Y.ERR)
    Y.CURR = R.ACCOUNT<AC.CURRENCY>
    R.NEW(REDO.PS.ACCT.CURRENCY) = Y.CURR
RETURN
END
