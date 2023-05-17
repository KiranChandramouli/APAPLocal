SUBROUTINE REDO.B.CCY.POSN.UPD.NEW
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Program   Name    : REDO.B.CCY.POSN.UPD.NEW
*--------------------------------------------------------------------------------------------------------
*Description       : ONline service routine will update the F.REDO.FX.CCY.POSN with actual record.
*                    This is done to avoid locking issue PACS00809542.
**In Parameter     :  N/A
*Out Parameter     :  N/A
*
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*  Date            Who                 Reference                    Description
*  ------          ------              -------------                -------------
* 23-Dec-2019      Nanda               PACS00809542          To update F.REDO.FX.CCY.POSN only with ID.
*********************************************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FOREX
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_F.REDO.FX.CCY.POSN
    GOSUB INIT
    GOSUB PROCESS

    APPLICATION = SAVE.APPLICATION
    ID.NEW = SAVE.ID.NEW
    MAT R.NEW = MAT SAVE.R.NEW
    V$FUNCTION = SAVE.V$FUNCTION

RETURN

INIT:
    Y.PERF.FLAG = ''
    REDO.FX.CCY.POSN.ID = ''

    FN.FOREX = 'F.FOREX'
    F.FOREX  = ''
    CALL OPF(FN.FOREX, F.FOREX)

    FN.TELLER = 'F.TELLER'
    F.TELLER  = ''
    CALL OPF(FN.TELLER, F.TELLER)

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER  = ''
    CALL OPF(FN.FUNDS.TRANSFER, F.FUNDS.TRANSFER)

    FN.REDO.FX.CCY.POSN = 'F.REDO.FX.CCY.POSN'
    F.REDO.FX.CCY.POSN  = ''
    CALL OPF(FN.REDO.FX.CCY.POSN, F.REDO.FX.CCY.POSN)

    FN.REDO.FX.CCY.POSN='F.REDO.FX.CCY.POSN'
    F.REDO.FX.CCY.POSN=''
    R.REDO.FX.CCY.POSN=''

    CALL OPF(FN.REDO.FX.CCY.POSN,F.REDO.FX.CCY.POSN)

    SEL.CMD = 'SELECT ':FN.REDO.FX.CCY.POSN:' WITH @ID LIKE ':DQUOTE(SQUOTE(TODAY):'...'):' BY @ID'
    SAVE.APPLICATION = APPLICATION
    SAVE.ID.NEW = ID.NEW
    DIM SAVE.R.NEW(500)
    MAT SAVE.R.NEW = MAT R.NEW
    SAVE.V$FUNCTION = V$FUNCTION

    APPL.ARR = "FUNDS.TRANSFER":@FM:"TELLER":@FM:"FOREX"
    FIELDS.NAME.ARR = "L.FT.FXSN.NUM":@FM:"L.TT.FXSN.NUM":@FM:"L.FX.FXSN.NUM"

    CALL MULTI.GET.LOC.REF(APPL.ARR,FIELDS.NAME.ARR,FIELD.POS.ARR)
    L.FT.FXSN.NUM.POS   = FIELD.POS.ARR<1,1>
    L.TT.FXSN.NUM.POS   = FIELD.POS.ARR<2,1>
    L.FX.FXSN.NUM.POS   = FIELD.POS.ARR<3,1>


RETURN

