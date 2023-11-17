* @ValidationCode : Mjo2OTE3NzU3OTpDcDEyNTI6MTY5ODc1MDY3MzA0OTpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
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
* <Rating>913</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE T24.FS.CHECK.RECORD
*
* Check Record procedure for T24.FUND.SERVICES template program
*
*------------------------------------------------------------------------------
* Modification history:
*
* 03/12/05 - Sathish PS
*            New Development - Moved contents of CHECK.RECORD into this subroutine.
*
* 03/24/05 - Sathish PS
*            Functionality to restrict amendments for Authorised records + Accounting
*            Mode = ATOMIC
*
* 29 AUG 07 - Sathish PS
*             Check TELLER ID During authorisation
*
* 12 SEP 07 - Sathish PS
*             If NET.ENTRY set to CREDIT, DEBIT or BOTH, disable input to ACCOUNT.CR &
*             ACCOUNT.DR.
*             Also, dont do any processing if MESSAGE = 'HLD'
*
* 02 AUG 11 - Muthukaruppan - PACS00094380
*             when try to reverse a TFS record, getting an error Live Entries Exist
*             problem is that if the field UNDERLYING holds a value and R.UL.STATUS
*             does not match either AUT or REVE, then the system throws an error
* 05 AUG 11 - Muthukaruppan - PACS00094380 - TUT1160653 and TUT1160654 - Issue Fixed.
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*26/10/2023         Suresh             R22 Manual Conversion             GLOBUS.BP File Removed,USPLATFORM.BP File Removed, CALL routine format modified, FM TO @FM, VM TO @VM
*-------------------------------------------------------------------------------
    $INCLUDE I_COMMON ;*R22 Manual Conversion - START
    $INCLUDE I_EQUATE
    $INCLUDE I_GTS.COMMON

    $INCLUDE I_F.OFS.SOURCE
    $INCLUDE I_F.USER

    $INCLUDE I_T24.FS.COMMON
    $INCLUDE I_F.T24.FUND.SERVICES
    $INCLUDE I_F.TFS.PARAMETER
    $INCLUDE I_F.TFS.TRANSACTION

    $INCLUDE I_F.TELLER.ID ;*R22 Manual Conversion - END

    GOSUB INIT
    GOSUB PRELIM.CONDS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN
*-------------------------------------------------------------------------------
PROCESS:

    GOSUB TFS.PARAM.PRELIM.CHECK
    IF NOT(E) THEN
        TFS$MESSAGE = 'CHECK.RECORD'
*
        SAVE.COMI = COMI ; SAVE.AF = AF ; SAVE.AV = AV ; SAVE.E = E
        MAT TFS$R.TFS.TXN = ''
        IF R.NEW(TFS.TRANSACTION) THEN
            GOSUB CHECK.EXISTING.TRANSACTIONS
        END
        COMI = SAVE.COMI ; AF = SAVE.AF ; AV = SAVE.AV ; E = SAVE.E
*
        IF NOT(E) THEN
            E = SAVE.E
            BEGIN CASE
                CASE V$FUNCTION EQ 'I'
                    IF R.NEW(TFS.BOOKING.DATE) EQ '' THEN
                        GOSUB VALIDATIONS.I
                    END

                CASE V$FUNCTION MATCHES 'R' :@VM: 'D' ;*R22 Manual Conversion
                    GOSUB VALIDATIONS.R.D

                    ! 29 AUG 07 - Sathish PS /s
                CASE V$FUNCTION MATCHES 'A'
                    GOSUB VALIDATIONS.A
                    ! 29 AUG 07 - Sathish PS /e

                CASE V$FUNCTION EQ 'C'
                    GOSUB VALIDATIONS.C
            END CASE
        END
    END

RETURN
*-------------------------------------------------------------------------------
VALIDATIONS.I:

    R.NEW(TFS.BOOKING.DATE) = TODAY
