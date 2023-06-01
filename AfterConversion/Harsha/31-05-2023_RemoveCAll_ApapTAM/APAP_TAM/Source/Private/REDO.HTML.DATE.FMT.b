* @ValidationCode : MjotNjM4OTIyNDQ2OkNwMTI1MjoxNjgxMjk1MjE1ODI4OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Apr 2023 15:56:55
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
SUBROUTINE REDO.HTML.DATE.FMT
*-----------------------------------------------------------------------------
*Company   Name    : APAP
*Developed By      : Martin Macias
*Program   Name    : REDO.HTML.DATE.FMT
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 12.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 12.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System

    FMT.DATE = O.DATA

    Y.STR.YEAR = FMT.DATE[1,4]
    Y.STR.MONTH = FMT.DATE[5,2]
    Y.STR.DAY = FMT.DATE[7,2]

    BEGIN CASE
        CASE Y.STR.MONTH  EQ "01"
            Y.STR.MONTH = 'ENE'
        CASE Y.STR.MONTH  EQ "02"
            Y.STR.MONTH = 'FEB'
        CASE Y.STR.MONTH  EQ "03"
            Y.STR.MONTH = 'MAR'
        CASE Y.STR.MONTH  EQ "04"
            Y.STR.MONTH = 'ABR'
        CASE Y.STR.MONTH  EQ "05"
            Y.STR.MONTH = 'MAY'
        CASE Y.STR.MONTH  EQ "06"
            Y.STR.MONTH = 'JUN'
        CASE Y.STR.MONTH  EQ "07"
            Y.STR.MONTH = 'JUL'
        CASE Y.STR.MONTH  EQ "08"
            Y.STR.MONTH = 'AGO'
        CASE Y.STR.MONTH  EQ "09"
            Y.STR.MONTH = 'SEP'
        CASE Y.STR.MONTH  EQ "10"
            Y.STR.MONTH = 'OCT'
        CASE Y.STR.MONTH  EQ "11"
            Y.STR.MONTH = 'NOV'
        CASE Y.STR.MONTH  EQ "12"
            Y.STR.MONTH = 'DIC'
    END CASE

    O.DATA = Y.STR.DAY :' ': Y.STR.MONTH :' ': Y.STR.YEAR

RETURN
END
