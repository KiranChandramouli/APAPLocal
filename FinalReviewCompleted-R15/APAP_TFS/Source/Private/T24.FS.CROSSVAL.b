* @ValidationCode : MjoxNTgyNTA5OTE3OkNwMTI1MjoxNjk4NzUwNjczMTIzOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
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
* Version 2 02/06/00  GLOBUS Release No. G14.0.00 03/07/03
*-----------------------------------------------------------------------------
* <Rating>1438</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE T24.FS.CROSSVAL
*-----------------------------------------------------------------------
* Crossval subroutine for T24.FUND.SERVICES template
*
*-----------------------------------------------------------------------
* Modification history:
*
* 09/07/04 - Sathish PS
*            New Development
*
* 05/12/05 - Sathish PS
*            Delete Multivalues if Amount, Cr A/C & Dr A/C are not Entered.
*
* 09/02/05 - GP
*            Changed IF condition to accomodate the condition where END.ERROR
*            will have the value 'BROWSER.VALIDATE' when validate button is pressed
*            from browser
*
* 11 OCT 06 - Sathish PS
*             Cash Back Validations
*
* 29 AUG 07 - Sathish PS
*             Exposure Split Validations
*
* 04 SEP 07 - Sathish PS
*             Dont clear exposure fields. logic moved to T24.FS.INTERFACE.TT.
*
* 12 SEP 07 - Sathish PS
*             Cross-validate the Net Entry amount against individual amounts
*             and also if Net Entry account is the same as Primary Account.
*
* 13 SEP 07 - Sathish PS
*              Net Entry Mis-match was happening inappropriately.
*
* Mar 17 2008 - Code amended since it was not allowing REVERSALS.
*
* 08/01/08 - Geetha Balaji
*            CHNG080108 - The changes done in this fix have been linked to this code for easy retrieval.
*            Reversal checks done inside CHECK.FOR.AMENDMENTS gosub did not work.
*            R.OLD and R.NEW values should be checked taking into consideration the
*            possibility of VMs and SMs in each empty multivalue field.
*            Also, stored values of AMOUNT.LCY (R.OLD) did not have trailing decimal
*            zeroes whereas R.NEW did.
*
*
* 23/03/2009-Anitha.S
*            HD0904143 -if DENOM.REQD=1 then the STOCK.CONTROL.TYPE should be checked only
*            for the account which has STOCK.CONTROL.TYPE field is set to DENOM.
*            the error case for STOCK.CONTROL.TYPE EQ '' is been commented.
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*26/10/2023         Suresh             R22 Manual Conversion           GLOBUS.BP File Removed,USPLATFORM.BP  File Removed, CALL routine format modified, VM TO @VM, SM TO @SM
*-----------------------------------------------------------------------
    $INCLUDE I_COMMON ;*R22 Manual Conversion - START
    $INCLUDE I_EQUATE
    $INCLUDE I_GTS.COMMON ;*R22 Manual Conversion - END
    $INCLUDE I_T24.FS.COMMON ;*R22 Manual Conversion - START

    $INCLUDE I_F.TFS.PARAMETER 
    $INCLUDE I_F.TFS.TRANSACTION
    $INCLUDE I_F.T24.FUND.SERVICES

    $INCLUDE I_F.TELLER.PARAMETER
    $INCLUDE I_F.ACCOUNT ;*R22 Manual Conversion - END
*
*-----------------------------------------------------------------------
*
*
*-----------------------------------------------------------------------
*
    GOSUB INITIALISE
    GOSUB CLEAN.UP.TFS.LINES
    GOSUB CHECK.FOR.AMENDMENTS
    IF NOT(END.ERROR) OR END.ERROR EQ 'BROWSER.VALIDATE' THEN         ;*09/02/05 GP s/e
        GOSUB REPEAT.CHECK.FIELDS
        GOSUB REAL.CROSSVAL
    END
