* @ValidationCode : MjotMTk2MDY3ODc3NjpDcDEyNTI6MTY5ODc1MDY3Mzk5NDpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 31 Oct 2023 16:41:13
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
$PACKAGE APAP.TFS
*-----------------------------------------------------------------------------
* <Rating>326</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE TFS.FACILITATE.MIX.WD
*
* Subroutine Type : PROCEDURE
* Attached to     : TFS.PARAMETER MIX.WD.API
* Attached as     :
* Primary Purpose : Populate txn lines for coin Dispense txns
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
*
*
* Error Variables:
* ----------------
*
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* 07/09/05 - Ganesh Prasad K
*            Coin dispensing using TFS
*
* 07/24/05 - Ganesh Prasad K
*            Modified the calcualtion of CDM.TILL.ACCT
*-----------------------------------------------------------------------------------

*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*26/10/2023         Ajithkumar             R22 Manual Conversion       GLOBUS.BP,USPLATFORM.BP file removed
*

    $INCLUDE  I_COMMON ;*R22 Manual Conversion - START
    $INCLUDE  I_EQUATE
    $INCLUDE  I_F.CURRENCY

    $INCLUDE  I_GTS.COMMON
    $INCLUDE  I_F.TELLER.ID

    $INCLUDE  I_T24.FS.COMMON
    $INCLUDE  I_F.TFS.PARAMETER
    $INCLUDE  I_F.T24.FUND.SERVICES
    $INCLUDE  I_F.CDM.PARAMETER ;*R22 Manual Conversion - END

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB READ.TFS.TXN.REC
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN          ;*Main return
*-----------------------------------------------------------------------------------
PROCESS:
*-------*

    GOSUB FORM.WASH.THROUGH.ACCOUNT
    GOSUB SPLIT.TXN.AMOUNT
    GOSUB POPULATE.FIELDS

RETURN          ;*From process
*-----------------------------------------------------------------------------------
FORM.WASH.THROUGH.ACCOUNT:
*------------------------*

    WASH.THROUGH.CATEG = TFS$R.TFS.PAR<TFS.PAR.MIX.WD.WASH.THRU>

RETURN          ;*from  Form wash through acct
*----------------------------------------------------------------*
SPLIT.TXN.AMOUNT:
*----------------*

    IF NOT(R.NEW(TFS.MIX.WD.CCY)) THEN R.NEW(TFS.MIX.WD.CCY) = LCCY
    MIX.WD.CCY = R.NEW(TFS.MIX.WD.CCY)
    CALL CACHE.READ(FN.CURRENCY,MIX.WD.CCY,R.MIX.CCY,ER.CCY)
    IF R.MIX.CCY THEN
        NO.OF.DECIMALS = R.MIX.CCY<EB.CUR.NO.OF.DECIMALS>
        DIV.FACTOR = 1:STR('0',NO.OF.DECIMALS)    ;*Form div to get actual decimals reqd
        TXN.AMOUNT = WD.AMOUNT
        WHOLE.AMT = INT(TXN.AMOUNT)
        FRACTION.AMT = TXN.AMOUNT - WHOLE.AMT
        IF FRACTION.AMT EQ '' THEN
            FRACTION.AMT = STR('0',NO.OF.DECIMALS)
        END
    END

RETURN          ;*From split.txn.amount
*----------------------------------------------------------------*
READ.TFS.TXN.REC:
*----------------*

    CALL F.READ(FN.TFS.TRANSACTION,MIX.TFS.TXN.TYPE,R.TFS.TXN.TYPE,F.TFS.TRANSACTION,ER.TFS.TRANSACTION)
    IF ER.TFS.TRANSACTION THEN
        PROCESS.GOAHEAD = 0
    END

RETURN          ;*from read tfs txn rec

*----------------------------------------------------------------*
POPULATE.FIELDS:
*--------------*
*
* Although the MIX.WD.SRC.AC is a multi valued field, right now it is assumed that
* only 2 multi values are there - 1 for the CDM cash account and the other for the
* Teller cash till
* The CDM Cash account will be populated with the Whole amount and the Teller Cash
* Till will be populated with the Coins
    R.NEW(TFS.MIX.WD.SRC.ACC) = ''
    R.NEW(TFS.MIX.WD.SRC.AMT) = ''
*
    NO.OF.MIX.WD.SRC.CAT = DCOUNT(TFS$R.TFS.PAR<TFS.PAR.MIX.WD.SRC.CAT>,@VM)
    !IF WHOLE.AMT THEN
    FOR SRC.CNT = 1 TO NO.OF.MIX.WD.SRC.CAT
        SRC.CAT = TFS$R.TFS.PAR<TFS.PAR.MIX.WD.SRC.CAT,SRC.CNT>
        IF SRC.CAT EQ R.CDM.PAR<CDM.PAR.CDM.CATEGORY> THEN
*        GOSUB GET.CDM.TELLER.ID                                 07/24/05 GP /s
            CALL US.GET.CDM.TILL.ACCT(CDM.TILL.ACCT,ERR.MSG)          ;*07/24/05 GP /e
        END ELSE
            GOSUB GET.TELLER.ID
        END
        IF PROCESS.GOAHEAD THEN
            BEGIN CASE
                CASE SRC.CNT EQ 1
