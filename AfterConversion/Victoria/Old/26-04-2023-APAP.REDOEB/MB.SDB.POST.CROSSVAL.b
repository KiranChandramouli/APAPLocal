* @ValidationCode : MjoxMTk4ODg4MTg2OkNwMTI1MjoxNjgxOTc5NTk2MzEzOklUU1M6LTE6LTE6MTU1NDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 20 Apr 2023 14:03:16
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1554
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOEB
SUBROUTINE MB.SDB.POST.CROSSVAL
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-APR-2023     Conversion tool   R22 Auto conversion   	VM to @VM, SM to @SM, = to EQ
* 13-APR-2023      Harishvikram C   Manual R22 conversion   CALL routine format modified
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.MB.SDB.POST
    $INSERT I_F.MB.SDB.STATUS

    GOSUB INITIALISE
    GOSUB REAL.CROSSVAL

RETURN

************************************************************************
REAL.CROSSVAL:

    MB.SDB.STATUS.ID = R.NEW(SDB.POST.SDB.COMPANY):'.':R.NEW(SDB.POST.SDB.NUMBER)
* CALL APAP.REDOEB.MB.SDB.READ.SDB.STATUS(MB.SDB.STATUS.ID,R.MB.SDB.STATUS) ;*Manual R22 conversion
    CALL APAP.REDOEB.mbSdbReadSdbStatus(MB.SDB.STATUS.ID,R.MB.SDB.STATUS);
    IF R.MB.SDB.STATUS<SDB.STA.STATUS> NE 'AVAILABLE' AND R.MB.SDB.STATUS<SDB.STA.STATUS> NE 'RESERVED' THEN
        SDB.STATUS = '1'
    END ELSE
        SDB.STATUS = '0'
    END

    SDB.OPERATE = R.NEW(SDB.POST.SDB.OPERATE)

    IF NOT(R.NEW(SDB.POST.SDB.COMPANY)) THEN
        AF = SDB.POST.SDB.COMPANY
        ETEXT = 'Branch Code mandatory to open a safe box'
        CALL STORE.END.ERROR
        RETURN
    END

    BEGIN CASE

        CASE NOT(SDB.STATUS) AND (SDB.OPERATE MATCHES 'VISIT':@VM:'CLOSE')
            AF = SDB.POST.SDB.OPERATE
            ETEXT = 'Safe Box not in use. This operation is not allowed'
            CALL STORE.END.ERROR
            RETURN

        CASE SDB.OPERATE EQ 'OPEN'
            IF NOT(R.NEW(SDB.POST.CUSTOMER.NO)) THEN
                AF = SDB.POST.CUSTOMER.NO
                ETEXT = 'Customer mandatory to open a safe box'
                CALL STORE.END.ERROR
                RETURN
            END

            IF NOT(R.NEW(SDB.POST.CUSTOMER.ACCT)) THEN
                AF = SDB.POST.CUSTOMER.ACCT
                ETEXT = 'Account number mandatory to open a safe box'
                CALL STORE.END.ERROR
                RETURN
            END

            IF R.MB.SDB.STATUS<SDB.STA.STATUS> EQ 'RESERVED' THEN
*TEXT = 'The Safe box selected is reserved. Do you want to proceed?'
                TEXT = 'CP.SDB.REPAIR'
                CURR.NO = ''
                CALL STORE.OVERRIDE(CURR.NO)
                IF TEXT[1,1] EQ 'N' THEN
                    AF = SDB.POST.SDB.NUMBER
                    ETEXT = 'Safe box is reserved'
                    CALL STORE.END.ERROR
                    RETURN
                END
            END

            IF R.MB.SDB.STATUS<SDB.STA.STATUS> EQ 'REPAIR' THEN
* TEXT = 'The Safe box selected is under repair. Do you want to proceed?'
                TEXT = 'CP.SDB.REPAIR'
                CURR.NO = ''
                CALL STORE.OVERRIDE(CURR.NO)
                IF TEXT[1,1] EQ 'N' THEN
                    AF = SDB.POST.SDB.NUMBER
                    ETEXT = 'Safe box is reserved'
                    CALL STORE.END.ERROR
                    RETURN
                END
            END

            IF R.MB.SDB.STATUS<SDB.STA.STATUS> EQ 'RENTED' THEN
                AF = SDB.POST.SDB.NUMBER
                ETEXT = 'Safe Box is already allocated'
                CALL STORE.END.ERROR
                RETURN
            END

        CASE SDB.OPERATE EQ 'RESERVE'
            IF R.NEW(SDB.POST.NOTES) EQ '' THEN
                AF = SDB.POST.NOTES
                ETEXT = 'Reserve Notes mandatory for RESERVE operation'
                CALL STORE.END.ERROR
                RETURN
            END

            IF R.MB.SDB.STATUS<SDB.STA.STATUS> NE 'AVAILABLE' THEN
                AF = SDB.POST.SDB.OPERATE
                ETEXT = 'Safe box is not available. RESERVE is not allowed'
                CALL STORE.END.ERROR
                RETURN
            END

        CASE SDB.OPERATE EQ 'MAINTAIN'

