SUBROUTINE REDO.V.AUT.AML.CCY
****************************************************************
*-------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : SUDHARSANAN S
* Program Name : REDO.V.AUT.AML.CCY
* ODR NUMBER : ODR-2009-10-0472
*-------------------------------------------------------------------------

* Description : This Auth routine is attached to the VERSION.CONTROL record of CURRENCY table
* It is used to update the field AMT.LIMIT.LCY in REDO.AML.PARAM table

* In parameter : None
* out parameter : None

*----------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CURRENCY
    $INSERT I_F.REDO.AML.PARAM

*
    GOSUB INIT
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------
*****
INIT:
*****
*
    FN.CURRENCY='F.CURRENCY'
    F.CURRENCY=''
    CALL OPF(FN.CURRENCY,F.CURRENCY)

    FN.REDO.AML.PARAM='F.REDO.AML.PARAM'
    F.REDO.AML.PARAM=''
    CALL OPF(FN.REDO.AML.PARAM,F.REDO.AML.PARAM)

    LREF.APP='CURRENCY'
    LREF.FIELD='L.CU.AMLBUY.RT'
    LREF.POS=''
    CALL GET.LOC.REF(LREF.APP,LREF.FIELD,LREF.POS)

RETURN
*--------
PROCESS:
*--------
*Update the field AMT.LIMIT.LCY in REDO.AML.PARAM table
    Y.AML.RATE=R.NEW(EB.CUR.LOCAL.REF)<1,LREF.POS>
    Y.AML.ID='SYSTEM'
    CALL CACHE.READ(FN.REDO.AML.PARAM,Y.AML.ID,R.AML.PARAM,AML.ERR)
    Y.AML.CCY = R.AML.PARAM<AML.PARAM.AML.CCY>
    IF ID.NEW EQ Y.AML.CCY THEN
        Y.AMT.FCY=R.AML.PARAM<AML.PARAM.AMT.LIMIT.FCY>
        R.AML.PARAM<AML.PARAM.AMT.LIMIT.LCY>=Y.AMT.FCY*Y.AML.RATE
        CALL F.WRITE(FN.REDO.AML.PARAM,Y.AML.ID,R.AML.PARAM)
    END
RETURN
*------------------
END