*
RETURN
*
*-----------------------------------------------------------------------
*
REAL.CROSSVAL:
*
* Real cross validation goes here....
*
    ALL.TXNS = R.NEW(TFS.TRANSACTION)
    NO.OF.TXNS = DCOUNT(ALL.TXNS,@VM)
    CHECK.ENTRY.NETTING = 0   ;* 04 SEP 07 - Sathish PS s/e
    FOR XX = 1 TO NO.OF.TXNS
        IF TFS$R.TFS.TXN(XX)<TFS.TXN.INTERFACE.TO> EQ 'TT' THEN
            AMOUNT = R.NEW(TFS.AMOUNT)<1,XX>
            AC.NO = R.NEW(TFS.ACCOUNT.CR)<1,XX> ; GOSUB CHECK.DENOM.REQD
            IF DENOM.REQD THEN
                ALL.DENOMS = R.NEW(TFS.CR.DENOM)<1,XX>
                ALL.UNITS = R.NEW(TFS.CR.DEN.UNIT)<1,XX>
                IF ALL.DENOMS THEN
                    DENOM.FIELD = TFS.CR.DENOM ; DENOM.UNIT.FIELD = TFS.CR.DEN.UNIT
                    GOSUB RECONCILE.DENOM
                END
            END
            AC.NO = R.NEW(TFS.ACCOUNT.DR)<1,XX> ; GOSUB CHECK.DENOM.REQD
            IF DENOM.REQD THEN
                ALL.DENOMS = R.NEW(TFS.DR.DENOM)<1,XX>
                ALL.UNITS = R.NEW(TFS.DR.DEN.UNIT)<1,XX>
                IF ALL.DENOMS THEN
                    DENOM.FIELD = TFS.DR.DENOM ; DENOM.UNIT.FIELD = TFS.DR.DEN.UNIT
                    GOSUB RECONCILE.DENOM
                END
            END
        END
* 11 OCT 06 - Sathish PS /s
* Also start adding Cash Back amounts
        GOSUB AGGREGATE.CASH.BACK
        GOSUB CHECK.EXPOSURE.SPLITS     ;* 29 AUG 07 - Sathish PS s/e
        GOSUB CHECK.NET.ENTRY ;* 12 SEP 07 - Sathish PS s/e
    NEXT XX

    IF TOTAL.CASH.BACK.LINE.AMOUNTS NE 0 THEN
        ETEXT = 'EB-TFS.CASH.BACK.MISMATCH'
        CALL STORE.END.ERROR
    END
* 11 OCT 06 - Sathish PS /e

    IF NET.CCY.VAL.ARR OR CCY.VAL.ARR THEN
        LOCATE 'YES' IN R.NEW(TFS.NETTED.ENTRY)<1,1> SETTING NET.ENTRY.POS THEN ;* 13 SEP 07 - Sathish PS s/e
            GOSUB VALIDATE.CCY.VAL.ARR  ;* 12 SEP 07 - Sathish PS s/e
        END         ;* 13 SEP 07 - Sathish PS s/e
    END

RETURN          ;*From real crossval
*----------------------------------------------------------------------------------
RECONCILE.DENOM:
    LOCATE R.NEW(TFS.CURRENCY)<1,XX> IN TFS$TT.DENOM.CCY<1> SETTING CCY.POS THEN
        CCY.DENOM = TFS$TT.DENOM(CCY.POS)
    END
*
    DENOM.TOTAL = 0
    LOOP
        REMOVE DENOM FROM ALL.DENOMS SETTING NEXT.DENOM.POS
        REMOVE DENOM.UNIT FROM ALL.UNITS SETTING NEXT.UNIT.POS
    WHILE DENOM : NEXT.DENOM.POS DO

        LOCATE DENOM IN CCY.DENOM<1,1> SETTING CCY.DENOM.POS THEN
            DENOM.VALUE = CCY.DENOM<2,CCY.DENOM.POS>
            DENOM.TOTAL += DENOM.UNIT * DENOM.VALUE
        END

    REPEAT
    IF DENOM.TOTAL NE AMOUNT THEN
        ETEXT = 'EB-TFS.DENOM.NE.TXN.AMOUNT'
        AF = DENOM.UNIT.FIELD ; AV = XX ; AS = 1 ; CALL STORE.END.ERROR
    END

