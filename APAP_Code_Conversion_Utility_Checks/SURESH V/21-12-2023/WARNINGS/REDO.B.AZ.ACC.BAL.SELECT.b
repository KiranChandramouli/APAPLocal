* @ValidationCode : MjotMTQzNDIwNTI3NzpDcDEyNTI6MTcwMzE0MjU1MDY1NTozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Dec 2023 12:39:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.AZ.ACC.BAL.SELECT
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SUDHARSANAN S
* Program Name  : REDO.B.AZ.ACC.BAL.SELECT
*-------------------------------------------------------------------------

* Description :This routine will form a list which will be processed
*               by the routine REDO.B.AZ.ACC.BAL

* In parameter : None
* out parameter : None
*-------------------------------------------------------------------------------------
*Modification
* Date                   who                   Reference
* 10-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - NO CHANGES
* 10-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*20/12/2023           Suresh              R22 Manual Conversion  CALL routine modified
*--------------------------------------------------------------------------------------
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.AZ.CUSTOMER
    $INSERT I_F.AZ.PRODUCT.PARAMETER
    $INSERT I_F.PERIODIC.INTEREST
    $INSERT I_REDO.B.AZ.ACC.BAL.COMMON
    $USING EB.Service ;*R22 Manual Conversion

    DATE.NEXT.WORK = R.DATES(EB.DAT.NEXT.WORKING.DAY)
    SEL.AZ.ACCOUNT.CMD="SELECT ":FN.AZ.ACCOUNT:" WITH MATURITY.DATE GT ":TODAY:" AND MATURITY.DATE LE ":DATE.NEXT.WORK:" AND L.AZ.BAL.CONSOL NE ''"
    CALL EB.READLIST(SEL.AZ.ACCOUNT.CMD,SEL.AZ.ACCOUNT.LIST,'',NO.OF.REC,RET.CODE)
*   CALL BATCH.BUILD.LIST('',SEL.AZ.ACCOUNT.LIST)
    EB.Service.BatchBuildList('',SEL.AZ.ACCOUNT.LIST) ;*R22 Manual Conversion
RETURN
END