* For a new record, Load the transaction codes as defined in TFS.PARAMETER
    LOAD.TRANSACTIONS = 0
    LOAD.TRANSACTIONS = NOT(GTSACTIVE) OR (GTSACTIVE AND OFS$SOURCE.REC<OFS.SRC.SOURCE.TYPE> EQ 'SESSION')
    IF LOAD.TRANSACTIONS AND TFS$R.TFS.PAR<TFS.PAR.DEF.TFS.TXNS> THEN
        CALL DISPLAY.MESSAGE('LOADING TRANS CODES',6)
        SAVE.COMI = COMI ; SAVE.AF = AF ; SAVE.AV = AV ; SAVE.E = E
        NO.OF.DEF.TFS.TXNS = DCOUNT(TFS$R.TFS.PAR<TFS.PAR.DEF.TFS.TXNS>,@VM) ;*R22 Manual Conversion
        AF = TFS.TRANSACTION
        NO.OF.TFS.TXNS = 0 ; TFS.TXNS = ''
        FOR AV = 1 TO NO.OF.DEF.TFS.TXNS
            COMI = TFS$R.TFS.PAR<TFS.PAR.DEF.TFS.TXNS,AV> ; E = ''
*            CALL T24.FS.CHECK.FIELDS
            APAP.TFS.t24FsCheckFields() ;*R22 Manual Conversion
            
            IF NOT(E) THEN
                TFS.TXNS<1,AV> = COMI
                NO.OF.TFS.TXNS += 1
            END
        NEXT AV
        FOR AF = LINE.FIELD.FIRST TO LINE.FIELD.LAST
            FOR AV = 1 TO NO.OF.TFS.TXNS
                INS '' BEFORE R.NEW(AF)<1,AV>
            NEXT AV
        NEXT AF
        R.NEW(TFS.TRANSACTION) = TFS.TXNS
        COMI = SAVE.COMI ; AF = SAVE.AF ; AV = SAVE.AV ; E = SAVE.E
        CALL DISPLAY.MESSAGE('',6)
    END

* 12 SEP 07 - Sathish PS /s
    IF R.NEW(TFS.NET.ENTRY) NE 'NO' THEN
        T(TFS.ACCOUNT.DR)<3> = 'NOINPUT'
        T(TFS.ACCOUNT.CR)<3> = 'NOINPUT'
    END ELSE
        T(TFS.ACCOUNT.DR)<3> = ''
        T(TFS.ACCOUNT.CR)<3> = ''
    END
* 12 SEP 07 - Sathish PS /e

RETURN
*-----------------------------------------------------------------------------------
VALIDATIONS.R.D:

    ALL.TXNS = R.NEW(TFS.TRANSACTION)
    NO.OF.TXNS = DCOUNT(ALL.TXNS,@VM)
    FOR XX = 1 TO NO.OF.TXNS
*        LIVE.ENTRY.EXISTS = R.NEW(TFS.UNDERLYING)<1,XX> AND NOT(R.NEW(TFS.R.UL.STATUS)<1,XX> MATCHES 'AUT' :VM: 'REVE')
*  PACS00094380 - Start
        LIVE.ENTRY.EXISTS = R.NEW(TFS.UNDERLYING)<1,XX> AND NOT(R.NEW(TFS.UL.STATUS)<1,XX> MATCHES 'AUT' :@VM: 'REVE')
*  PACS00094380 - End
        IF LIVE.ENTRY.EXISTS THEN
            E = 'EB-TFS.LIVE.ENTRIES.EXIST'
* TUT1160654 - Start
* BREAK
            RETURN
* TUT1160654 - End

        END
    NEXT XX

RETURN
*-----------------------------------------------------------------------------------
! 29 AUG 07 - Sathish PS /s
VALIDATIONS.A:

    ALL.TXNS = R.NEW(TFS.TRANSACTION)
    NO.OF.TXNS = DCOUNT(ALL.TXNS,@VM)
    FOR XX = 1 TO NO.OF.TXNS
        IF R.NEW(TFS.UNDERLYING)<1,XX> AND R.NEW(TFS.UNDERLYING)<1,XX>[1,2] EQ 'TT' THEN
            GOSUB CHECK.TELLER.ID
            IF NOT(TELLER.ID) THEN E = 'EB-TFS.TELLER.ID.MISSING' :@FM: OPERATOR
* TUT1160654 - Start
* BREAK
            RETURN
* TUT1160654 - End

        END
    NEXT XX

