* @ValidationCode : MjoyMDE2ODI2MzM3OkNwMTI1MjoxNzA1MDY3ODMzOTUwOklUU1MxOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Jan 2024 19:27:13
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
**===========================================================================================================================================
*-----------------------------------------------------------------------------
* <Rating>404</Rating>
*-----------------------------------------------------------------------------
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.CORR.APD.ARR (Y.AAA.ID)
**===========================================================================================================================================
**  This routine is developed to update AA.PROCESS.DETAILS. Where the AAA record has some missing AA.ARR.<<PROPERTY>> records in NAU.
**  Some of the child activities linked in AA.RR.CONTROL is not available in NAU
**
**  Correction will done to loop through AA.RR.CONTROL and remove the AAA which are missing in NAU
**  AA.PROCESS.DETAILS will be validated and missing AA.ARR.<<PROPERTY>> link will be removed
**  Then delete the MASTER activity.
*
**===========================================================================================================================================
*** Modification history
*--------------------------
*   DATE          WHO                 REFERENCE               DESCRIPTION
*   12-01-2024    Santosh        R22 MANUAL CONVERSION       BP removed and FM/VM changed to @FM/@VM, added I_ in COMMON file
**===========================================================================================================================================
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.PROCESS.DETAILS
    $INSERT I_AA.RR.CONTROL
    $INSERT I_F.AA.ACTIVITY.HISTORY
    $INSERT I_L.APAP.CORR.APD.ARR.COMMON
    $USING EB.TransactionControl
**===========================================================================================================================================
*CALL L.APAP.CORR.APD.ARR.LOAD
*Y.AAA.ID = 'AAACT23303LBBWPMKN#1'
    GOSUB PROCESS
RETURN
**===========================================================================================================================================

**===========================================================================================================================================
PROCESS:

    CRT "********************************************************************"

    AAA.ID = FIELD(Y.AAA.ID, "#", 1)
    DIRECT.FLAG = FIELD(Y.AAA.ID, "#", 2)

    R.AAA$NAU = ''; NAU.ERR = ''

    CALL F.READ(FN.AAA$NAU, AAA.ID, R.AAA$NAU, F.AAA$NAU, NAU.ERR)

    EFF.DATE = R.AAA$NAU<AA.ARR.ACT.EFFECTIVE.DATE>

    IF DIRECT.FLAG THEN
        GOSUB DEL.AAA
    END ELSE

*        IF R.AAA$NAU NE '' AND (R.AAA$NAU<AA.ARR.ACT.RECORD.STATUS> = "INAU" OR R.AAA$NAU<AA.ARR.ACT.RECORD.STATUS> = "RNAU") THEN
        IF R.AAA$NAU NE '' AND (R.AAA$NAU<AA.ARR.ACT.RECORD.STATUS> EQ "INAU" OR R.AAA$NAU<AA.ARR.ACT.RECORD.STATUS> EQ "RNAU") THEN;* R22 UTILITY AUTO CONVERSION
            AA.ID = R.AAA$NAU<AA.ARR.ACT.ARRANGEMENT>
            R.AA = ''; AA.ERR = ''
            CALL F.READ(FN.AA.ARRANGEMENT,AA.ID,R.AA,F.AA.ARRANGEMENT ,AA.ERR)

            BEGIN CASE
                CASE R.AAA$NAU<AA.ARR.ACT.REV.MASTER.AAA> NE ""
                    AAA.ID = R.AAA$NAU<AA.ARR.ACT.REV.MASTER.AAA>
                    R.AAA$NAU = '' ; NAU.ERR = ''
                    CALL F.READ(FN.AAA$NAU, AAA.ID, R.AAA$NAU, F.AAA$NAU, NAU.ERR)
                    IF R.AAA$NAU NE '' THEN
                        GOSUB DEL.AAA
                    END
                CASE R.AAA$NAU<AA.ARR.ACT.MASTER.AAA> NE AAA.ID
                    AAA.ID = R.AAA$NAU<AA.ARR.ACT.MASTER.AAA>
                    R.AAA$NAU = '' ; NAU.ERR = ''
                    CALL F.READ(FN.AAA$NAU, AAA.ID, R.AAA$NAU, F.AAA$NAU, NAU.ERR)
                    IF R.AAA$NAU NE '' THEN
                        GOSUB DEL.AAA
                    END
                CASE R.AAA$NAU<AA.ARR.ACT.MASTER.AAA> EQ AAA.ID
                    GOSUB DEL.AAA
                CASE 1
            END CASE
        END
    END
    CRT "********************************************************************"


RETURN
**===========================================================================================================================================
DEL.AAA:
********
    P.AAA.ID = AAA.ID
    GOSUB CHECK.APD
    GOSUB CHECK.RR.CONTROL

*    CALL JOURNAL.UPDATE('')
    EB.TransactionControl.JournalUpdate('');* R22 UTILITY AUTO CONVERSION

RETURN
**===========================================================================================================================================
CHECK.APD:
**********

    R.APD = '';APD.ERR = ''
*    CALL F.READ(FN.APD, P.AAA.ID, R.APD, FV.APD, APD.ERR)
    CALL F.READU(FN.APD, P.AAA.ID, R.APD, FV.APD, APD.ERR,'');* R22 UTILITY AUTO CONVERSION

    IF R.APD NE '' THEN

        CNT.PRPTY = DCOUNT(R.APD<AA.PROC.PROPERTY>,@VM)
        WRITE.FLAG = 0

        FOR IDX = 1 TO CNT.PRPTY

            PROCESS.ID = R.APD<AA.PROC.PROCESS.DETAILS, IDX>
            AA.ARR.PROP = FIELD(FIELD(PROCESS.ID, ' ', 1), ',', 1)
            AA.ARR.FUNCTION = FIELD(PROCESS.ID, ' ', 2)
            AA.ARR.ID = FIELD(PROCESS.ID, ' ', 3)
            ID.PROP = FIELD(AA.ARR.PROP, '.', 3, 2)