*        IF R.MB.SDB.STATUS<SDB.STA.STATUS> NE 'AVAILABLE' THEN
*            AF = SDB.POST.SDB.OPERATE
*            ETEXT = 'Safe box is not available. Make under repair is not allowed'
*            CALL STORE.END.ERROR
*            RETURN
*        END

            IF R.NEW(SDB.POST.MAINT.ACTION) EQ '' AND R.MB.SDB.STATUS<SDB.STA.MAINT.ACTION> EQ '' THEN
                AF = SDB.POST.MAINT.ACTION
                ETEXT = 'Maintenance Action Code is mandatory'
                CALL STORE.END.ERROR
                RETURN
            END

*        IF R.NEW(SDB.POST.NOTES) EQ '' THEN
*            AF = SDB.POST.NOTES
*            ETEXT = 'Maintenance Notes are mandatory for MAINTAIN operation'
*            CALL STORE.END.ERROR
*            RETURN
*        END

        CASE SDB.OPERATE = 'MODIFY'

*       IF R.MB.SDB.STATUS<SDB.STA.STATUS> EQ 'RESERVED' THEN
*           AF = SDB.POST.SDB.OPERATE
*           ETEXT = 'Safe box is reserved. MODIFY is not allowed'
*           CALL STORE.END.ERROR
*           RETURN
*       END

*       IF R.MB.SDB.STATUS<SDB.STA.STATUS> EQ 'REPAIR' THEN
*           AF = SDB.POST.SDB.OPERATE
*           ETEXT = 'Safe box is under repair. MODIFY is not allowed'
*           CALL STORE.END.ERROR
*           RETURN
*       END

            IF R.NEW(SDB.POST.CUSTOMER.NO) NE R.MB.SDB.STATUS<SDB.STA.CUSTOMER.NO> THEN
                AF = SDB.POST.CUSTOMER.NO
                ETEXT = 'Cannot change customer. Need to close box first'
                CALL STORE.END.ERROR
                RETURN
            END

        CASE SDB.OPERATE = 'VISIT'

            IF SDB.STATUS THEN
*          IF R.MB.SDB.STATUS<SDB.STA.STATUS> EQ 'RESERVED' THEN
*              AF = SDB.POST.SDB.OPERATE
*              ETEXT = 'Safe box is reserved. Access Not allowed'
*              CALL STORE.END.ERROR
*              RETURN
*          END

*          IF R.MB.SDB.STATUS<SDB.STA.STATUS> EQ 'REPAIR' THEN
*              AF = SDB.POST.SDB.OPERATE
*              ETEXT = 'Safe box is under repair. Access Not allowed'
*              CALL STORE.END.ERROR
*              RETURN
*          END

                IF R.NEW(SDB.POST.ACCESS.NAME) EQ '' THEN
                    AF = SDB.POST.ACCESS.NAME
                    ETEXT = 'Enter Name of the visitor'
                    CALL STORE.END.ERROR
                    RETURN
                END

                IF R.NEW(SDB.POST.ACCESS.DATE) EQ '' THEN
                    AF = SDB.POST.ACCESS.DATE
                    ETEXT = 'Enter date of visit'
                    CALL STORE.END.ERROR
                    RETURN
                END

            END ELSE
                AF = SDB.POST.SDB.OPERATE
                ETEXT = 'Box not in use. VISIT not allowed'
                CALL STORE.END.ERROR
                RETURN
            END

        CASE SDB.OPERATE = 'CLOSE'
            IF SDB.STATUS THEN
                IF R.MB.SDB.STATUS<SDB.STA.STATUS> EQ 'RESERVED' THEN
                    AF = SDB.POST.SDB.OPERATE
                    TEXT = 'Safe box is reserved. Do you want to cancel it?'
                    CURR.NO = ''
                    CALL STORE.OVERRIDE(CURR.NO)
                    IF TEXT[1,1] EQ 'N' THEN
                        AF = SDB.POST.REFUND.METHOD
                        ETEXT = 'User aborted transaction'
                        CALL STORE.END.ERROR
                        RETURN
                    END
                END

                IF R.MB.SDB.STATUS<SDB.STA.STATUS> EQ 'REPAIR' THEN
                    AF = SDB.POST.SDB.OPERATE
                    TEXT = 'Safe box is under repair. Do you want to make it available?'
                    CURR.NO = ''
                    CALL STORE.OVERRIDE(CURR.NO)
                    IF TEXT[1,1] EQ 'N' THEN
                        AF = SDB.POST.REFUND.METHOD
                        ETEXT = 'User aborted transaction'
                        CALL STORE.END.ERROR
                        RETURN
                    END
                END

            END

            IF R.MB.SDB.STATUS<SDB.STA.STATUS> NE 'RESERVED' AND R.MB.SDB.STATUS<SDB.STA.STATUS> NE 'REPAIR' THEN
                IF R.MB.SDB.STATUS<SDB.STA.RENEWAL.DUE.ON> LT TODAY THEN
                    AF = SDB.POST.SDB.NUMBER
