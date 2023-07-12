SUBROUTINE REDO.V.UPD.RTE.FLAG
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :APAP
*Program   Name    :REDO.V.UPD.RTE.FLAG
*---------------------------------------------------------------------------------
* DESCRIPTION      :This Input program is used to mark whether the person is other person for RTE form
*
* Date           ref            who                description
* 16-08-2011     New RTE Form   APAP               Initial Version
* ----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.T24.FUND.SERVICES

    GOSUB INIT
    GOSUB PROCESS

RETURN

******
INIT:
******

    FN.TELLER = 'F.TELLER'
    F.TELLER = ''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.FT = 'F.FUNDS.TRANSFER'
    F.FT = ''
    CALL OPF(FN.FT,F.FT)

    FN.TFS = 'F.T24.FUND.SERVICES'
    F.TFS = ''
    CALL OPF(FN.TFS,F.TFS)

    LRF.APP = "TELLER":@FM:"FUNDS.TRANSFER":@FM:"T24.FUND.SERVICES"
    LRF.FIELD = "L.RTE.FORM":@VM:"L.1ST.NAME":@FM:'L.RTE.FORM':@VM:"L.1ST.NAME":@FM:'L.RTE.FORM':@VM:"L.1ST.NAME"
    LRF.POS = ''
    CALL MULTI.GET.LOC.REF(LRF.APP,LRF.FIELD,LRF.POS)
    POS.L.TT.FORM = LRF.POS<1,1>
    POS.L.TT.NAME = LRF.POS<1,2>
    POS.L.FT.FORM = LRF.POS<2,1>
    POS.L.FT.NAME = LRF.POS<2,2>
    POS.L.TFS.FORM = LRF.POS<3,1>
    POS.L.TFS.NAME = LRF.POS<3,2>

    Y.RTE.FORM = ''

RETURN

*********
PROCESS:
*********

    BEGIN CASE

        CASE ID.NEW[1,2] EQ 'TT'
            R.TELLER.REC = ''
            CALL F.READ(FN.TELLER,ID.NEW,R.TELLER.REC,F.TELLER,TELLER.ERR)
            Y.RTE.FORM = R.NEW(TT.TE.LOCAL.REF)<1,POS.L.TT.FORM>
            Y.RTE.1ST.NAME = R.NEW(TT.TE.LOCAL.REF)<1,POS.L.TT.NAME>
            IF Y.RTE.1ST.NAME NE '' THEN
                R.NEW(TT.TE.LOCAL.REF)<1,POS.L.TT.FORM> = "YES"
            END
        CASE ID.NEW[1,2] EQ 'FT'
            R.FT.REC = ''
            CALL F.READ(FN.FT,ID.NEW,R.FT.REC,F.FT,FT.ERR)
            Y.RTE.FORM = R.NEW(FT.LOCAL.REF)<1,POS.L.FT.FORM>
            Y.RTE.1ST.NAME = R.NEW(FT.LOCAL.REF)<1,POS.L.FT.NAME>
            IF Y.RTE.1ST.NAME NE '' THEN
                R.NEW(FT.LOCAL.REF)<1,POS.L.FT.FORM> = "YES"
            END
        CASE ID.NEW[1,5] EQ 'T24FS'
            R.TFS.REC = ''
            CALL F.READ(FN.TFS,ID.NEW,R.TFS.REC,F.TFS,TFS.ERR)
            Y.RTE.FORM = R.NEW(TFS.LOCAL.REF)<1,POS.L.TFS.FORM>
            Y.RTE.1ST.NAME = R.NEW(TFS.LOCAL.REF)<1,POS.L.TFS.NAME>
            IF Y.RTE.1ST.NAME NE '' THEN
                R.NEW(TFS.LOCAL.REF)<1,POS.L.TFS.FORM> = "YES"
            END
    END CASE

RETURN

END
