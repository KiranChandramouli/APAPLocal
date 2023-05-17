SUBROUTINE REDO.V.TT.PARA.LIM.VERIFY
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to validate the REDO.V.TT.PARA.LIM.VERIFY table fields
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : MUDASSIR
* PROGRAM NAME : REDO.V.PARA.LIM.VERIFY
*-----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.TELLER.PARAMETER

    GOSUB INIT
    GOSUB PROCESS
RETURN


INIT:
    LOC.REF.APPLICATION = 'TELLER.PARAMETER'
    ARR.TT.DESIGN = ''
    L.TT.LIMIT.C = ''
    CNT.LOOP = ''
    CNCT.ARR = ''
    ARR.VAL = ''
    LOC.REF.FIELDS = 'L.TT.DESGN':@VM:'L.TT.LIMIT.CCY'
    LOC.REF.POS = ''
RETURN


PROCESS:

    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    L.TT.DESGN.POS = LOC.REF.POS<1,1>
    L.TT.LIMIT.POS =     LOC.REF.POS<1,2>
    ARR.TT.DESIGN= R.NEW(TT.PAR.LOCAL.REF)<1,L.TT.DESGN.POS>
    L.TT.LIMIT.C= R.NEW(TT.PAR.LOCAL.REF)<1,L.TT.LIMIT.POS>
    CNT.LOOP=DCOUNT(L.TT.LIMIT.C,@SM)
    Y.VAR =1
    LOOP
    WHILE Y.VAR LE CNT.LOOP
        TT.DESIGN=ARR.TT.DESIGN<1,1,Y.VAR>
        TT.LIMIT=L.TT.LIMIT.C<1,1,Y.VAR>
        ARR.VAL= TT.DESIGN:@VM:TT.LIMIT
        LOCATE ARR.VAL IN CNCT.ARR<1> SETTING POS THEN
            AF=TT.PAR.LOCAL.REF
            AV=L.TT.DESGN.POS
            AS=Y.VAR
            ETEXT = 'DUPLICATE TT DESIGN AND CURRENCY'
            CALL STORE.END.ERROR
            RETURN
        END ELSE
            CNCT.ARR<-1>= ARR.VAL

        END
        Y.VAR += 1
    REPEAT
RETURN
END
