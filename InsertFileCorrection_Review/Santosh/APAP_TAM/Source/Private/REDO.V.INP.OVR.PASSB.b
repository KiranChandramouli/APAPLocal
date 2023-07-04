* @ValidationCode : MjotMTI1Mjc3NDQ0MzpDcDEyNTI6MTY4ODQ1Mzc3MzQ2NDpJVFNTMTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 04 Jul 2023 12:26:13
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------
* <Rating>-36</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.V.INP.OVR.PASSB
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : NAVA V
* Program Name  : REDO.V.INP.OVR.PASSB
*-------------------------------------------------------------------------
*
* Description :This i/p routine is triggered when TELLER transaction is made
* In parameter : None
* out parameter : None
*--------------------------------------------------------------------------------
*
* MODIFICATION HISTORY:
* DATE            WHO           REFERENCE                  DESCRIPTION
*
* 11-02-13    Victor Nava       PACS00245405               Asking user confirmation to generate Passbook print layout with Override (WARNING type),
*                                                          at INPUT stage, this answer will be used to invoke TT.PASSBOOK.PRINT application
*                                                          or NOT. Just for current savings account(s) involved (Passbook Handling)
*26-06-2023    CONVERSION TOOL     R22 AUTO CONVERSION     NO CHANGE
*26-06-2023    VICTORIA S          R22 MANUAL CONVERSION   INSERT FILE MODIFIED.VM TO @VM,FM TO @FM
*03-07-2023    Narmadha            R22 MANUAL CONVERSION   Insert commentedI_F.T24.FUND.SERVICES,so the fields validation on TFS will empact
*----------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_GTS.COMMON
*
    $INSERT I_F.TELLER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.OVERRIDE
    $INSERT I_F.VERSION
    $INSERT I_F.ACCOUNT.CLASS
*$INSERT I_F.T24.FUND.SERVICES ;*R22 MANUAL CONVERSION
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
    IF Y.AC.CUSTO THEN
        GOSUB RAISE.OVE.PASSB
        GOSUB ANALISE.OVE.PASSB
    END
*
RETURN
*
* ================
GET.ACCOUNT.PASSB:
* ================
*
    IF NOT(Y.BOTH.CTEACC) THEN
        Y.CUSTOM.ACCT = Y.ACC1
        IF ALPHA(Y.CUSTOM.ACCT[1,3]) THEN
            Y.CUSTOM.ACCT = Y.ACC2
        END
        GOSUB GET.ACCT.INFO
    END
*
    IF Y.BOTH.CTEACC THEN
        Y.CUSTOM.ACCT = Y.ACC1
        GOSUB GET.ACCT.INFO
        Y.CUSTOM.ACCT = Y.ACC2
        GOSUB GET.ACCT.INFO
    END
*
RETURN
*
* ==============
RAISE.OVE.PASSB:
* ==============
*
*    Y.REC.STAT = R.NEW(TT.TE.RECORD.STATUS)

    IF Y.REC.STAT EQ "" THEN
        VAR.NO.OF.AUTH = R.VERSION(EB.VER.NO.OF.AUTH)
        IF VAR.NO.OF.AUTH EQ '0' THEN
            TEXT    = 'REDO.PASSBOOK.CONF'
            CALL STORE.OVERRIDE('')
        END
*
    END
*
RETURN
*
* ================
ANALISE.OVE.PASSB:
* ================
*Getting the Warnings answer value
*
    IF NOT(Y.OFS.WARNINGS) THEN
        RETURN
    END
*
    IF (Y.OFS.WARNINGS<2,1> MATCHES 'SI':@VM:'YES') THEN ;*R22 MANUAL CONVERSION
        GOSUB SEL.GEN.PASSB
    END
*
RETURN
*
* ==========
GEN.PASSB.1:
* ==========
*
    CALL EB.SET.NEW.TASK('TT.PASSBOOK.PRINT,REDO.PASSB I ':Y.CUSTOM.ACCT)
*
RETURN
*
* ==========
GEN.PASSB.2:
* ==========
*
    Y.CNT.ACCFND        = ''
    Y.CUSTOM.ACCT       = Y.ACC1
    GOSUB GET.ACCT.INFO
    IF Y.CNT.ACCFND THEN
        CALL EB.SET.NEW.TASK('TT.PASSBOOK.PRINT,REDO.PASSB I ':Y.ACC1)
    END