RETURN
*--------------------------------------------------------------------------------------
CHECK.DENOM.REQD:

    DENOM.REQD = 0 ; SERIAL.REQD = 0
    CALL F.READ(FN.AC,AC.NO,R.AC,F.AC,ERR.AC)
    IF ERR.AC THEN
    END ELSE
        IF R.AC<AC.CATEGORY> AND R.AC<AC.CUSTOMER> EQ '' THEN
            AC.CATEG = R.AC<AC.CATEGORY>
            LOCATE AC.CATEG IN R.TTP<TT.PAR.TRAN.CATEGORY,1> SETTING CASH.POS THEN
                DENOM.REQD = 1
            END
        END
        IF DENOM.REQD THEN
        END
    END
*23/03/2009 S
*   IF DENOM.REQD THEN
*       IF NOT(TFS$TT.DENOM.CCY) THEN
*           ETEXT = 'EB-TFS.DENOM.DATA.NOT.AVAILABLE'
*       END ELSE
    BEGIN CASE
*            CASE R.AC<AC.STOCK.CONTROL.TYPE> EQ ''
*                ETEXT = 'EB-TFS.CONTROL.TYPE.NOT.DEFINED'
        CASE R.AC<AC.STOCK.CONTROL.TYPE> EQ 'DENOM'
            IF NOT(TFS$TT.DENOM.CCY) THEN   ;*ADDED 23/03/2009
                ETEXT = 'EB-TFS.DENOM.DATA.NOT.AVAILABLE'       ;*ADDED 23/03/2009
            END
        CASE R.AC<AC.STOCK.CONTROL.TYPE> EQ 'SERIAL'
    END CASE
*END
*END
*23/03/09 E

    IF ETEXT THEN CALL STORE.END.ERROR

RETURN
*--------------------------------------------------------------------------------------------------------------------------

CLEAN.UP.TFS.LINES:

    MAT MY.R.NEW = MAT R.NEW

    NO.OF.TXNS = DCOUNT(R.NEW(TFS.TRANSACTION),@VM)
    FOR XX = NO.OF.TXNS TO 1 STEP -1
        IF R.NEW(TFS.ACCOUNT.DR)<1,XX> EQ '' AND R.NEW(TFS.ACCOUNT.CR)<1,XX> EQ '' AND R.NEW(TFS.AMOUNT)<1,XX> EQ '' AND R.NEW(TFS.IMPORT.UL)<1,XX> EQ '' THEN
            FOR FCNT = LINE.FIRST.FIELD TO LINE.LAST.FIELD
                DEL MY.R.NEW(FCNT)<1,XX>
            NEXT FCNT
        END
    NEXT XX

    MAT R.NEW = MAT MY.R.NEW
    IF NOT(GTSACTIVE) THEN CALL REBUILD.SCREEN

RETURN
*-----------------------------------------------------------------------
CHECK.FOR.AMENDMENTS:

    IF NOT(R.OLD(TFS.BOOKING.DATE)) THEN RETURN

    FOR AF = 1 TO V-9

        IF AF MATCHES TFS.REVERSAL.MARK :@VM: TFS.RETRY :@VM: TFS.IMPORT.UL :@VM:TFS.CREATE.NET.ENTRY THEN CONTINUE        ;* Mar 17 2008 s/e
        IF T(AF)<3> MATCHES 'NOINPUT' :@VM: 'NOCHANGE' THEN CONTINUE ;*R22 Manual Conversion

        IF R.NEW(AF) NE R.OLD(AF) THEN
* CHNG080108 S
* There might be multiple txns in a single TFS, hence if the complete string doesn't match
* try converting the VMs & SMs and check again.

            Y.OLD = '' ; Y.NEW = ''
            Y.OLD = R.OLD(AF);Y.NEW = R.NEW(AF)

            CONVERT @VM TO '' IN Y.OLD
            CONVERT @VM TO '' IN Y.NEW
            CONVERT @SM TO '' IN Y.OLD
            CONVERT @SM TO '' IN Y.NEW ;*R22 Manual Conversion

* The foll. is a string check even for Amount fields.
            IF Y.OLD NE Y.NEW THEN

                IF AF EQ TFS.AMOUNT.LCY THEN

* For Amount.Lcy, though we convert VMs and SMs there will be difference between
* 100]100.00 & 100.00]100.00 as they are checked as a string. Hence the foll. check needs to be done.

                    Y.OLD = R.OLD(AF);Y.NEW = R.NEW(AF)
                    Y.CNT = DCOUNT(Y.OLD,@VM)
                    Y.COUNTER = 1

                    LOOP
                    WHILE Y.COUNTER LE Y.CNT
                        Y.OLD.1 = Y.OLD<1,Y.COUNTER>
                        Y.NEW.1 = Y.NEW<1,Y.COUNTER>
