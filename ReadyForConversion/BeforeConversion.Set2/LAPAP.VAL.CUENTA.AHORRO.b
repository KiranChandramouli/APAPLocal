*-----------------------------------------------------------------------------
* <Rating>-22</Rating>
*-----------------------------------------------------------------------------
*-------------------------------------------------------------------------------------
* Item ID        : CN009003
*-------------------------------------------------------------------------------------
* Description :
* ------------
*This program raise error if Account doesnt belong to Saving Account
*-------------------------------------------------------------------------------------
* Modification History :
* ----------------------
* Date           Author            Modification Description
* -------------  -----------       ---------------------------
* 2018/11/14     Raquel P.S.         Initial development
*-------------------------------------------------------------------------------------
* Content summary :
* -----------------
* Versions  : TELLER,L.APAP.NOMINA
* EB record : LAPAP.VAL.CUENTA.AHORRO
*-------------------------------------------------------------------------------------

    SUBROUTINE LAPAP.VAL.CUENTA.AHORRO

    $INCLUDE T24.BP I_COMMON
    $INCLUDE T24.BP I_EQUATE
    $INCLUDE T24.BP I_F.TELLER
    $INCLUDE T24.BP I_GTS.COMMON
    $INCLUDE T24.BP I_F.ACCOUNT


**Tables Loading
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT, F.ACCOUNT)

**Getting initial variables
    Y.ID.AC=COMI

**Evaluation of Account Category
    CALL F.READ(FN.ACCOUNT ,Y.ID.AC,R.ACCOUNT, F.ACCOUNT, AC.ERR)
    Y.CATEGORY   = R.ACCOUNT<AC.CATEGORY>

    IF Y.CATEGORY NE '' AND Y.ID.AC NE ''
    THEN
        GOSUB EVALUATE.CATEG
    END ELSE
        RETURN
    END

***************
EVALUATE.CATEG:
***************
    IF (Y.CATEGORY GE 6001 AND Y.CATEGORY LT 6011 ) OR (Y.CATEGORY GE 6021 AND Y.CATEGORY LT 6099) OR (Y.CATEGORY GE 6500 AND Y.CATEGORY LT 6599)
    THEN
        RETURN
    END ELSE
        GOSUB RAISE.ERROR
    END
    RETURN

***************
RAISE.ERROR:
***************
    ETEXT='ERROR: CUENTA NO CORRESPONDE A CATEGORIA DE AHORRO'
    CALL STORE.END.ERROR
    RETURN

END