RETURN
*------------------------------------------------------------------------------------
CHECK.TELLER.ID:

    TU.ID = OPERATOR
    CALL F.READ(FN.TU,TU.ID,R.TU,F.TU,ERR.TU)
    LOOP
        REMOVE TELLER.ID FROM R.TU SETTING NEXT.ID.POS
    WHILE TELLER.ID : NEXT.ID.POS DO
        CALL F.READ(FN.TI,TELLER.ID,R.TI,F.TI,ERR.TI)
        IF R.TI THEN
            IF R.TI<TT.TID.STATUS> EQ 'OPEN' THEN
                CALL F.READ(FN.TI.NAU,TELLER.ID,R.TI.NAU,F.TI.NAU,ERR.TI.NAU)
                IF R.TI.NAU THEN
                    E = 'TT-UNAUTH.TEL.ID.EXISTS'
                END ELSE
* TUT1160654 - Start
* BREAK
					RETURN
* TUT1160654 - Start
                END
* END ELSE
*    CONTINUE
            END
        END ELSE
            E = 'EB-TFS.TELLER.ID.MISSING' :@FM: OPERATOR ;*R22 Manual Conversion
        END
    REPEAT

    IF E THEN TELLER.ID = ''

RETURN
! 29 AUG 07 - Sathish PS /e
*-----------------------------------------------------------------------
VALIDATIONS.C:

    NO.COPY.FIELDS = TFS.AMOUNT.LCY :@FM: TFS.CHG.CODE :@FM: TFS.CHG.CCY :@FM: TFS.CHG.AMT :@FM: TFS.CHG.AMT.LCY
    NO.COPY.FIELDS := @FM: TFS.CHQ.TYPE :@FM: TFS.CHEQUE.NUMBER
    NO.COPY.FIELDS := @FM: TFS.REVERSAL.MARK :@FM: TFS.UNDERLYING :@FM: TFS.UL.STATUS :@FM: TFS.UL.STMT.NO
    NO.COPY.FIELDS := @FM: TFS.UL.COMPANY :@FM: TFS.UL.CHARGE :@FM: TFS.UL.CHARGE.CCY
    NO.COPY.FIELDS := @FM: TFS.R.UNDERLYING :@FM: TFS.R.UL.STMT.NO :@FM: TFS.VAL.ERROR :@FM: TFS.RETRY
    NO.COPY.FIELDS := @FM: TFS.R.UL.STATUS :@FM: TFS.ACCOUNTING.STYLE :@FM: TFS.OVERRIDE

    LOOP
        REMOVE NO.COPY.FIELD FROM NO.COPY.FIELDS SETTING NEXT.SUCH.FIELD.POS
    WHILE NO.COPY.FIELD : NEXT.SUCH.FIELD.POS

        NO.OF.AVS = DCOUNT(R.NEW(NO.COPY.FIELD),@VM)
        IF NO.OF.AVS LT 1 THEN NO.OF.AVS = 1
        FOR AV.CNT = 1 TO NO.OF.AVS
            R.NEW(NO.COPY.FIELD)<1,AV.CNT> = ''
        NEXT AV.CNT
    REPEAT
    NO.COPY.FIELDS = NO.COPY.FIELDS

RETURN
*------------------------------------------------------------------------------------
TFS.PARAM.PRELIM.CHECK:

    LOOP.CNT = 1
    LOOP
    WHILE LOOP.CNT LE 6 AND NOT(E) DO

        BEGIN CASE
            CASE LOOP.CNT EQ 1
                IF NOT(TFS$R.TFS.PAR) THEN
                    E = 'EB-US.REC.MISS.FILE' :@FM: ID.COMPANY :@VM: FN.TFSP
                END

            CASE LOOP.CNT EQ 2
                IF TFS$R.TFS.PAR<TFS.PAR.OFS.SOURCE> EQ '' THEN
                    E = 'EB-TFS.OFS.SOURCE.NOT.IN.PARAM'
                END ELSE
                    TFS$OFS.SOURCE = TFS$R.TFS.PAR<TFS.PAR.OFS.SOURCE>
*-- 20100624 umar - start
                    CALL CACHE.READ(FN.OFSS,TFS$OFS.SOURCE,R.OFSS,ERR.OFSS)
*                CALL F.READ(FN.OFSS,TFS$OFS.SOURCE,R.OFSS,F.OFSS,ERR.OFSS)
*-- 20100624 umar - end
                    IF R.OFSS THEN
                        IF R.OFSS<OFS.SRC.SOURCE.TYPE> EQ 'GLOBUS' THEN
                            IF R.OFSS<OFS.SRC.FIELD.VAL> EQ 'YES' THEN