* The foll. becomes a numeric check
                        IF Y.OLD.1 NE Y.NEW.1 THEN
                            ETEXT = 'EB-TFS.CANNOT.CHANGE.AUTHORISED.LINE'
                            AV = Y.COUNTER
                            CALL STORE.END.ERROR
                        END
                        Y.COUNTER += 1
                    REPEAT
                END ELSE
                    ETEXT = 'EB-TFS.CANNOT.CHANGE.AUTHORISED.LINE'
                    AV = 1 ; AS = 1
                    CALL STORE.END.ERROR
                END
            END     ;* CHNG080108 E
        END
    NEXT AF

RETURN
* 03/24/05 - Sathish PS s/e

*------------------------------------------------------------------------
* 11 OCT 06 - Sathish PS /s
AGGREGATE.CASH.BACK:

    IF R.NEW(TFS.CASH.BACK.TXN) EQ 'YES' THEN
        LINE.AMOUNT = R.NEW(TFS.AMOUNT)<1,XX>
        IF R.NEW(TFS.CASH.BACK.DIR)<1,XX> EQ 'OUT' THEN
            LINE.AMOUNT = -LINE.AMOUNT
        END
        TOTAL.CASH.BACK.LINE.AMOUNTS += LINE.AMOUNT
    END

RETURN
* 11 OCT 06 - Sathish PS /e
*-------------------------------------------------------------------------
* 29 AUG 07 - Sathish PS /s
CHECK.EXPOSURE.SPLITS:

    IF R.NEW(TFS.EXP.SCHEDULE)<1,XX> THEN
        IF TFS$R.TFS.PAR<TFS.PAR.TFS.EXPOSURE> EQ 'NATIVE' THEN
            IF R.NEW(TFS.NET.ENTRY) NE 'NO' THEN  ;* If entries are to be netted then
                IF R.NEW(TFS.NETTED.ENTRY)<1,XX> NE 'YES' THEN        ;* if this line is not a Net Entry then
                    IF NOT(END.ERROR) THEN        ;* Dont clear it up during VALIDATE stage.
                        ! 04 SEP 07 - Sathish PS /s
                        !                        R.NEW(TFS.EXP.SCHEDULE)<1,XX> = ''
                        !                        R.NEW(TFS.EXP.DATE)<1,XX> = ''
                        !                        R.NEW(TFS.EXP.AMT)<1,XX> = ''
                        ! 04 SEP 07 - Sathish PS /e
                    END
                END
            END
            IF R.NEW(TFS.EXP.AMT)<1,XX> THEN
                IF SUM(R.NEW(TFS.EXP.AMT)<1,XX>) NE R.NEW(TFS.AMOUNT)<1,XX> THEN
                    E = 'EB-TFS.EXP.SPLIT.NE.LINE.AMOUNT'
                END
            END
        END
    END

