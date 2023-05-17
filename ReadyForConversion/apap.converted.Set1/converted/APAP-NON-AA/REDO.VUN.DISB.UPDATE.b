SUBROUTINE REDO.VUN.DISB.UPDATE
*********************************************************************
*Company Name  : APAP
*First Release : Meza William
*Developed for : APAP
*Developed by  : RTAM/Meza William
*Date          : Ago/11/11
*--------------------------------------------------------------------------------------------
* Subroutine Type       : PROCEDURE
* Attached to           : VERSION.CONTROL: FUNDS.TRANSFER,DSB
* Attached as           : UNAUTH.ROUTINE
* Primary Purpose       : Actualiza el registro de REDO.DISB.CHAIN
*--------------------------------------------------------------------------------------------
* Modification Details:
*--------------------------------------------------------------------------------------------
* 01/01/1900 - ODR-1900- XX-XXXX
* Development to fill data to RDC it must be attached to a VERSION.CONTROL: FT,DIS.
*************************************************************************
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
*
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER.ID
*
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.REDO.DISB.CHAIN
*
*************************************************************************

*

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN
*
* ======
PROCESS:
* ======
*


    GOSUB UPDATE.REDO.CREATE.ARRANGEMENT
    GOSUB UPDATE.REDO.DISB.CHAIN

    IF Y.R.VAL NE 'ERROR' THEN
        CALL F.WRITE(FN.REDO.FC.PR.DIS.COB,WVCR.TEMPLATE.ID,Y.R.VAL)
    END

*
    IF WRCA.NEXT.VERSION NE "NO" THEN

        WNEXT.ID = System.getVariable("CURRENT.WRCA.FT.ID")
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN
            WNEXT.ID = ""
        END

        Y.NO.ID = FIELD(E,@VM,2)
        IF WNEXT.ID EQ 'CURRENT.WRCA.FT.ID' OR Y.NO.ID EQ 'CURRENT.WRCA.FT.ID'  THEN
            E = ''
            WNEXT.VERSION = WRCA.NEXT.VERSION:" ":"I":" ":"F3"
            CALL EB.SET.NEW.TASK(WNEXT.VERSION)
        END ELSE
            IF WNEXT.ID[1,2] EQ 'FT' THEN
                WNEXT.VERSION = WRCA.NEXT.VERSION:" ":"I":" ":WNEXT.ID
                CALL EB.SET.NEW.TASK(WNEXT.VERSION)
            END
        END
    END ELSE
        IF Y.R.VAL NE 'ERROR' THEN
            CALL F.DELETE(FN.REDO.FC.PR.DIS.COB,WVCR.TEMPLATE.ID)

            CALL F.WRITE(FN.REDO.BKUP.CB.NAU.RECS,WVCR.TEMPLATE.ID,Y.R.VAL)
        END
    END
*
RETURN
*
* =============================
UPDATE.REDO.CREATE.ARRANGEMENT:
* =============================
*
* Updates TRAN.AUTH field to AP if not all valid transactions are AUTHORISED,
*   and to A if ALL valid transactions are AUTHORISED
*
    RTR = ""
    CALL F.READU(FN.REDO.CREATE.ARRANGEMENT,WVCR.TEMPLATE.ID,R.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT,ERR.MSJ,RTR)
    IF NOT(ERR.MSJ) THEN
        GOSUB WRITE.RCA
    END
*
RETURN
*
* ========
WRITE.RCA:
* ========
*
    R.REDO.CREATE.ARRANGEMENT<REDO.FC.DIS.CODTXN,WRCA.ACT.DISB> = ID.NEW
    R.REDO.CREATE.ARRANGEMENT<REDO.FC.DIS.STA,WRCA.ACT.DISB>    = "INAU"
    R.REDO.CREATE.ARRANGEMENT<REDO.FC.STATUS.DISB>              = "P"
    GOSUB CHECK.FOR.LAST.TRAN

    CALL F.WRITE(FN.REDO.CREATE.ARRANGEMENT,WVCR.TEMPLATE.ID,R.REDO.CREATE.ARRANGEMENT)
*
* wmeza
*
RETURN
*
* =====================
UPDATE.REDO.DISB.CHAIN:
* =====================
*
    WVCR.RDC.ID = R.NEW(FT.LOCAL.REF)<1,WPOS.LI>
    RTNDISB = ""
    CALL F.READU(FN.REDO.DISB.CHAIN, WVCR.RDC.ID, R.REDO.DISB.CHAIN, F.REDO.DISB.CHAIN, ERR.MSJDISB, RTNDISB)
    IF ERR.MSJDISB THEN
        GOSUB SETREDO.DISB.CHAIN  ;* SETEA TODOS LOS CAMPOS - primera transaccion wmeza
    END

    R.REDO.DISB.CHAIN<DS.CH.TRANSACTION.ID,-1> = ID.NEW
    R.REDO.DISB.CHAIN<DS.CH.FTTC,-1>           = R.NEW (FT.TRANSACTION.TYPE)
    R.REDO.DISB.CHAIN<DS.CH.CURRENCY,-1>       = R.NEW(FT.CREDIT.CURRENCY)
    R.REDO.DISB.CHAIN<DS.CH.AMOUNT,-1>         = R.NEW(FT.AMOUNT.CREDITED)
    R.REDO.DISB.CHAIN<DS.CH.VERSION,-1>        = APPLICATION:PGM.VERSION
    R.REDO.DISB.CHAIN<DS.CH.TR.STATUS,-1>      = "INAU"
    R.REDO.DISB.CHAIN<DS.CH.DISB.STATUS>       = R.REDO.CREATE.ARRANGEMENT<REDO.FC.STATUS.DISB>
    R.NEW(FT.DEBIT.THEIR.REF)                  = WVCR.RDC.ID
    CALL F.WRITE(FN.REDO.DISB.CHAIN,WVCR.RDC.ID,R.REDO.DISB.CHAIN)
