* @ValidationCode : MjotMTQ1NzgyNTQ1ODpDcDEyNTI6MTY4NDQxMTI3NDU3MjpzYW1hcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 18 May 2023 17:31:14
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.GET.ARRANGEMENT.STATUS(ARRANGEMENT.ID)

* Description
* This a COB routine for B51 Development
* This reads the Overdue Arrangement Condition for the Arrangement Id passed, gets the value from the
* Local Field L.LOAN.STATUS and update the value in the ACCOUNT application for the Arrangemnet Account
*
*
* Input/Output:
*--------------
* IN : ARRANGEMENT.ID
* OUT : -NA-
*---------------
*-----------------------------------------------------------------------------------------------------------------
* Modification History :
*   Date            Who                   Reference               Description
*   ------         ------               -------------            -------------
* 02 Sep 2010    Ravikiran AV              B.51                  Initial Creation
* 28-APR-2011      H GANESH           CR009              Change the Vetting value of local field
** 10-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 10-04-2023 Skanda R22 Manual Conversion - No changes
*-------------------------------------------------------------------------------------------------------------------
*
* All File INSERTS done here
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_BATCH.FILES
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_AA.LOCAL.COMMON
    $INSERT I_REDO.GET.ARRANGEMENT.STATUS.COMMON

*------------------------------------------------------------------------------------------------------------------
*Main Logic of the routine
*
MAIN.LOGIC:

    GOSUB INITIALISE
    CALL OCOMO("Processing ":ARRANGEMENT.ID:" for Loan Status updation in Account")
    GOSUB CHECK.PROCESSING.REQD

    IF (TO.PROCESS) THEN
        GOSUB PROCESS
    END

RETURN
*-----------------------------------------------------------------------------------------------------------------
* Initialise the required variables
*
INITIALISE:

    TO.PROCESS = ''
    RET.IDS = ''
    OD.COND = ''
    RET.ERR = ''

    ARRANGEMENT.REC = ''
    PROCESS.ERR = ''

    CALL F.READ(FN.AA.ARRANGEMENT, ARRANGEMENT.ID, ARRANGEMENT.REC, F.AA.ARRANGEMENT, PROCESS.ERR)

RETURN
*------------------------------------------------------------------------------------------------------------------
* Check whether the arrangemnet is authorised or Not. If not authorised then dont update the ACCOUNT record
*
CHECK.PROCESSING.REQD:

    BEGIN CASE

        CASE ARRANGEMENT.REC<AA.ARR.ARR.STATUS> EQ 'UNAUTH' ;* R22 Auto conversion
            COMO.TEXT = ARRANGEMENT.ID:" Skipped Arrangement not Authorised Yet"
        CASE 1
            TO.PROCESS = 1
    END CASE

RETURN
*-------------------------------------------------------------------------------------------------------------------
* Main logic of How ACCOUNT record is updated
*
PROCESS:

    GOSUB GET.OVERDUE.CONDITION

    GOSUB UPDATE.ACCOUNT.RECORD

RETURN
*------------------------------------------------------------------------------------------------------------------
* Get the LOAN.STATUS value from the OVERDUE condition of the ARRANGEMENT
*
GET.OVERDUE.CONDITION:

    CALL AA.GET.ARRANGEMENT.CONDITIONS(ARRANGEMENT.ID, 'OVERDUE','','', RET.IDS, OD.COND, RET.ERR)

    OD.COND = RAISE(OD.COND)

    OD.LOAN.STATUS = OD.COND<AA.OD.LOCAL.REF,Y.OD.LOAN.STATUS.POS,1>

RETURN
*------------------------------------------------------------------------------------------------------------------
* Update the ACCOUNT record with the STATUS
*
UPDATE.ACCOUNT.RECORD:

    GOSUB UPDATE.ACC.LOAN.STATUS

    ACC.ID = ARRANGEMENT.REC<AA.ARR.LINKED.APPL.ID>

    CALL F.READ(FN.ACCOUNT, ACC.ID, R.ACCOUNT, F.ACCOUNT, RET.ERR)

    IF (OD.AC.LOAN.STATUS) THEN
        R.ACCOUNT<AC.LOCAL.REF,Y.AC.LOAN.STATUS.POS> = OD.AC.LOAN.STATUS
    END ELSE
        R.ACCOUNT<AC.LOCAL.REF,Y.AC.LOAN.STATUS.POS> = ''
    END

    CALL F.WRITE(FN.ACCOUNT, ACC.ID, R.ACCOUNT)

RETURN
*------------------------------------------------------------------------------------------------------------
* Update the Vetting Table value in the LOAN.STATUS field in ACCOUNT
*
UPDATE.ACC.LOAN.STATUS:
    OD.AC.LOAN.STATUS = ''
    LOAN.STATUS.COUNT = DCOUNT(OD.LOAN.STATUS<1,1>,@SM)

    FOR TEMP.COUNT = 1 TO LOAN.STATUS.COUNT

        BEGIN CASE

            CASE OD.LOAN.STATUS<1,1,TEMP.COUNT> EQ 'JudicialCollection'
                OD.AC.LOAN.STATUS<1,1,TEMP.COUNT> = '1'

            CASE OD.LOAN.STATUS<1,1,TEMP.COUNT> EQ 'Restructured'
                OD.AC.LOAN.STATUS<1,1,TEMP.COUNT> = '2'

            CASE OD.LOAN.STATUS<1,1,TEMP.COUNT> EQ 'Write-off'
                OD.AC.LOAN.STATUS<1,1,TEMP.COUNT> = '3'

        END CASE

    NEXT TEMP.COUNT

RETURN
*-------------------------------------------------------------------------------------------------------------------
END