*            IF AA.ARR.FUNCTION = 'I' THEN
            IF AA.ARR.FUNCTION EQ 'I' THEN;* R22 UTILITY AUTO CONVERSION
                FN.AA.ARR.PROP='F.AA.ARR.':ID.PROP:'$NAU'
                F.AA.ARR.PROP=''
                CALL OPF(FN.AA.ARR.PROP, F.AA.ARR.PROP)
                R.AA.ARR = '';AA.ARR.PROP.ERR = ''
                CALL F.READ(FN.AA.ARR.PROP, AA.ARR.ID, R.AA.ARR, F.AA.ARR.PROP, AA.ARR.PROP.ERR)
                IF R.AA.ARR EQ '' THEN
                    CRT "Processing ":P.AAA.ID:" - ":AA.ARR.ID:" Record Missing in ":FN.AA.ARR.PROP
                    CALL OCOMO("Processing ":P.AAA.ID:" - ":AA.ARR.ID:" Record Missing in ":FN.AA.ARR.PROP)
                    DEL R.APD<AA.PROC.PROCESS.DETAILS,IDX>  ;* Delete the content
                    DEL R.APD<AA.PROC.PROPERTY,IDX>

                    CNT.PRPTY = CNT.PRPTY - 1
                    IDX = IDX - 1

                    WRITE.FLAG = 1
                END
            END
        NEXT IDX

        IF WRITE.FLAG EQ 1 THEN
            CALL F.WRITE(FN.APD,P.AAA.ID,R.APD)
*            CALL JOURNAL.UPDATE('')
            EB.TransactionControl.JournalUpdate('');* R22 UTILITY AUTO CONVERSION
        END

    END

RETURN
**===========================================================================================================================================
CHECK.RR.CONTROL:
*****************

    R.CONTROL.REC = ""; RR.ERR = ""
*    CALL F.READ(FN.RR.CONTROL, AAA.ID, R.CONTROL.REC, F.RR.CONTROL, RR.ERR)
    CALL F.READU(FN.RR.CONTROL, AAA.ID, R.CONTROL.REC, F.RR.CONTROL, RR.ERR,'');* R22 UTILITY AUTO CONVERSION

    IF NOT(RR.ERR) THEN
        REQ.FLDS = AA.RRC.REVERSE.AAA.ID:@FM:AA.RRC.REPLAY.ID:@FM:AA.RRC.REPLAY.NEW.IDS:@FM:AA.RRC.REVERSE.SEC.AAA.ID:@FM:AA.RRC.PENDING.SECONDARY:@FM:AA.RRC.ACCRUAL.ADJUST

        CNT.FLDS = DCOUNT(REQ.FLDS, @FM)

        FOR FLD.IDX = 1 TO CNT.FLDS

            CURR.FLD = REQ.FLDS<FLD.IDX>
            T.AAA.LIST = R.CONTROL.REC<CURR.FLD>
            CNT.CF = DCOUNT(R.CONTROL.REC<CURR.FLD>, @VM)

            FOR CF.IDX = 1 TO CNT.CF
*                IF CURR.FLD = AA.RRC.ACCRUAL.ADJUST THEN    ;* adjust activity will be stored in different format
                IF CURR.FLD EQ AA.RRC.ACCRUAL.ADJUST THEN    ;* adjust activity will be stored in different format;* R22 UTILITY AUTO CONVERSION
                    P.AAA.ID = FIELD(R.CONTROL.REC<CURR.FLD, CF.IDX>, "-", 1)
                END ELSE
                    P.AAA.ID = R.CONTROL.REC<CURR.FLD, CF.IDX>
                END
                TEMP.IDS = RAISE(P.AAA.ID)
                TEMP.CNT = DCOUNT(TEMP.IDS,@VM)
                IF TEMP.CNT EQ 1 THEN

                    P.AAA$NAU = ""; P.NAU.ERR = ""
                    CALL F.READ(FN.AAA$NAU, P.AAA.ID, P.AAA$NAU, F.AAA$NAU, P.NAU.ERR)
                    IF NOT(P.NAU.ERR) THEN
                        GOSUB CHECK.APD
                    END ELSE
                        CRT "Processing ":P.AAA.ID:" - Record Missing in ":FN.AAA$NAU

                        CALL OCOMO("Processing ":P.AAA.ID:" - Record Missing in ":FN.AAA$NAU)
                        DEL R.CONTROL.REC<CURR.FLD, CF.IDX> ;* Delete the content
                        IF CURR.FLD EQ AA.RRC.ACCRUAL.ADJUST THEN
                            DEL R.CONTROL.REC<AA.RRC.ACCRUAL.ADJUST.TO, CF.IDX> ;* Delete the content
                        END
* Why we arer deleting??
*** CALL F.DELETE(FN.APD, P.AAA.ID)
                        CF.IDX = CF.IDX - 1
                        CNT.CF = CNT.CF - 1
                    END
                END
            NEXT CF.IDX
        NEXT FLD.IDX
        CALL F.WRITE(FN.RR.CONTROL, AAA.ID, R.CONTROL.REC)
    END

RETURN
**===========================================================================================================================================
END