*fin wmeza ago 11 2011
*
RETURN
*
* ==================
SETREDO.DISB.CHAIN:
* ==================
*
* Used only for FIRST TRANSACTION in a disbursement process
*
*inicio wmeza ago 11 2011 AA083390R701.001
*
    R.REDO.DISB.CHAIN                       = ""
    R.REDO.DISB.CHAIN<DS.CH.ARRANGEMENT.ID> = R.REDO.CREATE.ARRANGEMENT<REDO.FC.ID.ARRANGEMENT>
    R.REDO.DISB.CHAIN<DS.CH.DISBURSE.SEQ>   = FIELD(WVCR.RDC.ID,".",2)
    R.REDO.DISB.CHAIN<DS.CH.USER.ID>        = OPERATOR
    R.REDO.DISB.CHAIN<DS.CH.BRANCH.ID>      = ID.COMPANY
    R.REDO.DISB.CHAIN<DS.CH.DATE>           = TODAY
    R.REDO.DISB.CHAIN<DS.CH.RCA.ID>         = WVCR.TEMPLATE.ID
    R.REDO.DISB.CHAIN<DS.CH.CUSTOMER>       = R.REDO.CREATE.ARRANGEMENT<REDO.FC.CUSTOMER>
    R.REDO.DISB.CHAIN<DS.CH.ACCOUNT>        = R.NEW(FT.DEBIT.ACCT.NO)
*
RETURN
*
* ==================
CHECK.FOR.LAST.TRAN:
* ==================
*
* STATUS.DISB field should have value "U" if last transaction
*
    IF WRCA.NEXT.VERSION EQ "NO" THEN     ;*EXISTE UNA SIG VERSION?
        R.REDO.CREATE.ARRANGEMENT<REDO.FC.STATUS.DISB> = "U"
    END
*
RETURN
*
* =========
INITIALISE:
* =========
*
    PROCESS.GOAHEAD = 1
*
    FN.REDO.CREATE.ARRANGEMENT = "F.REDO.CREATE.ARRANGEMENT"
    F.REDO.CREATE.ARRANGEMENT  = ""
    CALL OPF(FN.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT)

*wmeza
    FN.REDO.DISB.CHAIN  = 'F.REDO.DISB.CHAIN'
    F.REDO.DISB.CHAIN   = ''
    R.REDO.DISB.CHAIN   = ''

    FN.REDO.FC.PR.DIS.COB = 'F.REDO.FC.PR.DIS.COB'
    F.REDO.FC.PR.DIS.COB = ''
    CALL OPF(FN.REDO.FC.PR.DIS.COB,F.REDO.FC.PR.DIS.COB)

    FN.REDO.BKUP.CB.NAU.RECS = 'F.REDO.BKUP.CB.NAU.RECS'
    F.REDO.BKUP.CB.NAU.RECS = ''
    CALL OPF(FN.REDO.BKUP.CB.NAU.RECS,F.REDO.BKUP.CB.NAU.RECS)

    YPOS = ''
    WAPP.LST  = "FUNDS.TRANSFER"
    WCAMPO    = "L.INITIAL.ID"
    WCAMPO    = CHANGE(WCAMPO,@FM,@VM)
    WFLD.LST  = WCAMPO
    CALL MULTI.GET.LOC.REF(WAPP.LST,WFLD.LST,YPOS)
    WPOS.LI   = YPOS<1,1>
*

    WVCR.TEMPLATE.ID  = System.getVariable("CURRENT.Template.ID")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        WVCR.TEMPLATE.ID = ""
    END
;*ID
    WRCA.NEXT.VERSION = System.getVariable("CURRENT.WRCA.NEXT.VERSION")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        WRCA.NEXT.VERSION = ""
    END
;*POSIBLES VALORE SI/NO PARA SABER SI ES LA ULTIMA
    WRCA.ACT.DISB     = System.getVariable("CURRENT.WRCA.ACT.DISB")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        WRCA.ACT.DISB = ""
    END
;*POSICION
    Y.R.VAL = System.getVariable("CURRENT.R.VAL")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.R.VAL = ""
    END

*
RETURN

* =========
OPEN.FILES:
* =========
*
*
RETURN
*
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
    LOOP.CNT  = 1
    MAX.LOOPS = 2
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD
        BEGIN CASE

            CASE LOOP.CNT EQ 1
                IF WVCR.TEMPLATE.ID EQ "ERROR" OR WVCR.TEMPLATE.ID EQ "CURRENT.Template.ID" THEN
                    PROCESS.GOAHEAD = ""
                END

            CASE LOOP.CNT EQ 2
                CALL F.READ(FN.REDO.CREATE.ARRANGEMENT,WVCR.TEMPLATE.ID,R.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT,ERR.MSJ)

        END CASE

        LOOP.CNT += 1

    REPEAT
*
RETURN
*
END
