$PACKAGE APAP.TAM
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE           WHO                 REFERENCE               DESCRIPTION
*24-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     IF CONDITION MODIFIED
*24-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*24-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     VM TO @VM
*24-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     FT.POS = FT.POS + 1 TO FT.POS +=1
*-------------------------------------------------------------------------
SUBROUTINE REDO.TEMP.PART.DISB.UPDATE
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
    $INSERT I_F.REDO.FT.TT.TRANSACTION
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
    WVCR.RDC.ID = R.NEW(FT.TN.L.INITIAL.ID)
    RTNDISB = ""
    CALL F.READU(FN.REDO.DISB.CHAIN, WVCR.RDC.ID, R.REDO.DISB.CHAIN, F.REDO.DISB.CHAIN, ERR.MSJDISB, RTNDISB)
    IF ERR.MSJDISB THEN
        GOSUB SETREDO.DISB.CHAIN        ;* SETEA TODOS LOS CAMPOS - primera transaccion wmeza
    END

    FT.POS = DCOUNT(R.REDO.DISB.CHAIN<DS.CH.FT.TEMP.REF>,@VM) ;*R22 AUTO CONVERSION
    FT.POS += 1 ;*R22 AUTO CONVERSION
    R.REDO.DISB.CHAIN<DS.CH.FT.TEMP.REF,FT.POS>    = ID.NEW
    R.REDO.DISB.CHAIN<DS.CH.FT.TEMP.REF,FT.POS>    = ID.NEW
    R.REDO.DISB.CHAIN<DS.CH.FTTC,FT.POS>           = R.NEW(FT.TN.TRANSACTION.TYPE)
    R.REDO.DISB.CHAIN<DS.CH.CURRENCY,FT.POS>       = R.NEW(FT.TN.CREDIT.CURRENCY)
    R.REDO.DISB.CHAIN<DS.CH.AMOUNT,FT.POS>         = R.NEW(FT.TN.CREDIT.AMOUNT)
    R.REDO.DISB.CHAIN<DS.CH.TEMP.VERSION,FT.POS>   = APPLICATION:PGM.VERSION
    R.REDO.DISB.CHAIN<DS.CH.TR.STATUS,FT.POS>      = "INAU"
    R.REDO.DISB.CHAIN<DS.CH.DISB.STATUS>           = "UP"
    R.REDO.DISB.CHAIN<DS.CH.RPD.ID>                = WVCR.TEMPLATE.ID
    R.NEW(FT.TN.DEBIT.THEIR.REF)                   = WVCR.RDC.ID
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

    R.REDO.DISB.CHAIN<DS.CH.ACCOUNT>        = R.NEW(FT.TN.DEBIT.ACCT.NO)
*
RETURN
*
* ==================
CHECK.FOR.LAST.TRAN:
* ==================
*
* STATUS.DISB field should have value "U" if last transaction
*
    IF WRCA.NEXT.VERSION EQ "NO" THEN   ;*EXISTE UNA SIG VERSION?
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

*
*Tus Start
    WVCR.TEMPLATE.ID  = System.getVariable("CURRENT.Template.ID")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 AUTO CONVERSION START
        WVCR.TEMPLATE.ID = ""
    END ;*R22 AUTO CONVERSION END
;*ID
    IF E<1,1> EQ "EB-UNKNOWN.VARIABLE" THEN
        WVCR.TEMPLATE.ID = ""
    END

    WRCA.NEXT.VERSION = System.getVariable("CURRENT.WRCA.NEXT.VERSION")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 AUTO CONVERSION START
        WRCA.NEXT.VERSION = ""
    END ;*R22 AUTO CONVERSION END
;*POSIBLES VALORE SI/NO PARA SABER SI ES LA ULTIMA
    IF E<1,1> EQ "EB-UNKNOWN.VARIABLE" THEN
        WRCA.NEXT.VERSION = ""
    END

    WRCA.ACT.DISB     = System.getVariable("CURRENT.WRCA.ACT.DISB")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 AUTO CONVERSION START
        WRCA.ACT.DISB = ""
    END ;*R22 AUTO CONVERSION END
;*POSICION
    IF E<1,1> EQ "EB-UNKNOWN.VARIABLE" THEN
        WRCA.ACT.DISB = ""
    END
*Tus End
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
