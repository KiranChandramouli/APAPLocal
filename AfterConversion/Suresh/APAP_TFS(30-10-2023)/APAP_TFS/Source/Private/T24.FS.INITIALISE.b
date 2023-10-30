* @ValidationCode : MjoxODM2MjgzOTg3OkNwMTI1MjoxNjk4MzA4ODM4ODE4OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 26 Oct 2023 13:57:18
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
$PACKAGE APAP.TFS
*-----------------------------------------------------------------------------
* <Rating>252</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE T24.FS.INITIALISE
*
* Subroutine to initialise certain variables/arrays used by T24 FS suite of programs
*
*-------------------------------------------------------------------------------
*
* Modification History:
*
* 03/03/05 - Sathish PS
*            New Development
*
* 03/25/05 - Sathish PS
*            After loading TFS.PARAMETER, also build TFS$RESET.FIELD.NOS based
*            on definition in RESET.FIELDS in TFS.PARAMETER - Just convert names to numbers
*
* 04/12/05 - Sathish PS
*            Use EB.READ.PARAMETER to read TFS.PARAMETER
*
* 05/12/05 - Sathish PS
*            Introduction of 2 new common variables - TFS$LINE.FIRST.FIELD &
*            TFS$LINE.LAST.FIELD pointing to fields TFS.TRANSACTION & TFS.RETRY resp.
*
* 29 AUG 07 - Sathish PS
*            Enable for NS
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*26/10/2023         Suresh             R22 Manual Conversion             GLOBUS.BP File Removed, USPLATFORM.BP File Removed
*-------------------------------------------------------------------------------
    $INCLUDE I_COMMON ;*R22 Manual Conversion - START
    $INCLUDE I_EQUATE
    $INCLUDE I_F.CURRENCY
    $INCLUDE I_F.COMPANY
    $INCLUDE I_F.TELLER.DENOMINATION
    $INCLUDE I_F.TELLER
    $INCLUDE I_F.STANDARD.SELECTION     ;* 03/25/05 - Sathish PS s/e

    $INCLUDE I_T24.FS.COMMON
    $INCLUDE I_F.TFS.PARAMETER
    $INCLUDE I_F.T24.FUND.SERVICES ;*R22 Manual Conversion  - END

    GOSUB INIT
    GOSUB PRELIM.CONDS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN
*-------------------------------------------------------------------------------
PROCESS:

    LOOP.CNT = 1
    LOOP
    WHILE LOOP.CNT LE 4 AND PROCESS.GOAHEAD DO
        BEGIN CASE
            CASE LOOP.CNT EQ 1
                GOSUB LOAD.TFS.PARAMETER
            CASE LOOP.CNT EQ 2
                GOSUB INITIALISE.CURRENCY.LIST
            CASE LOOP.CNT EQ 3
                GOSUB INITIALISE.COMPANY.LIST
            CASE LOOP.CNT EQ 4
                GOSUB INITIALISE.DENOM.LIST
        END CASE
        LOOP.CNT += 1
    REPEAT

RETURN
*-------------------------------------------------------------------------------
LOAD.TFS.PARAMETER:
    IF NOT(TFS$R.TFS.PAR) THEN          ;* 20100624 umar
        CALL EB.READ.PARAMETER(FN.TFSP,'N','',R.TFS.PAR,ID.TFSP,F.TFSP,ERR.TFSP)          ;* 04/12/05 - Sathish PS s/e
        IF R.TFS.PAR THEN
            GOSUB BUILD.RESET.FIELD.NOS
            TFS$R.TFS.PAR = R.TFS.PAR
        END ELSE
            E = 'EB-US.REC.MISS.FILE' :@FM: ID.TFSP :@VM: FN.TFSP
            PROCESS.GOAHEAD = 0
        END
* 20100624 umar - start
    END ELSE
        R.TFS.PAR = TFS$R.TFS.PAR
    END
