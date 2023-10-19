$PACKAGE APAP.TAM
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE           WHO                 REFERENCE               DESCRIPTION
*24-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     VM TO @VM,FM TO @FM,SM TO @SM
*24-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     F.READ TO CACH.READ
*24-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     ++ TO +=1
*24-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     I TO I.VAR
*24-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.V.INP.LIMIT.CHECK
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*Program   Name    :REDO.V.INP.LIMIT.CHECK
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is used to check transaction limit and throw Override
*
*LINKED WITH       :VERSION.CONTROL - TELLER record.
* ----------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_F.USER
    $INSERT I_F.TELLER
    $INSERT I_F.TELLER.PARAMETER
    $INSERT I_F.TELLER.TRANSACTION
*
    GOSUB INIT
    GOSUB OPEN.FILES

    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN
*
*------*
PROCESS:
*------*
*
*
    IF R.NEW(TT.TE.DR.CR.MARKER) EQ "CREDIT" THEN
        W.ACCOUNT = R.NEW(TT.TE.ACCOUNT.1)
        LOC.AMT   = R.NEW(TT.TE.LOCAL.REF)<1,POS.CREDIT>
        WDEB.ACCT = R.NEW(TT.TE.ACCOUNT.2)
    END ELSE
        W.ACCOUNT = R.NEW(TT.TE.ACCOUNT.2)
        LOC.AMT   = R.NEW(TT.TE.LOCAL.REF)<1,POS.DEBIT>
        WDEB.ACCT = R.NEW(TT.TE.ACCOUNT.1)
    END

    IF LOC.AMT EQ '' AND PGM.VERSION EQ ',REINV.WDL' THEN
        LOC.AMT   = R.NEW(TT.TE.LOCAL.REF)<1,POS.CREDIT>
    END

*
    IF (ALPHA(W.ACCOUNT[1,3]) AND W.ACCOUNT[4,5] EQ "10001") OR NUM(WDEB.ACCT) OR WLIMIT.CHK.FLG EQ "YES" THEN
        IF LOC.AMT GT TOT.AMT AND TOT.AMT GT 0 THEN
            TEXT    = 'TT.INSUFF.AMOUNT'
            CURR.NO = DCOUNT(R.NEW(TT.TE.OVERRIDE),@VM) + 1 ;*R22 AUTO CONVERSION
            CALL STORE.OVERRIDE(CURR.NO)
        END
    END
*
RETURN
*
* ================
GET.CASHIER.LIMIT:
* ================
*
    TELL.ID = ID.COMPANY
    TOT.AMT = 0
    VCOUNT  = 0
    DESN    = ""
*
    LIMIT.DESGN = ""
    LIMIT.CCY   = ""
*
    R.TELLER.PARAMETER = ""
*
    CALL CACHE.READ(FN.TELLER.PARAMETER, TELL.ID, R.TELLER.PARAMETER, TELL.ERR) ;*R22 AUTO CONVERSION
    IF R.TELLER.PARAMETER EQ "" THEN
        AF              = TT.TE.AMOUNT.LOCAL.1
        ETEXT           = "TT-RECORD.&.NOT.IN.TELLER.PARAMETER":@FM:TELL.ID ;*R22 AUTO CONVERSION
        PROCESS.GOAHEAD = ""
        CALL STORE.END.ERROR
    END ELSE
        DESN   = R.TELLER.PARAMETER<TT.PAR.LOCAL.REF><1,LOC.DESGN>
        VCOUNT = DCOUNT(DESN,@SM) ;*R22 AUTO CONVERSION
    END
*
*----------------------------------------------------------------------------
* Looping through the parameters to get LIMIT for cashier
*----------------------------------------------------------------------------
*
* Modifed below from FOR...NEXT to LOOP...REPEAT as part of the code review
*
    I.VAR = 1 ;*R22 AUTO CONVERSION
    LOOP
*        I = 1
        LIMIT.DESGN = R.TELLER.PARAMETER<TT.PAR.LOCAL.REF><1,LOC.DESGN,I.VAR> ;*R22 AUTO CONVERSION START
        LIMIT.CCY   = R.TELLER.PARAMETER<TT.PAR.LOCAL.REF><1,LOC.LIMIT.CCY,I.VAR>
    WHILE (I.VAR LE VCOUNT)
        IF LIMIT.DESGN EQ CASHIER.ROLE AND LIMIT.CCY EQ TRAN.CCY THEN
            LIMIT.AMT = R.TELLER.PARAMETER<TT.PAR.LOCAL.REF><1,LOC.LIMIT.AMT,I.VAR>
            TOT.AMT += LIMIT.AMT ;*R22 AUTO CONVERSION END