*                            E = 'EB-TFS.OFS.SRC.FLD.VAL.NOT.NULL.NO' :FM: TFS$OFS.SOURCE
                            END
                        END ELSE
                            E = 'AC-OFS.SRC.NOT.GLOBUS'
                        END
                    END
                END
 
            CASE LOOP.CNT EQ 3
                IF TFS$R.TFS.PAR<TFS.PAR.APPLICATION> EQ '' THEN
                    E = 'EB-TFS.APPLICATION.NOT.IN.PARAM'
                END

            CASE LOOP.CNT EQ 4
                IF TFS$R.TFS.PAR<TFS.PAR.OFS.VERSION> EQ '' THEN
                    E = 'EB-TFS.OFS.VERSION.NOT.IN.PARAM'
                END

            CASE LOOP.CNT EQ 5
* 03/24/05 - Sathish PS /s
                MAT T = MAT TFS$T
* 03/24/05 - Sathish PS /e

        END CASE

        LOOP.CNT += 1
    REPEAT

RETURN
*-------------------------------------------------------------------------------
CHECK.EXISTING.TRANSACTIONS:

    AF = TFS.TRANSACTION
    NO.OF.TXNS = DCOUNT(R.NEW(AF),@VM)
    FOR AV = 1 TO NO.OF.TXNS
        COMI = R.NEW(AF)<1,AV>
*        CALL T24.FS.CHECK.FIELDS
        APAP.TFS.t24FsCheckFields() ;*R22 Manual Conversion
        IF E AND INDEX('IACRD',V$FUNCTION,1) THEN
            CALL ERR
            V$ERROR = 1
* TUT1160653 and TUT1160654 - Start
* MESSAGE = 'REPEAT'
* BREAK
            RETURN
* TUT1160653 and TUT1160654 - End

        END
    NEXT AV

RETURN
*-------------------------------------------------------------------------------
*//////////////////////////////////////////////////////////////////////////////*
*////////////P R E  P R O C E S S  S U B R O U T I N E S //////////////////////*
*//////////////////////////////////////////////////////////////////////////////*
INIT:

    PROCESS.GOAHEAD = 1
    LINE.FIELD.FIRST = TFS$LINE.FIRST.FIELD
    LINE.FIELD.LAST = TFS$LINE.LAST.FIELD
    U.LANG = R.USER<EB.USE.LANGUAGE>

    FN.OFSS = 'F.OFS.SOURCE' ; F.OFSS = ''
    FN.TFSP = 'F.TFS.PARAMETER' ; F.TFSP = ''

    ! 29 AUG 07 - Sathish PS /s
    TELLER.ID = ''
    FN.TU = 'F.TELLER.USER' ; F.TU = ''
    FN.TI = 'F.TELLER.ID' ; F.TI = ''
    FN.TI.NAU = 'F.TELLER.ID$NAU' ; F.TI.NAU = ''
    ! 29 AUG 07 - Sathish PS /e

    IF MESSAGE EQ 'HLD' THEN PROCESS.GOAHEAD = 0  ;* 12 SEP 07 - Sathish PS s/e

RETURN
*-------------------------------------------------------------------------------
PRELIM.CONDS:

    IF NOT(PROCESS.GOAHEAD) THEN RETURN ;* 12 SEP 07 - Sathish PS s/e
    TFS$R.NEW = ''
    IF GTSACTIVE AND OFS$SOURCE.REC<OFS.SRC.SOURCE.TYPE> EQ 'SESSION' THEN
        GOSUB IMPORT.TFS.R.NEW
    END

RETURN
*-------------------------------------------------------------------------------
IMPORT.TFS.R.NEW:

    NO.OF.GTS.FIELDS = DCOUNT(R.GTS,@FM)
    FOR GTS.AF = 1 TO NO.OF.GTS.FIELDS

        AF = R.GTS<GTS.AF,3>
        GTS.AV = R.GTS<GTS.AF,4>
        GTS.AS = R.GTS<GTS.AF,5>
        IF NOT(GTS.AV) THEN GTS.AV = 1
        IF NOT(GTS.AS) THEN GTS.AS = 1
        AF.VALUE = R.GTS<GTS.AF,2>
        TFS$R.NEW<AF,GTS.AV,GTS.AS> = AF.VALUE

    NEXT GTS.AF

RETURN
*-------------------------------------------------------------------------------
END
