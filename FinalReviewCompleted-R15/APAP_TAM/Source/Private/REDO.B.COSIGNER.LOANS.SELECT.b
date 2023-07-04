* @ValidationCode : MjoxMzM0NDA0NTczOkNwMTI1MjoxNjgzMDM0MjUxNDQ5OklUU1M6LTE6LTE6LTEyOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 02 May 2023 19:00:51
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -12
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.B.COSIGNER.LOANS.SELECT
*-----------------------------------------------------------------------------------------------------------------
* Description           : This routine is used to select Arrangement records using the fields PRODCT.LINE,PRODUCT.GROUP,
*                         PRODUCT and ARR.STATUS
*
* Developed By          : Saranraj S
*
* Development Reference : DE04
*
* Attached To           : BATCH>BNK/.B.COSIGNER.LOANS
*
* Attached As           : Batch Routine
*-----------------------------------------------------------------------------------------------------------------
*------------------------
* Input Parameter:
* ---------------*
* Argument#1 : NA
* Argument#2 : NA
* Argument#3 : NA
*-----------------------------------------------------------------------------------------------------------------
*-----------------*
* Output Parameter:
* ----------------*
* Argument#4 : NA
* Argument#5 : NA
* Argument#6 : NA
*-----------------------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*(RTC/TUT/PACS)                                        (YYYY-MM-DD)
*-----------------------------------------------------------------------------------------------------------------
* PACS00325162           Ashokkumar.V.P                 04/11/2014            Additional AA product and fixed field issue
* PACS00460181           Ashokkumar.V.P                 26/05/2015            Changes the fields based on new mapping

*
* Date             Who                   Reference      Description
* 24.04.2023       Conversion Tool       R22            Auto Conversion     - INSERT file folder name removed T24.BP & LAPAP.BP
* 24.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*

*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON                                   ;** R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_REDO.B.COSIGNER.LOANS.COMMON            ;** R22 Auto conversion - END

    GOSUB PROCESS
RETURN
*-------
PROCESS:
*-------
    CALL EB.CLEAR.FILE(FN.DR.REG.DE04.WORKFILE, F.DR.REG.DE04.WORKFILE)
    LIST.PARAMETER = ''

*    Y.LAST.WORK.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
    LIST.PARAMETER<2> = "F.AA.ARRANGEMENT"
*    LIST.PARAMETER<3> = "START.DATE LE ":Y.LAST.WORK.DAY
*    LIST.PARAMETER<3> := " AND (PRODUCT.GROUP EQ ":"CONSUMO":" OR PRODUCT.GROUP EQ ":"COMERCIAL":" OR PRODUCT.GROUP EQ ":"HIPOTECARIO":" OR PRODUCT.GROUP EQ ":"LINEAS.DE.CREDITO":")"
    LIST.PARAMETER<3> := "PRODUCT.LINE EQ ":"LENDING"
*    LIST.PARAMETER<3> := " AND ((ARR.STATUS EQ ":"CURRENT":") OR (ARR.STATUS EQ ":"EXPIRED":"))"
    CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")

RETURN
*-------------------------------------------End Of Record------------------------------------------------------------
END
