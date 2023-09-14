* @ValidationCode : Mjo5MTkyOTI0ODg6Q3AxMjUyOjE2ODEyNzY5MjYwNzM6SVRTUzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Apr 2023 10:52:06
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.LY.PGEN.BIRTH.SELECT
*-------------------------------------------------------------------------------------------------
*DESCRIPTION:
*  This routine selects all customers with current birthday ids
*  This routine is the SELECT routine of the batch REDO.B.LY.PGEN.BIRTH which updates
*   REDO.LY.POINTS table based on the data defined in the parameter table
*   REDO.LY.MODALITY & REDO.LY.PROGRAM
* ------------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 17-JUN-2013   RMONDRAGON        ODR-2011-06-0243      Initial Creation
* Date                   who                   Reference              
* 12-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - FM TO @FM AND ++ TO += 1 AND F.READ TO CACHE.READ AND REMOVED F.DATES AND F.HOLIDAY
* 12-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*----------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.HOLIDAY

    $INSERT I_REDO.B.LY.PGEN.BIRTH.COMMON

    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

*----------
OPEN.FILES:
*----------

    FN.DATES = 'F.DATES'
    F.DATES = ''
    CALL OPF(FN.DATES,F.DATES)

    FN.HOLIDAY = 'F.HOLIDAY'
    F.HOLIDAY = ''
    CALL OPF(FN.HOLIDAY,F.HOLIDAY)

    FN.REDO.LY.MODALITY = 'F.REDO.LY.MODALITY'
    F.REDO.LY.MODALITY = ''
    CALL OPF(FN.REDO.LY.MODALITY,F.REDO.LY.MODALITY)

RETURN

*------------------
DEF.DAYS.FOR.BIRTH:
*------------------

    Y.DATE.TO.SELECT = ''
    Y.NEXT.WRK.DATE = ''
    Y.NEXT.WRK.MTH = ''

    ID.DATE = 'DO0010001-COB'
    R.DAT = ''; DAT.ERR = ''
    CALL CACHE.READ(FN.DATES, ID.DATE, R.DAT, DAT.ERR) ;*R22 AUTO CONVERSTION F.READ TO CACHE.READ AND REMOVED F.DATES
    IF R.DAT THEN
        Y.NEXT.WRK.DATE = R.DAT<EB.DAT.NEXT.WORKING.DAY>
        Y.NEXT.WRK.MTH = Y.NEXT.WRK.DATE[5,2]
    END

    Y.DATE.TO.SELECT = 'DATE.OF.BIRTH LIKE ...':TODAY[5,4]
    Y.NEXT.WRK.MTHDAY = Y.NEXT.WRK.DATE[5,4]
    Y.NEXT.WRK.YR = Y.NEXT.WRK.DATE[1,4]
    Y.CURR.MTH = TODAY[5,2]
    Y.CURR.YR = TODAY[1,4]
    Y.NEXT.DAY = TODAY[7,2] + 1
    GOSUB CONV.DAY
    REC.ID = 'DO00':TODAY[1,4]
    GOSUB READ.HOLIDAY
    Y.CURRENT.MONTH = FIELD(R.HOLIDAY,@FM,13+Y.CURR.MTH)
    Y.WORKING.DAY = Y.CURRENT.MONTH[Y.NEXT.DAY,1]
    IF Y.WORKING.DAY EQ 'X' OR Y.WORKING.DAY EQ '' THEN
        IF Y.CURR.YR NE Y.NEXT.WRK.YR THEN
            REC.ID = 'DO00':Y.NEXT.WRK.YR
            GOSUB READ.HOLIDAY
        END
        Y.CURRENT.MONTH = FIELD(R.HOLIDAY,@FM,13+Y.NEXT.WRK.MTH)
        Y.NEXT.DATE = Y.NEXT.WRK.MTH:'01'
    END ELSE
        Y.NEXT.DATE = Y.CURR.MTH:Y.NEXT.DAY
    END
    LOOP
    WHILE Y.NEXT.DATE LT Y.NEXT.WRK.MTHDAY
        Y.NEXT.DAY = Y.NEXT.DATE[3,2]
        Y.WORKING.DAY = Y.CURRENT.MONTH[Y.NEXT.DAY,1]
        IF Y.WORKING.DAY EQ 'H' THEN
            Y.DATE.TO.SELECT := ' OR DATE.OF.BIRTH LIKE ...':Y.NEXT.DATE
        END
        Y.NEXT.DAY += 1
        GOSUB CONV.DAY
        Y.NEXT.DATE = Y.NEXT.WRK.MTH:Y.NEXT.DAY
    REPEAT

RETURN

*------------
READ.HOLIDAY:
*------------

    R.HOLIDAY = ''; HOL.ERR = ''
    CALL CACHE.READ(FN.HOLIDAY, REC.ID, R.HOLIDAY, HOL.ERR) ;*R22 AUTO CONVERSTION F.READ TO CACHE.READ AND REMOVED F.HOLIDAY

RETURN

*--------
CONV.DAY:
*--------

    IF Y.NEXT.DAY LT 10 THEN
        Y.NEXT.DAY = '0':Y.NEXT.DAY
    END

RETURN

*-------
PROCESS:
*-------

    SEL.MOD = ''
    SEL.MOD = 'SSELECT ':FN.REDO.LY.MODALITY:' WITH EVENT EQ 4 AND TYPE EQ 6'
    MOD.LST = ''; NO.OF.MOD = 0; MOD.ERR = ''
    CALL EB.READLIST(SEL.MOD,MOD.LST,'',NO.OF.MOD,MOD.ERR)

    IF NO.OF.MOD NE 0 THEN
        GOSUB DEF.DAYS.FOR.BIRTH
        GOSUB DO.SELECTION
    END

RETURN

*------------
DO.SELECTION:
*------------

    SEL.LIST = ''
    SEL.BIRTH.CUST.CMD = 'SELECT ':FN.CUSTOMER:' WITH ':Y.DATE.TO.SELECT:' AND CUSTOMER.STATUS EQ 1'
    CALL EB.READLIST(SEL.BIRTH.CUST.CMD,SEL.LIST,'',ID.CNT,'')

    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN

END