*            I         = VCOUNT + 1
        END

        I.VAR += 1 ;*R22 AUTO CONVERSION

    REPEAT
*
RETURN
*
*-------------*
GET.TTTX.LIMIT:
*-------------*
*
    R.TELLER.TRANSACTION = ""
    TTTX.ERR             = ""
*
    CALL CACHE.READ(FN.TELLER.TRANSACTION, TTTX.ID, R.TELLER.TRANSACTION, TTTX.ERR) ;*R22 AUTO CONVERSION
    IF R.TELLER.TRANSACTION EQ "" THEN
        AF              = TT.TE.TRANSACTION.CODE
        ETEXT           = "EB-TELLER.TRANSACTION.&.NOT.DEFINED":@FM:TTTX.ID ;*R22 AUTO CONVERSION
        PROCESS.GOAHEAD = ""
        CALL STORE.END.ERROR
    END

    IF R.TELLER.TRANSACTION NE "" THEN
        WLIMIT.CHK.FLG = R.TELLER.TRANSACTION<TT.TR.LOCAL.REF,POS.LIMIT.FLG>
    END
*
RETURN
*
*----*
INIT:
*----*
*
    PROCESS.GOAHEAD = 1
*
    LOC.REF.APPLICATION = 'USER' : @FM : 'TELLER.PARAMETER' : @FM : "TELLER" : @FM : "TELLER.TRANSACTION" ;*R22 AUTO CONVERSION
    LOC.REF.FIELDS      = 'L.US.CASIER.ROL':@FM:'L.TT.DESGN':@VM:'L.TT.LIMIT.CCY':@VM:'L.TT.LIMIT.AMT':@FM:"L.CREDIT.AMOUNT":@VM:"L.DEBIT.AMOUNT":@FM:"L.CHECK.LIMIT" ;*R22 AUTO CONVERSION
    LOC.REF.POS         = ''
*
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)

    CASH.ROLE      = LOC.REF.POS<1,1>
*
    LOC.DESGN      = LOC.REF.POS<2,1>
    LOC.LIMIT.CCY  = LOC.REF.POS<2,2>
    LOC.LIMIT.AMT  = LOC.REF.POS<2,3>
*
    POS.CREDIT     = LOC.REF.POS<3,1>
    POS.DEBIT      = LOC.REF.POS<3,2>
*
    POS.LIMIT.FLG  = LOC.REF.POS<4,1>
*
    FN.TELLER.PARAMETER = 'F.TELLER.PARAMETER'
    F.TELLER.PARAMETER=''
*
    FN.TELLER.TRANSACTION = 'F.TELLER.TRANSACTION'
    F.TELLER.TRANSACTION=''
*
    CASHIER.ROLE   = R.USER<EB.USE.LOCAL.REF><1,CASH.ROLE>
    TRAN.CCY       = R.NEW(TT.TE.CURRENCY.1)
*
    TTTX.ID        = R.NEW(TT.TE.TRANSACTION.CODE)
    WLIMIT.CHK.FLG = ""
*
RETURN
*
*----------*
OPEN.FILES:
*----------*
*
    CALL OPF(FN.TELLER.PARAMETER,F.TELLER.PARAMETER)
*
    CALL OPF(FN.TELLER.TRANSACTION,F.TELLER.TRANSACTION)
*
RETURN
*
****
*
*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
    LOOP.CNT  = 1   ;   MAX.LOOPS = 3
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE

            CASE LOOP.CNT EQ 1
                IF CASHIER.ROLE EQ '' THEN
                    AF              = TT.TE.AMOUNT.LOCAL.1
                    ETEXT           = 'TT-CASHIER.ROLE.MISSING'
                    PROCESS.GOAHEAD = ""
                    CALL STORE.END.ERROR
                END
*
            CASE LOOP.CNT EQ 2
                GOSUB GET.CASHIER.LIMIT
*
            CASE LOOP.CNT EQ 3
                GOSUB GET.TTTX.LIMIT
*
        END CASE
*
*       Increase
*
        LOOP.CNT += 1
*
    REPEAT
*
RETURN
*
END
