* @ValidationCode : MjoxOTMxNTk4MTM3OkNwMTI1MjoxNjgwNzc0NTAzMjE5OjkxNjM4Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Apr 2023 15:18:23
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 91638
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOSRTN
SUBROUTINE REDO.S.BY.EVENT(EVENT,ACCT.ID,R.ACCOUNT,CHK.VAL,ANTIG)
*-------------------------------------------------------------------------------------------
*DESCRIPTION:
*             This routine is an internal call routine called by the batch routine REDO.B.LY.POINT.GEN to get the value
*  based on which the point to be updated in REDO.LY.POINTS is computed for modality type 6
* ------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  :
* ACCT.ID   - ACCOUNT no
* R.ACCOUNT - ACCOUNT record for the ACCOUNT no passed in ACCT.ID
* EVENT     - Event type defined in modality record
*
* OUT :
* CHK.VAL - 1 to update points in REDO.LY.POINTS and 0 not to update
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : REDO.B.LY.POINT.GEN
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 03-MAY-2010   N.Satheesh Kumar  ODR-2009-12-0276      Initial Creation
*Modification history
*Date                Who               Reference                  Description
*06-04-2023      conversion tool     R22 Auto code conversion     No changes
*06-04-2023      Mohanraj R          R22 Manual code conversion   No changes

*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ACCT.ACTIVITY
    $INSERT I_F.CUSTOMER

    $INSERT I_REDO.B.LY.POINT.GEN.COMMON

    CHK.VAL = 0
    BEGIN CASE
        CASE EVENT EQ 1
* Points in REDO.LY.MODALITY will be updated of account is opened on current date
            IF R.ACCOUNT<AC.OPENING.DATE> EQ TODAY THEN
                CHK.VAL = 1
            END
        CASE EVENT EQ 2
* Points in REDO.LY.MODALITY will be updated if the account is re activated
            ACC.CURR.NO = R.ACCOUNT<AC.CURR.NO>
            IF ACC.CURR.NO GT 1 THEN
                HIS.ACC.CURR.NO = ACC.CURR.NO - 1
                HIS.ACC.ID = ACCT.ID:';':HIS.ACC.CURR.NO
                CALL F.READ(FN.ACCOUNT.HIS,HIS.ACC.ID,R.ACCOUNT.HIS,F.ACCOUNT.HIS,ACC.HIS.ERR)
                VAR.ACC.STATUS = R.ACCOUNT.HIS<AC.LOCAL.REF,POS.L.AC.STATUS1>
                IF VAR.ACC.STATUS NE 'ACTIVE' AND VAR.ACC.STATUS NE '' THEN
                    CHK.VAL = 1
                END
            END
        CASE EVENT EQ 3
* Points in REDO.LY.MODALITY will be updated if NO.OF.TRANSACT field in ACCT.ACTIVITY has value 1
            ACCT.ACT.ID = ACCT.ID:'-':TODAY[1,4]:TODAY[5,2]
            CALL F.READ(FN.ACCT.ACTIVITY,ACCT.ACT.ID,R.ACCT.ACTIVITY,F.ACCT.ACTIVITY,ACCT.ACT.ERR)
            NO.OF.TRANSACT = R.ACCT.ACTIVITY<IC.ACT.NO.OF.TRANSACT>
            LOCATE '1' IN NO.OF.TRANSACT<1,1> SETTING TRANS.POS THEN
                CHK.VAL = 1
            END
        CASE EVENT EQ 4
* Points in REDO.LY.MODALITY will be updated if customer date of birth and month is same as current system date
            CUS.ID = R.ACCOUNT<AC.CUSTOMER>
            CALL F.READ(FN.CUSTOMER,CUS.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
            CUS.DOB = R.CUSTOMER<EB.CUS.DATE.OF.BIRTH>
            IF CUS.DOB[5,4] EQ TODAY[5,4] THEN
                CHK.VAL = 1
            END
        CASE EVENT EQ 5
* Points in REDO.LY.MODALITY will be updated if account is opened in the past with the same month and date greater than or equal to current date
            AC.OPEN.DATE = R.ACCOUNT<AC.OPENING.DATE>
            AC.OPEN.YR = AC.OPEN.DATE[1,4]
            Y.YEAR.TO.GET = TODAY[1,4] - ANTIG
            IF AC.OPEN.YR EQ Y.YEAR.TO.GET THEN
                CHK.VAL = 1
            END
    END CASE
RETURN
END
