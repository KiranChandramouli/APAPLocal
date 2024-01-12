* @ValidationCode : MjotMTMzNjIzNzY1NzpDcDEyNTI6MTcwNTA0NzIyOTk5MTozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Jan 2024 13:43:49
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.TEMP.DISB.UPDATE
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
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*19-04-2023            Conversion Tool             R22 Auto Code conversion                        VM TO @VM,IF CONDITION ADDED,++ TO +=1
*19-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*-----------------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
*
    $INSERT I_F.REDO.FT.TT.TRANSACTION
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
*Tus Start
        WNEXT.ID = System.getVariable("CURRENT.WRCA.FT.ID")
        IF E<1,1> EQ "EB-UNKNOWN.VARIABLE" THEN
            WNEXT.ID = ""
        END
*Tus End
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
    WVCR.RDC.ID = R.NEW(FT.TN.L.INITIAL.ID)
    RTNDISB = ""
    FT.POS = '0'
    CALL F.READU(FN.REDO.DISB.CHAIN, WVCR.RDC.ID, R.REDO.DISB.CHAIN, F.REDO.DISB.CHAIN, ERR.MSJDISB, RTNDISB)
    IF NOT(R.REDO.DISB.CHAIN) THEN
        GOSUB SETREDO.DISB.CHAIN        ;* SETEA TODOS LOS CAMPOS - primera transaccion wmeza
    END

    FT.POS = DCOUNT(R.REDO.DISB.CHAIN<DS.CH.FT.TEMP.REF>,@VM)
    FT.POS += 1
    R.REDO.DISB.CHAIN<DS.CH.FT.TEMP.REF,FT.POS>    = ID.NEW
    R.REDO.DISB.CHAIN<DS.CH.FTTC,FT.POS>           = R.NEW(FT.TN.TRANSACTION.TYPE)
    R.REDO.DISB.CHAIN<DS.CH.CURRENCY,FT.POS>       = R.NEW(FT.TN.CREDIT.CURRENCY)
    R.REDO.DISB.CHAIN<DS.CH.AMOUNT,FT.POS>         = R.NEW(FT.TN.CREDIT.AMOUNT)
    R.REDO.DISB.CHAIN<DS.CH.TEMP.VERSION,FT.POS>   = APPLICATION:PGM.VERSION
    R.REDO.DISB.CHAIN<DS.CH.TR.STATUS,FT.POS>      = "INAU"
    R.REDO.DISB.CHAIN<DS.CH.DISB.STATUS>       = R.REDO.CREATE.ARRANGEMENT<REDO.FC.STATUS.DISB>
    R.NEW(FT.TN.DEBIT.THEIR.REF)               = WVCR.RDC.ID
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
    CALL OPF(FN.REDO.DISB.CHAIN,F.REDO.DISB.CHAIN) ;*R22 Manual Conversion
    FN.REDO.FC.PR.DIS.COB = 'F.REDO.FC.PR.DIS.COB'
    F.REDO.FC.PR.DIS.COB = ''
    CALL OPF(FN.REDO.FC.PR.DIS.COB,F.REDO.FC.PR.DIS.COB)

    FN.REDO.BKUP.CB.NAU.RECS = 'F.REDO.BKUP.CB.NAU.RECS'
    F.REDO.BKUP.CB.NAU.RECS = ''
    CALL OPF(FN.REDO.BKUP.CB.NAU.RECS,F.REDO.BKUP.CB.NAU.RECS)

*
*Tus Start
    WVCR.TEMPLATE.ID  = System.getVariable("CURRENT.Template.ID")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN    ;*R22 AUTO CODE CONVERSION.START
        WVCR.TEMPLATE.ID = ""     ;*R22 AUTO CODE CONVERSION
    END    ;*R22 AUTO CODE CONVERSION.END
;*ID
    IF E<1,1> EQ "EB-UNKNOWN.VARIABLE" THEN
        WVCR.TEMPLATE.ID = ""
    END

    WRCA.NEXT.VERSION = System.getVariable("CURRENT.WRCA.NEXT.VERSION")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN      ;*R22 AUTO CODE CONVERSION.START
        WRCA.NEXT.VERSION = ""   ;*R22 AUTO CODE CONVERSION
    END    ;*R22 AUTO CODE CONVERSION.END
;*POSIBLES VALORE SI/NO PARA SABER SI ES LA ULTIMA
    IF E<1,1> EQ "EB-UNKNOWN.VARIABLE" THEN
        WRCA.NEXT.VERSION = ""
    END

    WRCA.ACT.DISB     = System.getVariable("CURRENT.WRCA.ACT.DISB")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN    ;*R22 AUTO CODE CONVERSION.START
        WRCA.ACT.DISB = ""    ;*R22 AUTO CODE CONVERSION
    END    ;*R22 AUTO CODE CONVERSION.END
;*POSICION
    IF E<1,1> EQ "EB-UNKNOWN.VARIABLE" THEN
        WRCA.ACT.DISB = ""
    END

    Y.R.VAL = System.getVariable("CURRENT.R.VAL")
    IF E<1,1> EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.R.VAL = ""
    END
*Tus End
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
*                CALL F.READ(FN.REDO.CREATE.ARRANGEMENT,WVCR.TEMPLATE.ID,R.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT,ERR.MSJ)
                CALL F.READU(FN.REDO.CREATE.ARRANGEMENT,WVCR.TEMPLATE.ID,R.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT,ERR.MSJ,'');* R22 UTILITY AUTO CONVERSION

        END CASE

        LOOP.CNT += 1

    REPEAT
*
RETURN
*
END