* 20100624 umar - end
RETURN
*-------------------------------------------------------------------------------
* 03/25/05 - Sathish PS /s
BUILD.RESET.FIELD.NOS:

    IF R.TFS.PAR<TFS.PAR.RESET.FIELDS> THEN
        RESET.FIELDS = R.TFS.PAR<TFS.PAR.RESET.FIELDS>
        LOOP
            REMOVE RESET.FIELD FROM RESET.FIELDS SETTING NEXT.FIELD.POS
        WHILE RESET.FIELD : NEXT.FIELD.POS DO

            SS.ID = 'T24.FUND.SERVICES' ; CALL EB.FIND.FIELD.NO(SS.ID,RESET.FIELD)
            RESET.FIELD.NO = RESET.FIELD
            IF RESET.FIELD.NO AND NUM(RESET.FIELD.NO) THEN
                IF RESET.FIELD.NOS THEN
                    RESET.FIELD.NOS := @VM: RESET.FIELD.NO
                END ELSE
                    RESET.FIELD.NOS = RESET.FIELD.NO
                END
            END

        REPEAT

        IF RESET.FIELD.NOS<1,1> THEN TFS$RESET.FIELD.NOS = RESET.FIELD.NOS
    END

RETURN
* 03/25/05 - Sathish PS /e
*-----------------------------------------------------------------------------------
INITIALISE.CURRENCY.LIST:

    IF NOT(TFS$CCY.LIST) THEN ;* Only for the first time. Will hold good for the whole session
* 20100624 umar - start
        SEL.CCY = 'SELECT ':FN.CCY
*        CALL EB.READLIST(SEL.CCY,TFS$CCY.LIST,'','','')
        CALL CACHE.READ(FN.CCY,'SSelectIDs',TFS$CCY.LIST,'')
* 20100624 umar - end
        IF TFS$CCY.LIST THEN
            CONVERT @FM TO @VM IN TFS$CCY.LIST
        END ELSE
            TEXT = SEL.CCY:' - NO RECORDS SELECTED'
            CALL FATAL.ERROR(MY.NAME)
        END
    END
*
RETURN
*---------------------------------------------------------------------------------
INITIALISE.COMPANY.LIST:

    IF NOT(TFS$COMPANY.LIST) THEN       ;* Only for the first time. Will hold good for the whole session
        SEL.COMP = 'SELECT ':FN.COMP:' WITH CONSOLIDATION.MARK EQ "N"'
        CALL EB.READLIST(SEL.COMP,TFS$COMPANY.LIST,'','','')
        IF TFS$COMPANY.LIST THEN
            CONVERT @FM TO @VM IN TFS$COMPANY.LIST
        END ELSE
            TEXT = SEL.COMP:' - NO RECORDS SELECTED'
            CALL FATAL.ERROR(MY.NAME)
        END
    END
*
RETURN
*----------------------------------------------------------------------------------
INITIALISE.DENOM.LIST:
    IF NOT(TFS$TT.DENOM.CCY) THEN       ;* 20100624 umar
* 20100624 umar - start
        CALL CACHE.READ(FN.TD,'SSelectIDs',TD.ID.LIST,ERR.TD)
*    SEL.TD = 'SSELECT ':FN.TD
*    CALL EB.READLIST(SEL.TD,TD.ID.LIST,'','','')
* 20100624 umar - start
        IF TD.ID.LIST THEN
            LOOP
                REMOVE ID.TD FROM TD.ID.LIST SETTING MORE.IDS
            WHILE ID.TD : MORE.IDS DO

                CALL CACHE.READ(FN.TD,ID.TD,R.TD,ERR.TD)
                IF ERR.TD THEN
                    E = 'EB-TFS.REC.MISS.FILE' :@FM: ID.TD :@VM: FN.TD
                END ELSE
                    DENOM.CCY = ID.TD[1,3]
                    DENOM.VALUE = R.TD<TT.DEN.VALUE>
                    IF DENOM.CCY MATCHES TFS$CCY.LIST THEN
                        GOSUB APPEND.TO.CACHE
                    END ELSE
                        E = 'EB-TFS.INVALID.CCY' :@FM: DENOM.CCY
                    END
                END

            REPEAT
        END ELSE
            E = 'EB-TFS.NO.RECS.IN.TELLER.DENOM' :@FM: FN.TD
        END
*
        IF E THEN
            GOSUB CLEAR.CACHE
        END

        RETURN
