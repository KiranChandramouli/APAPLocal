* @ValidationCode : MjoxMjY2MjA4MDI0OkNwMTI1MjoxNjk4NDA1NTM5NDgzOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Oct 2023 16:48:59
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.IBS
*-----------------------------------------------------------------------------
* <Rating>542</Rating>
*-----------------------------------------------------------------------------
*    SUBROUTINE AT.GET.ACCT.ENT.DETLS(Y.ACCT.NO,NO.OF.TXNS,TXN.DETLS)
    SUBROUTINE ITSS.MF.GET.MINI.STMT(REQUEST)


*-----------------------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE                          AUTHOR                   Modification                            DESCRIPTION
*25/10/2023                VIGNESHWARI        MANUAL R23 CODE CONVERSION               FM TO @FM
*-----------------------------------------------------------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.INTERCO.PARAMETER
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TRANSACTION
    $INSERT I_EB.MOB.FRMWRK.COMMON

    GOSUB INITIALISE

    GOSUB PROCESS


    RETURN
*-------------------------------------------------------------------------------
INITIALISE:
*
* get the branch mnemonic using the account no

TOKEN.ID = REQUEST

    Y.ACCT.NO = REQUEST[',', 1, 1]
    DATE.FROM = REQUEST[',', 2, 1]
*    DATE.TO = REQUEST[',', 3, 1]
     DATE.TO = TODAY

    IF NOT(Y.ACCT.NO) THEN
        RETURN
    END

   IF DATE.FROM ="" THEN
     DATE.FROM =DATE.TO-30
   END

    IF NOT(DATE.FROM) THEN
        NO.OF.TXNS = 5
    END

    CALL GET.ACCT.BRANCH(Y.ACCT.NO,Y.ACCT.BR.MNE,Y.ACCT.COMP.CDE)

    FN.ACCOUNT = 'F':Y.ACCT.BR.MNE:'.ACCOUNT'
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)      ;*open after changing com
*
    FN.STMT.ENTRY = 'F':Y.ACCT.BR.MNE:'.STMT.ENTRY'
    CALL OPF(FN.STMT.ENTRY,F.STMT.ENTRY)          ;*open after changing com
*
    FN.ACCT.ENT.TODAY = 'F':Y.ACCT.BR.MNE:'.ACCT.ENT.TODAY'
    CALL OPF(FN.ACCT.ENT.TODAY,F.ACCT.ENT.TODAY)  ;*open after changing com
*
    FN.ACCT.STMT.PRINT = 'F':Y.ACCT.BR.MNE:'.ACCT.STMT.PRINT'
    CALL OPF(FN.ACCT.STMT.PRINT,F.ACCT.STMT.PRINT)
*
    FN.STMT.PRINTED = 'F':Y.ACCT.BR.MNE:'.STMT.PRINTED'
    FN.STMT.PRINTED = 'F.STMT.PRINTED'
    CALL OPF(FN.STMT.PRINTED,F.STMT.PRINTED)      ;*open after changing

    RETURN          ;*initialise

*-------------------------------------------------------------------------------
PROCESS:
*
    GOSUB GET.STMT.IDS

    REQUEST = STMT.IDS

    RETURN

GET.STMT.IDS:
*
*Changed by anitha for r6 release.

    GOSUB GET.STMT.PRINTED.IDS

    IF Y.SELECTED.PRINTED THEN
        I=1
        STPT.CNT = DCOUNT(Y.SELECTED.PRINTED, @FM)

        FOR J=STPT.CNT TO 1 STEP -1
*        LOOP
*            REMOVE STMT.PRINTED.ID FROM Y.SELECTED.PRINTED SETTING POS
*        WHILE STMT.PRINTED.ID:POS
            STMT.PRINTED.ID = Y.SELECTED.PRINTED<J>
            CALL F.READ(FN.STMT.PRINTED, STMT.PRINTED.ID, R.STMT.PRINTED, F.STMT.PRINTED, E.STMT.PRINTED)
            IF NOT(E.STMT.PRINTED) THEN
                TOT.COUNT = DCOUNT(R.STMT.PRINTED, @FM)
                FOR K=TOT.COUNT TO 1 STEP -1
                    STMT.ID = R.STMT.PRINTED<K>
                    CALL F.READ(FN.STMT.ENTRY, STMT.ID, R.STMT.ENTRY, F.STMT.ENTRY, E.STMT.ENTRY)
                    STMT.ENT.DATE = R.STMT.ENTRY<AC.STE.BOOKING.DATE>
                    BEGIN CASE
                    CASE DATE.TO
                        IF STMT.ENT.DATE LE DATE.TO AND STMT.ENT.DATE GE DATE.FROM THEN
                            STMT.IDS<I> = STMT.ID
                        END
                        IF STMT.ENT.DATE LT DATE.FROM THEN
                            BREAK
                        END ELSE
                            IF STMT.ENT.DATE GT DATE.TO THEN CONTINUE
                        END
                    CASE DATE.FROM
                        IF STMT.ENT.DATE GE DATE.FROM THEN
                            STMT.IDS<I> = STMT.ID
                        END ELSE
                            BREAK
                        END
                    CASE NO.OF.TXNS
                        IF DCOUNT(STMT.IDS,@FM) GT NO.OF.TXNS THEN
                            BREAK
                        END
                        ELSE
                            STMT.IDS<I> = STMT.ID
                        END
                    END CASE
*                    STMT.IDS<I> = R.STMT.PRINTED<J>
*                    IF I GE REQ.NO.OF.STMTS THEN
*                        BREAK
*                    END
                    I++
                NEXT K
            END
*        REPEAT
        NEXT J
    END


*    IF  I > REQ.NO.OF.STMTS THEN  I = REQ.NO.OF.STMTS

    RETURN          ;*From get.stmt.ids

*-------------------------------------------------------------------------------
GET.STMT.PRINTED.IDS:


    CALL F.READ(FN.ACCT.STMT.PRINT, Y.ACCT.NO, R.ACCT.STMT.PRINT, F.ACCT.STMT.PRINT, E.ASP)

    IF NOT(E.ASP) THEN
        STMT.DATES = FIELDS(R.ACCT.STMT.PRINT, '/', 1)
*        Y.SELECTED.PRINTED = SPLICE(Y.ACCT.NO,'-',STMT.DATES)
        STDAT.CNT = DCOUNT(STMT.DATES, @FM)
        FOR I=1 TO STDAT.CNT
            Y.SELECTED.PRINTED<-1> = Y.ACCT.NO:'-':STMT.DATES<I>
        NEXT I
    END

*    Y.ALL.COUNT = DCOUNT(Y.SELECTED.PRINTED,FM)
*    Y.NEW.LIST = ""
*    FOR I=1 TO Y.ALL.COUNT
*        Y.NEW.LIST<-1>=Y.SELECTED.PRINTED<Y.ALL.COUNT-I+1>
*    NEXT I
*    Y.SELECTED.PRINTED = Y.NEW.LIST



    RETURN

*-------------------------------------------------------------------------------
END
