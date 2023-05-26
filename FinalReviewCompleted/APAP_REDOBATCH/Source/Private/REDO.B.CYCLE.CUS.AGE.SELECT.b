* @ValidationCode : MjotNTc2MDIxMzIxOkNwMTI1MjoxNjg0ODU0Mzg0NzY2OklUU1M6LTE6LTE6MjkxOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:24
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 291
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.CYCLE.CUS.AGE.SELECT
*-----------------------------------------------------------------------------------
* Description: Subroutine to perform the select and build the batch list. The select
* here is being read from the records, since the last working day till today and
* would be populated. Once the records set is determined, each record is read from
* the file, and then used to create the job list
* Programmer: M.MURALI(Temenos Application Management)
* Creation Date: 02 Jul 09
*-----------------------------------------------------------------------------------
* Modification History:
* Gopala Krishnan R - 22-MARCH-2018 - PACS00660080
* Date                   who                   Reference              
* 11-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - FM TO @FM AND I TO I.VAR
* 11-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_REDO.B.CYCLE.CUS.AGE.COMMON

    Y.LAST.WORKING.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
    Y.TODAY = R.DATES(EB.DAT.TODAY)

    Y.NO.OF.DAYS = 'C'
    CALL CDD('', Y.LAST.WORKING.DAY, Y.TODAY, Y.NO.OF.DAYS)
    IF Y.NO.OF.DAYS GE 1 THEN
        R.CUSTOMER.DOB = ''
        Y.READ.ERR = ''
        CALL F.READ(FN.CUSTOMER.DOB, Y.TODAY[5,4], R.CUSTOMER.DOB, F.CUSTOMER.DOB, Y.READ.ERR)
        Y.RECORD.LIST = R.CUSTOMER.DOB
        GOSUB LEAP.YEAR.CHECK
    END

    IF Y.NO.OF.DAYS GT 1 THEN

        Y.NO.OF.DAYS -= 1
        Y.START.DATE = Y.TODAY

        FOR I.VAR = 1 TO Y.NO.OF.DAYS STEP 1
            CALL CDT('', Y.START.DATE, '-1C')
            R.CUSTOMER.DOB = ''
            Y.READ.ERR = ''
            CALL F.READ(FN.CUSTOMER.DOB, Y.START.DATE[5,4], R.CUSTOMER.DOB, F.CUSTOMER.DOB, Y.READ.ERR)
            IF Y.RECORD.LIST NE '' THEN
                Y.RECORD.LIST := @FM : R.CUSTOMER.DOB
            END ELSE
                Y.RECORD.LIST = R.CUSTOMER.DOB
            END
        NEXT I.VAR

    END

    IF Y.RECORD.LIST THEN
        CALL BATCH.BUILD.LIST('', Y.RECORD.LIST)
    END

RETURN

*-----------------------------------------------------------------------------------
LEAP.YEAR.CHECK:
*-----------------------------------------------------------------------------------

    LAST.WORKING.MONTH = Y.LAST.WORKING.DAY[5,2]
    CURR.MONTH = Y.TODAY[5,2]
    FEB.MONTH.LEAP = '0229'
    R.CUSTOMER.DOB = ''
    Y.READ.ERR = ''
    L.YEAR = Y.TODAY[1,4]
    LEAP.YEAR = MOD(L.YEAR,4)
    IF LEAP.YEAR NE '0' THEN
        IF LAST.WORKING.MONTH NE CURR.MONTH AND LAST.WORKING.MONTH EQ '02' THEN
            CALL F.READ(FN.CUSTOMER.DOB, FEB.MONTH.LEAP, R.CUSTOMER.DOB, F.CUSTOMER.DOB, Y.READ.ERR)
            Y.RECORD.LIST := @FM : R.CUSTOMER.DOB
        END
    END
RETURN
*-----------------------------------------------------------------------------------
END
*-----------------------------------------------------------------------------------
