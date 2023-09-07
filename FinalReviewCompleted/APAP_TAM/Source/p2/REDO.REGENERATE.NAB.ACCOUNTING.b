* @ValidationCode : MjotNDQxMTY3Mjg2OkNwMTI1MjoxNjg0NDkxMDM4MTMyOklUU1M6LTE6LTE6NDQ4OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:38
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 448
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.REGENERATE.NAB.ACCOUNTING(ARR.ID)
 
*DESCRIPTION:
*------------
* This is the COB routine for CR-41.
*
* This will process the selected Arrangement IDs from the REDO.UPDATE.NAB.HISTORY file with STATUS is STARTED.
* This will raise a Consolidated Accounting Entry for NAB Contracts
*
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*---------------
*-----------------------------------------------------------------------------------------------------------------
* Modification History :
*   Date            Who                   Reference               Description
*   ------         ------               -------------            -------------
* 05 Dec 2011    Ravikiran AV              CR.41                 Initial Creation
*
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*25/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*25/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*------------------------------------------------------------------------------------------------------------------
* All File INSERTS done here
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.REDO.AA.INT.CLASSIFICATION
    $INSERT I_F.REDO.REPAID.INT
    $INSERT I_F.REDO.AA.NAB.HISTORY
    $INSERT I_REDO.REGENERATE.NAB.ACCOUNTING.COMMON

*------------------------------------------------------------------------------------------------------------------
* Main Logic of the routine
*
MAIN.LOGIC:

    GOSUB READ.NAB.HISTORY.REC

    GOSUB PROCESS

RETURN
*------------------------------------------------------------------------------------------------------------------
* Load the Arrangement ids for Multi-Threaded Processing
*
PROCESS:

    GOSUB READ.NAB.PARAM

RETURN
*------------------------------------------------------------------------------------------------------------------
*
*
READ.NAB.HISTORY.REC:

    CALL F.READ(FN.REDO.AA.NAB.HISTORY, ARR.ID, R.NAB.HIST.REC, F.REDO.AA.NAB.HISTORY, NAB.RET.ERR)

    GOSUB CHECK.FATAL.ERROR

RETURN
*------------------------------------------------------------------------------------------------------------------
*
*
CHECK.FATAL.ERROR:

    MSG.INFO = ''

    IF (NAB.RET.ERR) THEN

        MSG.INFO<1> = 'REDO.GENERATE.NAB.ACCOUNTING'
        MSG.INFO<2> = ''
        MSG.INFO<3> = 'REDO.GENERATE.NAB.ACCOUNTING'
        MSG.INFO<4> = 'Cannot find record in REDO.GENERATE.NAB.ACCOUNTING'
        MSG.INFO<5> = 'YES'

        CALL FATAL.ERROR(MSG.INFO)

    END

RETURN
*-----------------------------------------------------------------------------------------------------------------
*
*
READ.NAB.PARAM:

    CALL F.READ(FN.AA.ARRANGEMENT, ARR.ID, R.ARRANGEMENT, F.AA.ARRANGEMENT, RET.ERR)        ;*Read the Arrangement record for th

    IF NOT(RET.ERR) THEN        ;* If Arrangement found then update NAB Accounting Record

        AA.PRODUCT = R.ARRANGEMENT<AA.ARR.PRODUCT,1>
        COMP = R.ARRANGEMENT<AA.ARR.CO.CODE>

        IF (COMP EQ ID.COMPANY) THEN
            GOSUB UPDATE.REPAY.ACC.REC        ;* Update the NAB Accounting rec for the CURRENCY-SECTOR
        END
    END

RETURN
*-------------------------------------------------------------------------------------------------------------------
*
*
UPDATE.REPAY.ACC.REC:

    REPAY.INT.ID = R.NAB.HIST.REC<REDO.NAB.HIST.CURRENCY>:'-':R.NAB.HIST.REC<REDO.NAB.HIST.SECTOR>:'-':R.NAB.HIST.REC<REDO.NAB.HIST.L.LOAN.STATUS>:'-':AA.PRODUCT:'-':ID.COMPANY

    CALL F.READU(FN.REDO.REPAID.INT, REPAY.INT.ID, REPAY.REC, F.REDO.REPAID.INT,RET.ERR,'')

    IF (RET.ERR) THEN ;* Update the NAB.ACC.ID as new record

        REPAY.REC<REDO.REP.INT.REPAID.AMT> = R.NAB.HIST.REC<REDO.NAB.HIST.LAST.INT.PAID>

    END ELSE

        REPAID.AMT = R.NAB.HIST.REC<REDO.NAB.HIST.LAST.INT.PAID>
        REPAID.ACC.AMT =  REPAY.REC<REDO.REP.INT.REPAID.AMT>
        REPAY.REC<REDO.REP.INT.REPAID.AMT> = REPAID.ACC.AMT + REPAID.AMT

    END

    REPAY.REC<REDO.REP.INT.PRODUCT> = AA.PRODUCT
    REPAY.REC<REDO.REP.INT.LOAN.STATUS> = R.NAB.HIST.REC<REDO.NAB.HIST.L.LOAN.STATUS>

    CALL F.WRITE(FN.REDO.REPAID.INT, REPAY.INT.ID, REPAY.REC)

    CALL F.RELEASE(FN.REDO.REPAID.INT, REPAY.INT.ID, F.REDO.REPAID.INT)

RETURN
*-------------------------------------------------------------------------------------------------------------------
*
*
END