*-------------------------------------------------------------------------------
APPEND.TO.CACHE:

        LOCATE DENOM.CCY IN TFS$TT.DENOM.CCY<1> SETTING CCY.POS ELSE
            TFS$TT.DENOM.CCY<CCY.POS> = DENOM.CCY
        END
*
        LOCATE DENOM.VALUE IN TFS$TT.DENOM(CCY.POS)<2,1> BY 'DR' SETTING VALUE.POS THEN
            IF TFS$TT.DENOM(CCY.POS)<1,VALUE.POS> NE ID.TD THEN
                INS ID.TD BEFORE TFS$TT.DENOM(CCY.POS)<1,VALUE.POS>
                INS DENOM.VALUE BEFORE TFS$TT.DENOM(CCY.POS)<2,VALUE.POS>
            END
        END ELSE
            INS ID.TD BEFORE TFS$TT.DENOM(CCY.POS)<1,VALUE.POS>
            INS DENOM.VALUE BEFORE TFS$TT.DENOM(CCY.POS)<2,VALUE.POS>
        END

        RETURN
*-------------------------------------------------------------------------------
CLEAR.CACHE:

        TFS$TT.DENOM.CCY = ''
        MAT TFS$TT.DENOM = ''

        RETURN
*-------------------------------------------------------------------------------
*//////////////////////////////////////////////////////////////////////////////*
*//////////////////P R E  P R O C E S S  S U B R O U T I N E S ////////////////*
*//////////////////////////////////////////////////////////////////////////////*
INIT:

        PROCESS.GOAHEAD = 1

        TFS$MESSAGE = ''
        TFS$AUTH.NO = ''

        IF UNASSIGNED(TFS$TT.DENOM.CCY) OR NOT(TFS$TT.DENOM.CCY) THEN
            TFS$TT.DENOM.CCY = ''
            MAT TFS$TT.DENOM = ''
        END
* 03/24/05 - Sathish PS /s
        MAT TFS$T = ''
        MAT TFS$T = MAT T
* 03/24/05 - Sathish PS /e
* 03/25/05 - Sathish PS /s
        IF UNASSIGNED(TFS$RESET.FIELD.NOS) OR NOT(TFS$RESET.FIELD.NOS) THEN
            TFS$RESET.FIELD.NOS = ''
        END
        RESET.FIELD.NOS = ''
        SS.ID = ''
* 03/25/05 - Sathish PS /e

* 05/12/05 - Sathish PS /s
        TFS$LINE.FIRST.FIELD = TFS.TRANSACTION
        TFS$LINE.LAST.FIELD = TFS.RETRY
* 05/12/05 - Sathish PS /e
        MY.NAME = APPLICATION
        FN.TD = 'F.TELLER.DENOMINATION' ; F.TD = '' ; CALL OPF(FN.TD,F.TD)
        FN.CCY = 'F.CURRENCY' ; F.CCY = '' ; CALL OPF(FN.CCY,F.CCY)
        FN.COMP = 'F.COMPANY' ; F.COMP = '' ; CALL OPF(FN.COMP,F.COMP)
        FN.TFSP = 'F.TFS.PARAMETER' ; F.TFSP = '' ; ID.TFSP = ID.COMPANY        ;* 04/12/05 - Sathish PS s/e
        FN.SS = 'F.STANDARD.SELECTION' ; F.SS = ''

        C$NS.OPERATION = 'ALL'          ;* 29 AUG 07 - Sathish PS s/e
* 20100624 umar - start
        IF UNASSIGNED(TFS$ID.TFS.PAR) THEN
            TFS$ID.TFS.PAR = ID.COMPANY
            TFS$R.TFS.PAR = ''
        END
        IF TFS$ID.TFS.PAR NE ID.COMPANY THEN
            TFS$CCY.LIST = ''
            TFS$TT.DENOM.CCY = ''
            MAT TFS$TT.DENOM = ''
            TFS$R.TFS.PAR = ''
        END
* 20100624 umar - end
        RETURN
*-------------------------------------------------------------------------------
PRELIM.CONDS:

*    IF TFS$TT.DENOM.CCY THEN PROCESS.GOAHEAD = 0 ;* 20100624 umar

        RETURN
*-------------------------------------------------------------------------------
    END









