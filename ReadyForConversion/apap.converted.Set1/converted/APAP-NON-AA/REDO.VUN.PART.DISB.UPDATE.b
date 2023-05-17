SUBROUTINE REDO.VUN.PART.DISB.UPDATE
*********************************************************************
*Company Name  : APAP
*First Release :
*Developed for : APAP
*Developed by  : TAM
*Date          : 28-11-2012
*--------------------------------------------------------------------------------------------
* Subroutine Type       :
* Attached to           : VERSION.CONTROL: FUNDS.TRANSFER,PSB
* Attached as           : UNAUTH.ROUTINE
* Primary Purpose       :
*--------------------------------------------------------------------------------------------
* Modification Details:
*--------------------------------------------------------------------------------------------
* 28/11/2012 - PACS00236823  - Marimuthu S
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
    $INSERT I_F.REDO.AA.PART.DISBURSE.FC
*
*************************************************************************


    GOSUB INITIALISE
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
*
    IF WRCA.NEXT.VERSION NE "NO" THEN
        WNEXT.VERSION = WRCA.NEXT.VERSION:" ":"I":" ":"F3"
        CALL EB.SET.NEW.TASK(WNEXT.VERSION)
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
    CALL F.READU(FN.REDO.AA.PART.DISBURSE.FC,WVCR.TEMPLATE.ID,R.REDO.AA.PART.DISBURSE.FC,F.REDO.AA.PART.DISBURSE.FC,ERR.MSJ,RTR)
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
    R.REDO.AA.PART.DISBURSE.FC<REDO.PDIS.DIS.CODTXN,WRCA.ACT.DISB> = ID.NEW
    GOSUB CHECK.FOR.LAST.TRAN

    CALL F.WRITE(FN.REDO.AA.PART.DISBURSE.FC,WVCR.TEMPLATE.ID,R.REDO.AA.PART.DISBURSE.FC)
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
    R.REDO.DISB.CHAIN<DS.CH.DISB.STATUS>       = "UP"
    R.REDO.DISB.CHAIN<DS.CH.RPD.ID> = WVCR.TEMPLATE.ID
    R.NEW(FT.DEBIT.THEIR.REF)                  = WVCR.RDC.ID
    CALL F.WRITE(FN.REDO.DISB.CHAIN,WVCR.RDC.ID,R.REDO.DISB.CHAIN)
*
RETURN
*
* ==================
SETREDO.DISB.CHAIN:
* ==================
*
* Used only for FIRST TRANSACTION in a disbursement process
*
    R.REDO.DISB.CHAIN                       = ""
    R.REDO.DISB.CHAIN<DS.CH.ARRANGEMENT.ID> = R.REDO.AA.PART.DISBURSE.FC<REDO.PDIS.ID.ARRANGEMENT>
    R.REDO.DISB.CHAIN<DS.CH.DISBURSE.SEQ>   = FIELD(WVCR.RDC.ID,".",2)
    R.REDO.DISB.CHAIN<DS.CH.USER.ID>        = OPERATOR
    R.REDO.DISB.CHAIN<DS.CH.BRANCH.ID>      = ID.COMPANY
    R.REDO.DISB.CHAIN<DS.CH.DATE>           = TODAY
    R.REDO.DISB.CHAIN<DS.CH.RCA.ID>         = WVCR.TEMPLATE.ID

*    R.REDO.DISB.CHAIN<DS.CH.CUSTOMER>       = R.REDO.CREATE.ARRANGEMENT<REDO.FC.CUSTOMER>

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
        R.REDO.AA.PART.DISBURSE.FC<REDO.PDIS.DIS.STAT> = 'U'
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
* FN.REDO.CREATE.ARRANGEMENT = "F.REDO.CREATE.ARRANGEMENT"
* F.REDO.CREATE.ARRANGEMENT  = ""

    FN.REDO.AA.PART.DISBURSE.FC = 'F.REDO.AA.PART.DISBURSE.FC'
    F.REDO.AA.PART.DISBURSE.FC = ''
    CALL OPF(FN.REDO.AA.PART.DISBURSE.FC,F.REDO.AA.PART.DISBURSE.FC)

    FN.REDO.DISB.CHAIN  = 'F.REDO.DISB.CHAIN'
    F.REDO.DISB.CHAIN   = ''
    R.REDO.DISB.CHAIN   = ''

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
*
RETURN

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
                CALL F.READ(FN.REDO.AA.PART.DISBURSE.FC,WVCR.TEMPLATE.ID,R.REDO.AA.PART.DISBURSE.FC,F.REDO.AA.PART.DISBURSE.FC,ERR.MSJ)

        END CASE

        LOOP.CNT += 1

    REPEAT
*
RETURN
*
END