*
    Y.CNT.ACCFND        = ''
    Y.CUSTOM.ACCT       = Y.ACC2
    GOSUB GET.ACCT.INFO
    IF Y.CNT.ACCFND THEN
        CALL EB.SET.NEW.TASK('TT.PASSBOOK.PRINT,REDO.PASSB I ':Y.ACC2)
    END
*
RETURN
*
* ============
SEL.GEN.PASSB:
* ============
*
    IF NOT(Y.BOTH.CTEACC) THEN
        GOSUB GEN.PASSB.1
    END
    ELSE
        GOSUB GEN.PASSB.2
    END
*
RETURN
*
* ============
GET.ACCT.INFO:
* ============
*
    R.ACCOUNT    = "" ; ACCOUNT.ERR = ""
    CALL F.READ(FN.ACCOUNT,Y.CUSTOM.ACCT,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
    Y.AC.LR.SR   = '' ; Y.AC.PASSB = '' ; Y.AC.CUSTO = ''
    Y.AC.LR.SR   = R.ACCOUNT<AC.LOCAL.REF><1,L.AC.SERIES>
    Y.AC.PASSB   = R.ACCOUNT<AC.PASSBOOK>
    Y.AC.CUSTO   = R.ACCOUNT<AC.CUSTOMER>
*   Validating right categories for saving accounts.
    Y.AC.CATEG   = R.ACCOUNT<AC.CATEGORY>
    GOSUB GET.ACC.CLASS
*
    IF Y.BOTH.CTEACC AND Y.AC.LR.SR NE "" AND Y.AC.PASSB EQ "Y" THEN  ;* 2 saving accts. involved with series and passbook printing set up.
        Y.CNT.ACCFND = 1
    END
*
    IF NOT(Y.BOTH.CTEACC) AND (Y.AC.LR.SR EQ "" OR Y.AC.PASSB NE "Y") THEN      ;* 1 saving acct. involved with series and passbook printing set up.
        PROCESS.GOAHEAD = ""
    END
*
    IF Y.BOTH.CTEACC AND (Y.AC.LR.SR EQ "" OR Y.AC.PASSB NE "Y") THEN ;* Increasing counter to get 2 saving accts. status (passbook printing) involved.
        Y.CNT.ACCNOTFND = Y.CNT.ACCNOTFND + 1
    END
*
    IF Y.CNT.ACCNOTFND EQ 2 THEN        ;* Both saving accts. not set up.
        PROCESS.GOAHEAD = ""
    END
*
    IF Y.BOTH.CTEACC AND Y.CNT.ACATEG EQ 2 THEN   ;* Both saving accts. involved with saving accts. invalid categories.
        PROCESS.GOAHEAD = ""
    END
*
    IF NOT(Y.BOTH.CTEACC) AND Y.CNT.ACATEG THEN   ;* Saving acct. involved with saving acct invalid category.
        PROCESS.GOAHEAD = ""
    END
*
RETURN
*
*============
GET.ACC.CLASS:
*============
*

* Fix for PACS00371359 [Passbook warning message not getting triggered coz of Nostro accounts]

    CALL F.READ(FN.ACCOUNT.CLASS,'NOSTRO',R.ACCT.CLASS,F.ACCOUNT.CLASS,ER.ACC.CLASS)
    NOSTRO.ACCT.CATEG = R.ACCT.CLASS<AC.CLS.CATEGORY>
    ACCATEG = Y.AC.CATEG

    FIND ACCATEG IN NOSTRO.ACCT.CATEG SETTING NOS.FOUND.POSN1,NOS.FOUND.POSN THEN
        RETURN      ;* Nostro Accounts doesn't require this check
    END

* End of Fix

    ER.ACC.CLASS = '' ; SAV.ACCT.CATEG = '' ; SAV.FOUND.POSN1 = '' ; SAV.FOUND.POSN = '' ; R.ACCT.CLASS = ''
    CALL F.READ(FN.ACCOUNT.CLASS,'SAVINGS',R.ACCT.CLASS,F.ACCOUNT.CLASS,ER.ACC.CLASS)
    SAV.ACCT.CATEG = R.ACCT.CLASS<AC.CLS.CATEGORY>
*
    FIND ACCATEG IN SAV.ACCT.CATEG SETTING SAV.FOUND.POSN1,SAV.FOUND.POSN ELSE S = ''
    IF SAV.FOUND.POSN EQ '' THEN
        Y.CNT.ACATEG = Y.CNT.ACATEG + 1
        PROCESS.GOAHEAD = ''
    END
*
RETURN
*
* =========
INITIALISE:
* =========
*
    PROCESS.GOAHEAD  = 1
*
    Y.OFS.WARNINGS   = OFS$WARNINGS
    Y.BOTH.CTEACC    = ''
    Y.CNT.ACCNOTFND  = 0
    Y.CNT.ACCFND     = ''
*    CURR.NO          = DCOUNT(R.NEW(TT.TE.OVERRIDE),VM)
*
    FN.ACCOUNT       = 'F.ACCOUNT'
    F.ACCOUNT        = ''
*
    FN.ACCOUNT.CLASS = 'F.ACCOUNT.CLASS'
    F.ACCOUNT.CLASS  = ''
*
    LF.APP           = 'ACCOUNT':@FM:'TELLER' ;*R22 MANUAL CONVERSION
    LF.FLD           = 'L.SERIES.ID':@FM:'L.TT.AZ.ACC.REF' ;*R22 MANUAL CONVERSION
    LF.POS           = ''
    CALL MULTI.GET.LOC.REF(LF.APP,LF.FLD,LF.POS)
    L.AC.SERIES      = LF.POS<1,1>
    L.TT.TTAZAC      = LF.POS<2,1>
*
    IF APPLICATION EQ 'TELLER' THEN
        Y.ACC1           = R.NEW(TT.TE.ACCOUNT.1)
        Y.ACC2           = R.NEW(TT.TE.ACCOUNT.2)
        Y.CUS1           = R.NEW(TT.TE.CUSTOMER.1)
        Y.CUS2           = R.NEW(TT.TE.CUSTOMER.2)
        Y.ACC.AZ         = R.NEW(TT.TE.LOCAL.REF)<1,L.TT.TTAZAC>      ;* PACS00290640 - S/E
        Y.REC.STAT       = R.NEW(TT.TE.RECORD.STATUS)
        CURR.NO          = DCOUNT(R.NEW(TT.TE.OVERRIDE),@VM) ;*R22 MANUAL CONVERSION
    END

    IF APPLICATION EQ 'T24.FUND.SERVICES' THEN
        Y.ACC1           = R.NEW(TFS.PRIMARY.ACCOUNT)
        Y.ACC2           = ''
        Y.CUS1           = ''
        Y.CUS2           = ''
        Y.ACC.AZ         = ''
        Y.REC.STAT       = R.NEW(TFS.RECORD.STATUS)
        CURR.NO          = DCOUNT(R.NEW(TFS.OVERRIDE),@VM) ;*R22 MANUAL CONVERSION
    END

*
    Y.CUSTOM.ACCT    = ''
    Y.AC.CUSTO       = ''
    Y.AC.LREF.SR     = ''
    Y.AC.PASSBOK     = ''
*
    SAV.ACCT.CATEG   = ''
    R.ACCT.CLASS     = ''
    Y.AC.CATEG       = ''
    ACCATEG          = ''
    Y.CNT.ACATEG     = ''
*
RETURN
*
* =========
OPEN.FILES:
* =========
*
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL OPF(FN.ACCOUNT.CLASS,F.ACCOUNT.CLASS)
*
RETURN
*
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
    LOOP.CNT  = 1
    MAX.LOOPS = 3
*
    LOOP WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD
        BEGIN CASE

            CASE LOOP.CNT EQ 1
*
                IF ALPHA(Y.ACC1[1,3]) AND ALPHA(Y.ACC2[1,3]) THEN
                    PROCESS.GOAHEAD = ''
                END
*
            CASE LOOP.CNT EQ 2
*
                IF Y.CUS1 AND Y.CUS2 THEN
                    Y.BOTH.CTEACC = '1'
                END
*
                GOSUB GET.ACCOUNT.PASSB
*
            CASE LOOP.CNT EQ 3
* PACS00290640 - S
                IF Y.ACC.AZ NE "" THEN
                    PROCESS.GOAHEAD = ''
                END
* PACS00290640 - E
        END CASE
*
        LOOP.CNT += 1
    REPEAT
*
RETURN
*
END