*    TEXT = 'Rents has not been paid. Do you want to close the safe box?'
                    TEXT = 'Past rent is overdue. Do you want to close the SDB?'
                    CURR.NO = ''
                    CALL STORE.OVERRIDE(CURR.NO)
                    IF TEXT[1,1] EQ 'N' THEN
                        AF = SDB.POST.SDB.OPERATE
                        ETEXT = 'Rents has not been paid. User aborted transaction'
                        CALL STORE.END.ERROR
                        RETURN
                    END
                    RETURN
                END
                IF NOT(R.NEW(SDB.POST.REFUND.METHOD)) THEN
                    AF = SDB.POST.REFUND.METHOD
                    ETEXT = 'Field is mandatory for CLOSE operation'
                    CALL STORE.END.ERROR
                    RETURN
                END

                IF  V$FUNCTION EQ 'I' THEN
                    IF R.NEW(SDB.POST.REFUND.METHOD) EQ 'MANUAL' THEN
*TEXT = 'Manual refund selected. Refund will not be done by system'
                        TEXT = 'CP.MANUAL.REFUND.SEL'
                        CURR.NO = ''
                        CALL STORE.OVERRIDE(CURR.NO)
                        IF TEXT[1,1] EQ 'N' THEN
                            AF = SDB.POST.REFUND.METHOD
                            ETEXT = 'User aborted transaction'
                            CALL STORE.END.ERROR
                            RETURN
                        END
                    END
                END
            END
    END CASE

RETURN

************************************************************************
REPEAT.CHECK.FIELDS:

    FOR AF = 1 TO SDB.POST.RECORD.STATUS
        IF INDEX(N(AF), "C", 1) THEN
            BEGIN CASE
                CASE F(AF)[4,2] EQ 'XX'      ;* Sv
                    NO.OF.AV = DCOUNT(R.NEW(AF), @VM)
                    IF NO.OF.AV EQ 0 THEN
                        NO.OF.AV = 1
                    END
                    FOR AV = 1 TO NO.OF.AV
                        NO.OF.SV = DCOUNT(R.NEW(AF)<1,AV>, @SM)
                        IF NO.OF.SV EQ 0 THEN
                            NO.OF.SV = 1
                        END
                        FOR AS = 1 TO NO.OF.SV
                            GOSUB DO.CHECK.FIELD
                        NEXT AS
                    NEXT AV
                CASE F(AF)[1,2] = 'XX'      ;* Mv
                    AS = ''
                    NO.OF.AV = DCOUNT(R.NEW(AF), @VM)
                    IF NO.OF.AV EQ 0 THEN
                        NO.OF.AV = 1
                    END
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
************************************************************************
DO.CHECK.FIELD:

    COMI.ENRI = ""
    BEGIN CASE
        CASE AS
            COMI = R.NEW(AF)<1,AV,AS>
        CASE AV
            COMI = R.NEW(AF)<1,AV>
        CASE AF
            COMI = R.NEW(AF)
    END CASE

* CALL APAP.REDOEB.MB.SDB.POST.CHECK.FIELDS ;*Manual R22 conversion
    CALL APAP.REDOEB.mbSdbPostCheckFields();
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

************************************************************************
SET.UP.ENRI:

    LOCATE YENRI.FLD IN T.FIELDNO<1> SETTING YPOS THEN
    END

RETURN

************************************************************************
INITIALISE:

    SDB.STATUS = 0

RETURN

************************************************************************

END