RETURN
* 29 AUG 07 - Sathish PS /e
*-------------------------------------------------------------------------
! 12 SEP 07 - Sathish PS /s
CHECK.NET.ENTRY:
    IF R.NEW(TFS.NET.ENTRY) NE 'NO' THEN          ;* If entries are to be netted then
        ENTRY.CCY = R.NEW(TFS.CURRENCY)<1,XX>
        IF R.NEW(TFS.NETTED.ENTRY)<1,XX> EQ 'YES' THEN      ;* if this line is not a Net Entry then
            ! First, Check Primary Account
            BEGIN CASE
                CASE R.NEW(TFS.ACCOUNT.DR)<1,XX> EQ R.NEW(TFS.PRIMARY.ACCOUNT)
                    ENTRY.VAL.DATE = R.NEW(TFS.DR.VALUE.DATE)<1,XX>
                    ENTRY.AMT = -R.NEW(TFS.AMOUNT)<1,XX>

                CASE R.NEW(TFS.ACCOUNT.CR)<1,XX> EQ R.NEW(TFS.PRIMARY.ACCOUNT)
                    ENTRY.VAL.DATE = R.NEW(TFS.CR.VALUE.DATE)<1,XX>
                    ENTRY.AMT = R.NEW(TFS.AMOUNT)<1,XX>

                CASE OTHERWISE
                    ETEXT = 'EB-TFS.NET.ENTRY.ACCOUNT.NOT.PRIMARY.ACCOUNT'
                    AF = TFS.PRIMARY.ACCOUNT
                    CALL STORE.END.ERROR
            END CASE
            IF NOT(END.ERROR) THEN
                GOSUB ADD.TO.NET.ENTRY.ARRAY
            END
        END ELSE
            ENTRY.VAL.DATE = ''
            BEGIN CASE
                CASE R.NEW(TFS.ACCOUNT.DR)<1,XX>[4,5] EQ NET.ENTRY.WTHRU.CATEG
                    ENTRY.VAL.DATE = R.NEW(TFS.DR.VALUE.DATE)<1,XX>
                    ENTRY.AMT = -R.NEW(TFS.AMOUNT)<1,XX>

                CASE R.NEW(TFS.ACCOUNT.CR)<1,XX>[4,5] EQ NET.ENTRY.WTHRU.CATEG
                    ENTRY.VAL.DATE = R.NEW(TFS.CR.VALUE.DATE)<1,XX>
                    ENTRY.AMT = R.NEW(TFS.AMOUNT)<1,XX>

                CASE OTHERWISE
            END CASE
            IF ENTRY.VAL.DATE THEN
                GOSUB ADD.TO.ENTRY.ARRAY
            END
        END
    END

RETURN
*--------------------------------------------------------------------------------
ADD.TO.NET.ENTRY.ARRAY:
    CCY.VAL = ENTRY.CCY : ENTRY.VAL.DATE
    LOCATE CCY.VAL IN NET.CCY.VAL.ARR<1,1> SETTING CCY.VAL.POS THEN
        NET.CCY.VAL.ARR<2,CCY.VAL.POS> += ENTRY.AMT
    END ELSE
        NET.CCY.VAL.ARR<1,-1> = CCY.VAL
        NET.CCY.VAL.ARR<2,-1> = ENTRY.AMT
    END

RETURN
*--------------------------------------------------------------------------------
ADD.TO.ENTRY.ARRAY:

    CCY.VAL = ENTRY.CCY : ENTRY.VAL.DATE
    LOCATE CCY.VAL IN CCY.VAL.ARR<1,1> SETTING CCY.VAL.POS THEN
        CCY.VAL.ARR<2,CCY.VAL.POS> += ENTRY.AMT
    END ELSE
        CCY.VAL.ARR<1,-1> = CCY.VAL
        CCY.VAL.ARR<2,-1> = ENTRY.AMT
    END

RETURN
*--------------------------------------------------------------------------------
VALIDATE.CCY.VAL.ARR:
    NO.OF.CCY.VALS = DCOUNT(CCY.VAL.ARR<1>,@VM)
    FOR CCY.VAL.CNT = 1 TO NO.OF.CCY.VALS

        CCY.VAL = CCY.VAL.ARR<1,CCY.VAL.CNT>
        ENTRY.AMT = CCY.VAL.ARR<2,CCY.VAL.CNT>
        LOCATE CCY.VAL IN NET.CCY.VAL.ARR<1,1> SETTING NET.CCY.VAL.POS THEN
            IF ABS(ENTRY.AMT) NE ABS(NET.CCY.VAL.ARR<2,NET.CCY.VAL.POS>) THEN
*  ETEXT = 'EB-TFS.NET.ENTRY.NOT.BALANCED' ; * TESTING /S
*  AF = TFS.NET.ENTRY
*  CALL STORE.END.ERROR
            END
        END ELSE
* ETEXT = 'EB-TFS.NET.ENTRY.NOT.BALANCED'
* AF = TFS.NET.ENTRY
* CALL STORE.END.ERROR ; * TESTING /E
        END

    NEXT CCY.VAL.CNT

RETURN
! 12 SEP 07 - Sathish PS /e
*-----------------------------------------------------------------------------
REPEAT.CHECK.FIELDS:
*
* Loop through each field and repeat the check field processing if there is any defined
*

    FOR AF = 1 TO V-9
        IF INDEX(N(AF), "C", 1) THEN
