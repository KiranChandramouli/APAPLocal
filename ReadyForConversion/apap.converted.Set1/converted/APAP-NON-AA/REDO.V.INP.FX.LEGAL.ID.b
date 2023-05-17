SUBROUTINE REDO.V.INP.FX.LEGAL.ID
*-------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Pradeep S
* Program Name  : REDO.V.INP.FX.LEGAL.ID
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Description   : This input routine attached to Versions FOREX,REDO.APAP.SPOTDEAL & FOREX,REDO.APAP.FORWARDDEAL to default the local field L.FX.LEGAL.ID
*                 of the based on CIDENT/RTC/PASSPORT
* In parameter  : None
* out parameter : None
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Modificataion History:
*-------------------------
* Date             Author             Reference         Description
*
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FOREX
    $INSERT I_F.CUSTOMER

    GOSUB OPEN.FILES
    GOSUB GET.LOCAL.REFS
    GOSUB PROCESS

RETURN

*-----------
OPEN.FILES:
*-----------

    FN.CUST = 'F.CUSTOMER'
    F.CUST = ''
    CALL OPF(FN.CUST,F.CUST)

    Y.FX.LEGAL.ID = ''

RETURN

*---------------
GET.LOCAL.REFS:
*---------------
    Y.APPL = "CUSTOMER":@FM:"FOREX"
    Y.LOCAL.FLD = 'L.CU.CIDENT':@VM:'L.CU.RNC':@FM:'L.FX.LEGAL.ID'
    CALL MULTI.GET.LOC.REF(Y.APPL,Y.LOCAL.FLD,Y.FLD.POS)

    Y.L.CU.CIDENT.POS = Y.FLD.POS<1,1>
    Y.L.CU.RNC.POS = Y.FLD.POS<1,2>
    Y.L.FX.LEGAL.ID.POS = Y.FLD.POS<2,1>

RETURN

*--------
PROCESS:
*--------

    Y.CUS.ID = R.NEW(FX.COUNTERPARTY)
    R.CUS = ''
    CALL F.READ(FN.CUST,Y.CUS.ID,R.CUS,F.CUST,CUS.ERR)

    IF R.CUS THEN


        Y.L.CU.CIDENT = R.CUS<EB.CUS.LOCAL.REF,Y.L.CU.CIDENT.POS>
        Y.L.CU.RNC = R.CUS<EB.CUS.LOCAL.REF,Y.L.CU.RNC.POS>
        Y.CUS.LEGAL.ID = R.CUS<EB.CUS.LEGAL.ID>
        Y.CUS.NAME = R.CUS<EB.CUS.NAME.1>
        GOSUB SUB.PROCESS

        R.NEW(FX.LOCAL.REF)<1,Y.L.FX.LEGAL.ID.POS>  = Y.FX.LEGAL.ID

    END


RETURN

*-----------
SUB.PROCESS:
*------------

    BEGIN CASE

        CASE Y.L.CU.RNC NE ''

            Y.FX.LEGAL.ID = "RNC.":Y.L.CU.RNC:".":Y.CUS.NAME

        CASE Y.L.CU.CIDENT NE ''

            Y.FX.LEGAL.ID = "CIDENT.":Y.L.CU.CIDENT:".":Y.CUS.NAME

        CASE Y.CUS.LEGAL.ID NE ''

            Y.FX.LEGAL.ID = "PASSPORT.":Y.CUS.LEGAL.ID:".":Y.CUS.NAME

    END CASE

RETURN

END
