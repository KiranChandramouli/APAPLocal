SUBROUTINE REDO.B.CYCLE.CUS.AGE(Y.ID)
*-----------------------------------------------------------------------------------
* Description: Subroutine to cycle the age of the customers for whom the b'day falls
* on today or the number of calendar days before the last working day
* Programmer: M.MURALI (Temenos Application Management)
* Creation Date: 03 Jul 09
*-----------------------------------------------------------------------------------
* Modification History:
*
*
*-----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_REDO.B.CYCLE.CUS.AGE.COMMON

    R.CUSTOMER = ''
    Y.READ.ERR = ''
    CALL F.READ(FN.CUSTOMER, Y.ID, R.CUSTOMER, F.CUSTOMER, Y.READ.ERR)
    IF R.CUSTOMER AND NOT(Y.READ.ERR) THEN
        R.CUSTOMER<EB.CUS.LOCAL.REF, Y.LR.CU.AGE.POS> += 1
        CALL F.WRITE(FN.CUSTOMER, Y.ID, R.CUSTOMER)
    END

RETURN
*-----------------------------------------------------------------------------------
END
*-----------------------------------------------------------------------------------