*
* Is it a sub value, a multi value or just a field
*
            BEGIN CASE
                CASE F(AF)[4,2] = 'XX'      ;* Sv
                    NO.OF.AV = DCOUNT(R.NEW(AF), @VM)
                    IF NO.OF.AV = 0 THEN NO.OF.AV = 1
                    FOR AV = 1 TO NO.OF.AV
                        NO.OF.SV = DCOUNT(R.NEW(AF)<1,AV>, @SM)
                        IF NO.OF.SV = 0 THEN NO.OF.SV = 1
                        FOR AS = 1 TO NO.OF.SV
                            GOSUB DO.CHECK.FIELD
                        NEXT AS
                    NEXT AV
                CASE F(AF)[1,2] = 'XX'      ;* Mv
                    AS = ''
                    NO.OF.AV = DCOUNT(R.NEW(AF), @VM)
                    IF NO.OF.AV = 0 THEN NO.OF.AV = 1
                    FOR AV = 1 TO NO.OF.AV
                        GOSUB DO.CHECK.FIELD
                    NEXT AV
                CASE OTHERWISE
                    AV = '' ; AS = ''
                    GOSUB DO.CHECK.FIELD
            END CASE
        END
    NEXT AF
RETURN
*
*-----------------------------------------------------------------------
*
DO.CHECK.FIELD:
** Repeat the check field validation - errors are returned in the
** variable E.
*
    COMI.ENRI = ""
    BEGIN CASE
        CASE AS
            COMI = R.NEW(AF)<1,AV,AS>
        CASE AV
            COMI = R.NEW(AF)<1,AV>
        CASE AF
            COMI = R.NEW(AF)
    END CASE
*
*    CALL T24.FS.CHECK.FIELDS
    APAP.TFS.t24FsCheckFields() ;*R22 Manual Conversion
    IF E THEN
        ETEXT = E
        CALL STORE.END.ERROR
    END ELSE
        BEGIN CASE
            CASE AS
                R.NEW(AF)<1,AV,AS> = COMI
                YENRI.FLD = AF:".":AV:".":AS ; YENRI = COMI.ENRI
                GOSUB SET.UP.ENRI
            CASE AV
                R.NEW(AF)<1,AV> = COMI
                YENRI.FLD = AF:".":AV ; YENRI = COMI.ENRI
                GOSUB SET.UP.ENRI
            CASE AF
                R.NEW(AF) = COMI
                YENRI.FLD = AF ; YENRI = COMI.ENRI
                GOSUB SET.UP.ENRI
        END CASE
    END

RETURN
*
*-----------------------------------------------------------------------
*
SET.UP.ENRI:
*
    IF UNASSIGNED(YENRI) THEN YENRI = ''

    LOCATE YENRI.FLD IN T.FIELDNO<1> SETTING YPOS THEN
        T.ENRI<YPOS> = YENRI
    END
RETURN
*
*-----------------------------------------------------------------------
*
INITIALISE:
*
    YENRI = ''

    LINE.FIRST.FIELD = TFS$LINE.FIRST.FIELD
    LINE.LAST.FIELD = TFS$LINE.LAST.FIELD

    DIM MY.R.NEW(C$SYSDIM)
    MAT MY.R.NEW = ''

    FN.TTP = 'F.TELLER.PARAMETER' ; F.TTP = '' ; CALL OPF(FN.TTP,F.TTP)

    FN.AC = 'F.ACCOUNT' ; F.AC = '' ; CALL OPF(FN.AC,F.AC)
    ID.TTP = ID.COMPANY
    CALL CACHE.READ(FN.TTP,ID.TTP,R.TTP,ERR.TTP)
 
    TOTAL.CASH.BACK.LINE.AMOUNTS = 0    ;* 11 OCT 06 - Sathish PS s/e

* 12 SEP 07 - Sathish PS /s
    NET.ENTRY.WTHRU.CATEG = TFS$R.TFS.PAR<TFS.PAR.NET.ENTRY.WASHTHRU>
    CCY.VAL.ARR = '' ; NET.CCY.VAL.ARR = ''
* 12 SEP 07 - Sathish PS /e
 
RETURN
*
*-----------------------------------------------------------------------
*
END