PROCESS:
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.NO,SEL.ERR)
    LOOP
        REMOVE REDO.FX.CCY.POSN.ID FROM SEL.LIST SETTING POS
    WHILE REDO.FX.CCY.POSN.ID:POS

        CALL F.READU(FN.REDO.FX.CCY.POSN,REDO.FX.CCY.POSN.ID,R.REDO.FX.CCY.POSN,F.REDO.FX.CCY.POSN,POS.ERR,'')
        ID = FIELD(REDO.FX.CCY.POSN.ID,'.',2)
        APPL.ID = ID[1,2]
        STAGE = FIELD(REDO.FX.CCY.POSN.ID,'.',3)
        R.RECORD = ''
        BEGIN CASE

            CASE (APPL.ID EQ 'TT')
                APPLICATION = 'TELLER'
                CALL F.READU(FN.TELLER,ID,R.TELLER,F.TELLER,ERR,'')
                SAVE.CURR.NO = R.TELLER<TT.TE.CURR.NO>
                R.TELLER<TT.TE.CURR.NO> = ''
                R.TELLER<TT.TE.RECORD.STATUS> = ''
                MATPARSE R.NEW FROM R.TELLER
                ID.NEW = ID
                LOCAL.REF.POS = TT.TE.LOCAL.REF
                FXSN.POS = L.TT.FXSN.NUM.POS
                FN.APPL = FN.TELLER
                F.APPL = F.TELLER
                CURR.NO.POS = TT.TE.CURR.NO
            CASE (APPL.ID EQ 'FT')
                APPLICATION = 'FUNDS.TRANSFER'
                CALL F.READU(FN.FUNDS.TRANSFER,ID,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,ERR,'')
                SAVE.CURR.NO = R.FUNDS.TRANSFER<FT.CURR.NO>
                R.FUNDS.TRANSFER<FT.CURR.NO> = ''
                R.FUNDS.TRANSFER<FT.RECORD.STATUS> = ''
                MATPARSE R.NEW FROM R.FUNDS.TRANSFER
                ID.NEW = ID
                LOCAL.REF.POS = FT.LOCAL.REF
                FXSN.POS = L.FT.FXSN.NUM.POS
                FN.APPL = FN.FUNDS.TRANSFER
                F.APPL = F.FUNDS.TRANSFER
                CURR.NO.POS = FT.CURR.NO
            CASE (APPL.ID EQ 'FX')
                APPLICATION = 'FOREX'
                CALL F.READU(FN.FOREX,ID,R.FOREX,F.FOREX,ERR,'')
                SAVE.CURR.NO = R.FOREX<FX.CURR.NO>
                CURR.NO.POS = FX.CURR.NO
                IF R.FOREX<FX.CURR.NO> EQ '1' THEN
                    R.FOREX<FX.CURR.NO> = ''
                END
                R.FOREX<FX.RECORD.STATUS> = ''
                MATPARSE R.NEW FROM R.FOREX
                ID.NEW = ID
                LOCAL.REF.POS = FX.LOCAL.REF
                FXSN.POS = L.FX.FXSN.NUM.POS
                FN.APPL = FN.FOREX
                F.APPL = F.FOREX
            CASE OTHERWISE
                CONTINUE
        END CASE

        BEGIN CASE
            CASE STAGE EQ '1'
                V$FUNCTION = 'I'
                CALL REDO.TXN.INP.CCY.POSN.UPD

            CASE STAGE EQ '2'
                V$FUNCTION = 'A'
                OLD.LOCAL.REF.VAL = R.NEW(LOCAL.REF.POS)<1,FXSN.POS>
                CALL REDO.V.FX.REF.NUM
                IF LOCAL.REF.POS AND FXSN.POS AND R.NEW(LOCAL.REF.POS)<1,FXSN.POS> NE '' AND R.NEW(LOCAL.REF.POS)<1,FXSN.POS> NE OLD.LOCAL.REF.VAL THEN
                    R.NEW(CURR.NO.POS)<1,1> = SAVE.CURR.NO
                    MATBUILD R.RECORD FROM R.NEW
                    CALL F.WRITE(FN.APPL,ID.NEW,R.RECORD)
                END
                CALL REDO.V.FX.CCY.POS
                CALL REDO.V.AUT.UPD.FX.POS
        END CASE
        CALL F.RELEASE(FN.APPL,ID.NEW,F.APPL)
        CALL F.DELETE(FN.REDO.FX.CCY.POSN,REDO.FX.CCY.POSN.ID)
    REPEAT

RETURN

END
