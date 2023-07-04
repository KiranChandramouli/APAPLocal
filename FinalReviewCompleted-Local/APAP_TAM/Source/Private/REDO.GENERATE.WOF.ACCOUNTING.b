* @ValidationCode : MjozNjY0Mjk0NTM6Q3AxMjUyOjE2ODA3MTU5ODYwMTk6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Apr 2023 23:03:06
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.GENERATE.WOF.ACCOUNTING(ARR.ID)

*DESCRIPTION:
*------------
* This is the COB routine for CR-43.
*
* This will process the selected Arrangement IDs from the REDO.UPDATE.NAB.HISTORY file with WOF.DATE eq 'TODAY'
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
* 26 Feb 2012    Ravikiran AV              CR.43                 Initial Creation
* 06.04.2023     Conversion Tool           R22                 Auto Conversion     - No changes
* 06.04.2023     Shanmugapriya M           R22                 Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------------------
* All File INSERTS done here
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.REDO.AA.INT.CLASSIFICATION
    $INSERT I_F.REDO.WOF.ACCOUNTING
    $INSERT I_F.REDO.AA.NAB.HISTORY
    $INSERT I_REDO.GENERATE.WOF.ACCOUNTING.COMMON

*------------------------------------------------------------------------------------------------------------------
* Main Logic of the routine
*
MAIN.LOGIC:


    GOSUB READ.NAB.HISTORY.REC

    GOSUB PROCESS

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
* Load the Arrangement ids for Multi-Threaded Processing
*
PROCESS:

    GOSUB READ.NAB.PARAM

RETURN
*------------------------------------------------------------------------------------------------------------------
*
*
READ.NAB.PARAM:

    CALL F.READ(FN.AA.ARRANGEMENT, ARR.ID, R.ARRANGEMENT, F.AA.ARRANGEMENT, RET.ERR)        ;*Read the Arrangement record for the Product

    IF NOT(RET.ERR) THEN        ;* If Arrangement found then update NAB Accounting Record

        AA.PRODUCT = R.ARRANGEMENT<AA.ARR.PRODUCT,1>
        COMP = R.ARRANGEMENT<AA.ARR.CO.CODE>

        IF (COMP EQ ID.COMPANY) THEN
            GOSUB UPDATE.NAB.ACC.REC          ;* Update the NAB Accounting rec for the CURRENCY-SECTOR
        END
    END

RETURN
*-------------------------------------------------------------------------------------------------------------------
UPDATE.NAB.ACC.REC:

    WOF.ACC.ID = R.NAB.HIST.REC<REDO.NAB.HIST.CURRENCY>:'-':R.NAB.HIST.REC<REDO.NAB.HIST.SECTOR>:'-':R.NAB.HIST.REC<REDO.NAB.HIST.L.LOAN.STATUS>:'-':AA.PRODUCT:'-':ID.COMPANY

    WOF.AMT = R.NAB.HIST.REC<REDO.NAB.HIST.NAB.INTEREST>

    CALL F.READU(FN.REDO.WOF.ACCOUNTING, WOF.ACC.ID, WOF.ACC.REC, F.REDO.WOF.ACCOUNTING,RET.ERR,'')

    IF (RET.ERR) THEN ;* Update the NAB.ACC.ID as new record

        WOF.ACC.REC<REDO.WOF.ACC.WOF.AMT> = WOF.AMT

    END ELSE

        WOF.ACC.AMT =  WOF.ACC.REC<REDO.WOF.ACC.WOF.AMT>
        WOF.ACC.REC<REDO.WOF.ACC.WOF.AMT> = WOF.ACC.AMT + WOF.AMT

    END

    WOF.ACC.REC<REDO.WOF.ACC.PRODUCT> = AA.PRODUCT
    WOF.ACC.REC<REDO.WOF.ACC.LOAN.STATUS> = R.NAB.HIST.REC<REDO.NAB.HIST.L.LOAN.STATUS>

    CALL F.WRITE(FN.REDO.WOF.ACCOUNTING, WOF.ACC.ID, WOF.ACC.REC)

    CALL F.RELEASE(FN.REDO.WOF.ACCOUNTING, WOF.ACC.ID, F.REDO.WOF.ACCOUNTING)

RETURN
*-------------------------------------------------------------------------------------------------------------------
*
*
END
