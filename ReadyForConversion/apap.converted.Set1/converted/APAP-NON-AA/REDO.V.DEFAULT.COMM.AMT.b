SUBROUTINE REDO.V.DEFAULT.COMM.AMT
*-----------------------------------------------------------
*Description: This routine will default the Core commission amount
* to the local field for generating NCF no. since NCF generation is based on
* local field commission amount.
*-----------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.FT.COMMISSION.TYPE

    GOSUB PROCESS
RETURN
*-----------------------------------------------------------
PROCESS:
*-----------------------------------------------------------


    GOSUB GET.LOC.REF.POS
    IF APPLICATION EQ 'TELLER' THEN
        GOSUB PROCESS.TT
    END
    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        GOSUB PROCESS.FT
    END

RETURN
*-----------------------------------------------------------
GET.LOC.REF.POS:
*-----------------------------------------------------------
    LOC.REF.APPLICATION   = "TELLER":@FM:"FUNDS.TRANSFER":@FM:"FT.COMMISSION.TYPE"
    LOC.REF.FIELDS        = 'L.TT.WV.COMM':@VM:'L.TT.COMM.AMT':@VM:'L.TT.COMM.CODE':@FM:'L.TT.WV.COMM':@VM:'L.TT.COMM.AMT':@VM:'L.TT.COMM.CODE':@FM:'L.FT4.TX.CMM.FL'
    LOC.REF.POS           = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.TT.L.TT.WV.COMM  = LOC.REF.POS<1,1>
    POS.TT.L.TT.COMM.AMT = LOC.REF.POS<1,2>
    POS.TT.L.TT.COMM.CODE= LOC.REF.POS<1,3>
    POS.FT.L.TT.WV.COMM  = LOC.REF.POS<2,1>
    POS.FT.L.TT.COMM.AMT = LOC.REF.POS<2,2>
    POS.FT.L.TT.COMM.CODE= LOC.REF.POS<2,3>
    POS.L.FT4.TX.CMM.FL  = LOC.REF.POS<3,1>

    FN.FT.COMMISSION.TYPE = 'F.FT.COMMISSION.TYPE'
    F.FT.COMMISSION.TYPE  = ''
    CALL OPF(FN.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE)

RETURN
*-----------------------------------------------------------
PROCESS.TT:
*-----------------------------------------------------------
    Y.COMM.TYPE = R.NEW(TT.TE.CHARGE.CODE)
    Y.COMM.AMT  = R.NEW(TT.TE.CHRG.AMT.LOCAL)
    Y.WAIVE     = R.NEW(TT.TE.WAIVE.CHARGES)
    IF Y.COMM.TYPE THEN
        GOSUB UPDATE.TT
    END
RETURN
*-----------------------------------------------------------
PROCESS.FT:
*-----------------------------------------------------------
    Y.COMM.TYPE = R.NEW(FT.COMMISSION.TYPE)
    Y.COMM.AMT  = R.NEW(FT.COMMISSION.AMT)
    Y.WAIVE     = R.NEW(FT.COMMISSION.CODE)
    IF Y.COMM.TYPE THEN
        GOSUB UPDATE.FT
    END ELSE
        R.NEW(FT.LOCAL.REF)<1,POS.FT.L.TT.COMM.CODE> = ''
        R.NEW(FT.LOCAL.REF)<1,POS.FT.L.TT.COMM.AMT>  = ''
        R.NEW(FT.LOCAL.REF)<1,POS.FT.L.TT.WV.COMM>   = ''
    END
RETURN
*-----------------------------------------------------------
UPDATE.FT:
*-----------------------------------------------------------
    Y.COMM.CNT = DCOUNT(Y.COMM.TYPE,@VM)
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE Y.COMM.CNT
        CALL CACHE.READ(FN.FT.COMMISSION.TYPE, Y.COMM.TYPE<1,Y.VAR1>, R.FCT, FCT.ERR)
        IF R.FCT<FT4.LOCAL.REF,POS.L.FT4.TX.CMM.FL> EQ 'C' THEN

            R.NEW(FT.LOCAL.REF)<1,POS.FT.L.TT.COMM.CODE> = Y.COMM.TYPE<1,Y.VAR1>
            R.NEW(FT.LOCAL.REF)<1,POS.FT.L.TT.COMM.AMT>  = Y.COMM.AMT<1,Y.VAR1>[4,LEN(Y.COMM.AMT<1,Y.VAR1>)-3]
            IF Y.WAIVE EQ 'WAIVE' THEN
                R.NEW(FT.LOCAL.REF)<1,POS.FT.L.TT.WV.COMM> = 'YES'
            END ELSE
                R.NEW(FT.LOCAL.REF)<1,POS.FT.L.TT.WV.COMM> = 'NO'

            END
        END
        Y.VAR1 += 1
    REPEAT

RETURN
*-----------------------------------------------------------
UPDATE.TT:
*-----------------------------------------------------------
    Y.COMM.CNT = DCOUNT(Y.COMM.TYPE,@VM)
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE Y.COMM.CNT
        CALL CACHE.READ(FN.FT.COMMISSION.TYPE, Y.COMM.TYPE<1,Y.VAR1>, R.FCT, FCT.ERR)
        IF R.FCT<FT4.LOCAL.REF,POS.L.FT4.TX.CMM.FL> EQ 'C' THEN
            R.NEW(TT.TE.LOCAL.REF)<1,POS.TT.L.TT.COMM.CODE> = Y.COMM.TYPE<1,Y.VAR1>
            R.NEW(TT.TE.LOCAL.REF)<1,POS.TT.L.TT.COMM.AMT>  = Y.COMM.AMT<1,Y.VAR1>

            IF Y.WAIVE EQ 'WAIVE' THEN
                R.NEW(TT.TE.LOCAL.REF)<1,POS.TT.L.TT.WV.COMM> = 'YES'
            END ELSE
                R.NEW(TT.TE.LOCAL.REF)<1,POS.TT.L.TT.WV.COMM> = 'NO'
            END
        END
        Y.VAR1 += 1
    REPEAT

RETURN
END
