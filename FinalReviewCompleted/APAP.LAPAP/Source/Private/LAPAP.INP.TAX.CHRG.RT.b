* @ValidationCode : MjotMTA4MDc3MTE5OkNwMTI1MjoxNjg0MjIyODEwNDQwOklUU1M6LTE6LTE6MTc0OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 174
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.INP.TAX.CHRG.RT
*-----------------------------------------------------------------------------

*MODIFICATION HISTORY:

*

* DATE              WHO             REFERENCE               DESCRIPTION

* 21-APR-2023   Conversion tool     R22 Auto conversion      VM to @VM,BP is removed in Insert File
* 21-APR-2023    Narmadha V         R22 Manual Conversion    No Changes

*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.FT.TXN.TYPE.CONDITION ;*R22 Auto conversion - END

    IF V$FUNCTION EQ 'I' AND APPLICATION EQ 'FUNDS.TRANSFER' THEN
        GOSUB ABRIDORES
        GOSUB BUSCAR.TXN.TYPE

    END
RETURN          ;*Fin del codigo alcanzable
ABRIDORES:
    FN.FTCT = "F.FT.COMMISSION.TYPE"
    FV.FTCT = ""
    R.FTCT = ""
    FTCT.ERR = ""
    CALL OPF(FN.FTCT,FV.FTCT)
*
    FN.FTTTC = "F.FT.TXN.TYPE.CONDITION"
    FV.FTTTC = ""
    R.FTTTC = ""
    FTTTC.ERR = ""
    CALL OPF(FN.FTTTC,FV.FTTTC)

*
    Y.LOC.APPL = "FUNDS.TRANSFER"
    Y.LOC.FLD  = "L.TT.COMM.CODE":@VM:"L.TT.WV.COMM":@VM:"L.TT.COMM.AMT"
    Y.LOC.FLD := @VM:"L.TT.TAX.CODE":@VM:"L.TT.WV.TAX":@VM:"L.TT.TAX.AMT"
    Y.LOC.FLD := @VM:"L.TT.WV.TAX.AMT":@VM:'L.TT.BASE.AMT':@VM:'L.TT.TRANS.AMT'
    Y.LOC.FLD := @VM:"L.FT.COMM.CODE"
*
    CALL MULTI.GET.LOC.REF(Y.LOC.APPL,Y.LOC.FLD,Y.LOC.POS)
*
    Y.L.TT.COMM.CODE    = Y.LOC.POS<1,1>
    Y.L.TT.WV.COMM      = Y.LOC.POS<1,2>
    Y.L.TT.COMM.AMT     = Y.LOC.POS<1,3>
    Y.L.TT.TAX.CODE     = Y.LOC.POS<1,4>
    Y.L.TT.WV.TAX       = Y.LOC.POS<1,5>
    Y.L.TT.TAX.AMT      = Y.LOC.POS<1,6>
    Y.L.TT.WV.TAX.AMT   = Y.LOC.POS<1,7>
    Y.L.TT.BASE.AMT     = Y.LOC.POS<1,8>
    Y.L.TT.TRANS.AMT    = Y.LOC.POS<1,9>
    Y.L.FT.COMM.POS     = Y.LOC.POS<1,10>

    V.CONT.COMM = 0
    V.CONT.TAX = 0
RETURN

BUSCAR.TXN.TYPE:
    FT.CODE = R.NEW(FT.TRANSACTION.TYPE)
    CALL CACHE.READ(FN.FTTTC, FT.CODE, R.FTTTC, FTTTC.ERR) ;* R22 Auto conversion
*FT6.COMM.TYPES
    IF R.FTTTC THEN
        V.COMM.TYPES = R.FTTTC<FT6.COMM.TYPES>
        V.CAN.CT = DCOUNT(V.COMM.TYPES,@VM)
        FOR A = 1 TO V.CAN.CT
            V.ACTUAL = A
            V.TMP.CT = V.COMM.TYPES<1,A>
            GOSUB BUSCAR.COMM.TYPE

        NEXT A

    END
*DEBUG
RETURN
BUSCAR.COMM.TYPE:
    CALL CACHE.READ(FN.FTCT, V.TMP.CT, R.FTCT, FTCT.ERR) ;* R22 Auto conversion
    IF R.FTCT THEN
        V.MONTO.TXN = R.NEW(FT.CREDIT.AMOUNT)
        CALL GET.LOC.REF("FT.COMMISSION.TYPE","L.FT4.TX.CMM.FL",Y.L.FT4.TX.CMM.FL.POS)
        V.T.O.C = R.FTCT<FT4.LOCAL.REF,Y.L.FT4.TX.CMM.FL.POS>
        V.CALC.TYPE = R.FTCT<FT4.CALC.TYPE>
        IF V.T.O.C EQ "T" THEN

            V.CONT.TAX += 1
            R.NEW(FT.LOCAL.REF)<1,Y.L.TT.WV.TAX,V.CONT.TAX>     = "NO"
            R.NEW(FT.LOCAL.REF)<1,Y.L.TT.TAX.CODE,V.CONT.TAX> = V.TMP.CT

            IF V.CALC.TYPE EQ "FLAT" THEN
                R.NEW(FT.LOCAL.REF)<1,Y.L.TT.TAX.AMT,V.CONT.COMM>  = R.FTCT<FT4.FLAT.AMT>
            END ELSE
                V.PERCENT = R.FTCT<FT4.PERCENTAGE>
                R.NEW(FT.LOCAL.REF)<1,Y.L.TT.TAX.AMT,V.CONT.COMM>  = (V.PERCENT*V.MONTO.TXN)/100
                V.TEMP.MONTO.TAX = (V.PERCENT*V.MONTO.TXN)/100
            END

        END
*
        IF V.T.O.C EQ "C" THEN
            V.CONT.COMM += 1
            R.NEW(FT.LOCAL.REF)<1,Y.L.TT.WV.COMM,V.CONT.COMM>  = "NO"
            R.NEW(FT.LOCAL.REF)<1,Y.L.TT.COMM.CODE,V.CONT.COMM> = V.TMP.CT

            IF V.CALC.TYPE EQ "FLAT" THEN
                R.NEW(FT.LOCAL.REF)<1,Y.L.TT.COMM.AMT,V.CONT.COMM>  = R.FTCT<FT4.FLAT.AMT>
                V.TEMP.MONTO.COMM = R.FTCT<FT4.FLAT.AMT>
            END ELSE
                V.PERCENT = R.FTCT<FT4.PERCENTAGE>
                R.NEW(FT.LOCAL.REF)<1,Y.L.TT.COMM.AMT,V.CONT.COMM>  = (V.PERCENT*V.MONTO.TXN)/100
            END

        END
*DEBUG
    END
RETURN
END
