* @ValidationCode : MjotMzMwMzExNzc5OkNwMTI1MjoxNjg0ODM2MDMyNTczOklUU1M6LTE6LTE6MzM0OjE6ZmFsc2U6Ti9BOlIyMl9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 334
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.ACCOUNT.CHECK
*-----------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :H GANESH
*Program   Name    :REDO.APAP.ACCOUNT.CHECK
*---------------------------------------------------------------------------------

*DESCRIPTION       :This Validation routine check and deceased account and raise an ERROR.
*LINKED WITH       :  Account No field in TELLER FT TFS.

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*  DATE             WHO         REFERENCE         DESCRIPTION
* 28-FEB-2011    H GANESH      PACS00033051      Modified for Deaceased Status.
* Date                   who                   Reference
* 04-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION VM TO @VM AND FM TO @FM AND = TO EQ
* 04-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.EB.LOOKUP
    $INSERT I_F.TELLER
*
    $INSERT I_REDO.TELLER.COMMON
    $INSERT I_F.REDO.H.PAY.VERSION
	$USING APAP.REDOVER
*
    GOSUB INIT
    GOSUB PREPROCESS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

    CALL APAP.REDOVER.redoVInpTtAcVal()


RETURN

*-----------------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------------
*
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
*
    FN.REDO.H.PAY.VERSION = 'F.REDO.H.PAY.VERSION'
    F.REDO.H.PAY.VERSION  = ''

    FN.EB.LOOKUP = 'F.EB.LOOKUP'
    F.EB.LOOKUP  = ''
*
    LREF.APP   = 'ACCOUNT':@FM:'TELLER'
    LREF.FIELD = 'L.AC.STATUS2':@VM:'L.AC.AV.BAL':@FM:'L.TT.AZ.ACC.REF'
    LREF.POS   = ''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELD,LREF.POS)
    POS.L.AC.STATUS2    = LREF.POS<1,1>
    LOC.L.AC.AV.BAL.POS = LREF.POS<1,2>
    POS.L.TT.AZ.ACC.REF = LREF.POS<2,1>

    PROCESS.GOAHEAD = 1
*
    CALL OPF(FN.REDO.H.PAY.VERSION,F.REDO.H.PAY.VERSION)
    CALL OPF(FN.EB.LOOKUP,F.EB.LOOKUP)
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
*
    R.REDO.H.PAY.VERSION = ''
    R.ACCOUNT            = ''
*
RETURN
*
* =========
PREPROCESS:
* =========
*
    LOOP.CNT  = 1   ;   MAX.LOOPS = 3
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
            CASE LOOP.CNT EQ 1

                Y.ACCOUNT.NO = COMI
                IF Y.ACCOUNT.NO[1,3] MATCHES '3A' THEN
                    PROCESS.GOAHEAD = ""
                END

            CASE LOOP.CNT EQ 2
                CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.NO,R.ACCOUNT,F.ACCOUNT,DEB.ERR)
                IF R.ACCOUNT EQ '' THEN
                    PROCESS.GOAHEAD = ""
                END

            CASE LOOP.CNT EQ 3
                Y.CATEGORY   = R.ACCOUNT<AC.CATEGORY>
                Y.CURRENCY   = R.ACCOUNT<AC.CURRENCY>
                Y.AC.STATUS2 = R.ACCOUNT<AC.LOCAL.REF,POS.L.AC.STATUS2>
*
                IF APPLICATION EQ "TELLER" THEN
                    GOSUB VALIDATE.ACCOUNT.CURRENCY
                END

        END CASE
*       Increase
        LOOP.CNT += 1
*
    REPEAT
*
RETURN
*
*-----------------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------------
*
    Y.VERSION.NAME = APPLICATION:PGM.VERSION
    CALL CACHE.READ(FN.REDO.H.PAY.VERSION,'SYSTEM',R.REDO.H.PAY.VERSION,Y.ERR.PAR)
    Y.PAYMENT.LIST = R.REDO.H.PAY.VERSION<REDO.H.VER.PAYMENT.TYPE>
    Y.VERSION.LIST = R.REDO.H.PAY.VERSION<REDO.H.VER.VERSIONS>
    CHANGE @VM TO @FM IN Y.VERSION.LIST

    LOCATE Y.VERSION.NAME IN Y.VERSION.LIST SETTING VER.POS ELSE
        IF APPLICATION EQ 'TELLER' THEN
            GOSUB CHECK.TELLER.PROCESS
        END ELSE
            GOSUB CHECK.INT.LIQ.ACC
        END

    END
*
    FIELD.NAME = FT.DEBIT.ACCT.NO
    R.SS = ''
    CALL FIELD.NAMES.TO.NUMBERS(FIELD.NAME,R.SS,FIELD.NO,'','','','','')

    IF APPLICATION EQ 'FUNDS.TRANSFER' AND AF EQ FIELD.NO OR APPLICATION EQ 'TELLER' THEN   ;*R22 AUTO CONVERSTION = TO EQ
        L.AC.AV.BAL = ''
        L.AC.AV.BAL = R.ACCOUNT<AC.LOCAL.REF,LOC.L.AC.AV.BAL.POS>
    END

    LOCATE 'DECEASED' IN Y.AC.STATUS2<1,1,1> SETTING POS1 THEN
        IF Y.CATEGORY AND (Y.CATEGORY GE "3000" AND Y.CATEGORY LE "3999") ELSE
            ETEXT='EB-REDO.ACC.DECEASED':@FM:R.ACCOUNT<AC.CUSTOMER>:@VM:Y.ACCOUNT.NO
            CALL STORE.END.ERROR
        END
    END

RETURN
*
*--------------------------------------------------------------------------------------
CHECK.TELLER.PROCESS:
*---------------------------------------------------------------------------------------
    VAR.TT.ACC.REF = R.NEW(TT.TE.LOCAL.REF)<1,POS.L.TT.AZ.ACC.REF>
    IF VAR.TT.ACC.REF THEN
        IF Y.ACCOUNT.NO EQ VAR.TT.ACC.REF THEN
            GOSUB CHECK.INT.LIQ.ACC
        END
    END ELSE
        GOSUB CHECK.INT.LIQ.ACC
    END
RETURN
*--------------------------------------------------------------------------------------
CHECK.INT.LIQ.ACC:
*---------------------------------------------------------------------------------------
    IF Y.CATEGORY GE 6011 AND Y.CATEGORY LE 6020 THEN
        ETEXT = 'EB-REDO.REINV.ACC.CHECK'
        CALL STORE.END.ERROR
    END
RETURN
* ========================
VALIDATE.ACCOUNT.CURRENCY:
* ========================
*
    IF AF EQ TT.TE.ACCOUNT.1 THEN  ;*R22 AUTO CONVERSTION = TO EQ
        W.CURRENCY = R.NEW(TT.TE.CURRENCY.1)
    END ELSE
        W.CURRENCY = R.NEW(TT.TE.CURRENCY.2)
    END
*
    IF W.CURRENCY AND (Y.CURRENCY NE W.CURRENCY) THEN
        ETEXT = 'EB-ACCT.CURRENCY'
        CALL STORE.END.ERROR
    END
*
RETURN
*
END
