* @ValidationCode : Mjo0NjQ5ODY2MjA6Q3AxMjUyOjE2ODQ4NTQzODA3MTA6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:20
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

    DATE.NEXT.WORK = R.DATES(EB.DAT.NEXT.WORKING.DAY)
    SEL.AZ.ACCOUNT.CMD="SELECT ":FN.AZ.ACCOUNT:" WITH MATURITY.DATE GT ":TODAY:" AND MATURITY.DATE LE ":DATE.NEXT.WORK:" AND L.AZ.BAL.CONSOL NE ''"
    CALL EB.READLIST(SEL.AZ.ACCOUNT.CMD,SEL.AZ.ACCOUNT.LIST,'',NO.OF.REC,RET.CODE)
    CALL BATCH.BUILD.LIST('',SEL.AZ.ACCOUNT.LIST)
RETURN
END
