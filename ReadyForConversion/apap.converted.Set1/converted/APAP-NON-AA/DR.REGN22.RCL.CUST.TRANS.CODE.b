*
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE DR.REGN22.RCL.CUST.TRANS.CODE
    $INSERT I_COMMON
    $INSERT I_EQUATE

    TRANS.CODE = COMI
    BEGIN CASE
        CASE TRANS.CODE EQ 'BUY'
            CUS.TRAN.CODE = 'C'
        CASE TRANS.CODE EQ 'SEL'
            CUS.TRAN.CODE = 'V'
    END CASE

    COMI = CUS.TRAN.CODE

RETURN
END