*  R.NEW(TFS.MIX.WD.SRC.ACC)<1,SRC.CNT> = R.NEW(TFS.MIX.WD.CCY) : SRC.CAT : CDM.TELLER.ID ;*07/24/05 /s
                    IF WHOLE.AMT THEN       ;* Sesh -S
                        IF CDM.TILL.ACCT THEN
                            R.NEW(TFS.MIX.WD.SRC.ACC)<1,-1> = CDM.TILL.ACCT         ;*07/24/05 /e
                        END
                        R.NEW(TFS.MIX.WD.SRC.AMT)<1,-1> = WHOLE.AMT
                    END    ; * Sesh - E

                CASE SRC.CNT EQ 2
                    IF FRACTION.AMT THEN       ; * Sesh - S
                        R.NEW(TFS.MIX.WD.SRC.ACC)<1,-1> = R.NEW(TFS.MIX.WD.CCY) : SRC.CAT : TELLER.ID
                        R.NEW(TFS.MIX.WD.SRC.AMT)<1,-1> = FRACTION.AMT
                    END  ; * Sesh - E
            END CASE

        END ELSE
            BREAK
        END
    NEXT SRC.CNT
    ! END

RETURN          ;*pop fields
*-----------------------------------------------------------------------------------
*This is never called now using a different call routine to arrive at CDM.TILL.ACCT
*GET.CDM.TELLER.ID:
*
*    CDM.TELLER.ID = ''
*    GOSUB GET.TELLER.ID
*    CALL F.READ(FN.TI,TELLER.ID,R.TI,F.TI,ERR.TI)
*    IF R.TI THEN
*        CALL GET.LOC.REF.CACHE('TELLER.ID','CDM.TELLER.ID',CDM.TI.POS,TI.LREF.ERR)
*        IF TI.LREF.ERR THEN
*            E = RAISE(TI.LREF.ERR<1>)
*            PROCESS.GOAHEAD = 0
*        END ELSE
*            CDM.TELLER.ID = R.TI<TT.TID.LOCAL.REF,CDM.TI.POS>
*            CALL F.READ(FN.TI,CDM.TELLER.ID,R.CDM.TI,F.TI,ERR.TI)
*            IF ERR.TI THEN
*                E = 'EB-TFS.CDM.TELLER.ID.MISSING'
*                CDM.TELLER.ID = ''
*                PROCESS.GOAHEAD = 0
*            END
*        END
*    END

*    RETURN
*------------------------------------------------------------------------------------
GET.TELLER.ID:

    CALL US.GET.OPEN.TILL(TELLER.ID)

RETURN
*-------------------------------------------------------------------------------------
*//////////////////////////////////////////////////////////////////////////////////*
*////////////////P R E  P R O C E S S  S U B R O U T I N E S //////////////////////*
*//////////////////////////////////////////////////////////////////////////////////*
INITIALISE:

    PROCESS.GOAHEAD = 1

    MIX.TFS.TXN.TYPE = TFS$R.TFS.PAR<TFS.PAR.MIX.WASH.TXN.TYPE>


RETURN          ;*from initialise
*-----------------------------------------------------------------------------------
OPEN.FILES:
*---------*

    FN.TFS.TRANSACTION = 'F.TFS.TRANSACTION'
    CALL OPF(FN.TFS.TRANSACTION,F.TFS.TRANSACTION)

    FN.CDM.PAR = 'F.CDM.PARAMETER' ; F.CDM.PAR = ''
    CALL OPF(FN.CDM.PAR,F.CDM.PAR)

    FN.CURRENCY = 'F.CURRENCY' ; F.CURRENCY = ''
    CALL OPF(FN.CURRENCY,F.CURRENCY)

    FN.TI = 'F.TELLER.ID' ; F.TI = ''
    CALL OPF(FN.TI,F.TI)

RETURN          ;*from OPEN.FILES
*-----------------------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:
*
    LOOP.CNT = 1 ; MAX.LOOPS = 3
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO

        BEGIN CASE
            CASE LOOP.CNT EQ 1
                IF APPLICATION NE 'T24.FUND.SERVICES' THEN PROCESS.GOAHEAD = 0

            CASE LOOP.CNT EQ 2
                IF AF EQ TFS.MIX.WD.AMOUNT THEN
                    WD.AMOUNT = COMI
                END ELSE
                    WD.AMOUNT = R.NEW(TFS.MIX.WD.AMOUNT)
                END
                IF NOT(WD.AMOUNT) THEN PROCESS.GOAHEAD = 0

            CASE LOOP.CNT EQ 3
                ID.CDM.PAR = ID.COMPANY ; R.CDM.PAR = '' ; ERR.CDM.PAR = ''
                CALL CACHE.READ(FN.CDM.PAR,ID.CDM.PAR,R.CDM.PAR,ERR.CDM.PAR)

        END CASE
        LOOP.CNT += 1
    REPEAT

RETURN          ;*check prelim conds
*-----------------------------------------------------------------------------------
END
