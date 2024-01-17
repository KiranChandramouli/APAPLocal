* @ValidationCode : MjotNzM1MDA5NDE6Q3AxMjUyOjE3MDMyMjA0MjQxNTQ6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 22 Dec 2023 10:17:04
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.CHECK.INT.RATE.SELECT
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : PRABHU N
* Program Name : REDO.B.CHECK.INT.RATE.SELECT
*--------------------------------------------------------------------------------
*Description: Subroutine to perform the selection of the batch job

* Linked with   : None
* In Parameter  : None
* Out Parameter : SEL.AZ.ACCOUNT.LIST
*--------------------------------------------------------------------------------
*Modification History:
*09/12/2009 - ODR-2009-10-0537
*Development for Subroutine to perform the selection of the batch job
**********************************************************************************
*  DATE             WHO         REFERENCE         DESCRIPTION
* 26 Mar 2011    GURU DEV      PACS00033054      Modified as per issue
* Date                  who                   Reference
* 10-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 10-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*21/12/2023         Suresh                R22 Manual Conversion   CALL routine modified

*--------------------------------------------------------------------------------
    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.DATES
    $INSERT I_REDO.B.CHECK.INT.RATE.COMMON
    
    $USING EB.Service ;*R22 Manual Conversion


    SEL.AZ.ACCOUNT.CMD="SELECT " : FN.AZ.ACCOUNT : " WITH MATURITY.DATE GT " : TODAY : " AND MATURITY.DATE LE " : R.DATES(EB.DAT.NEXT.WORKING.DAY) : " AND L.AZ.BAL.CONSOL EQ ''"

    CALL EB.READLIST(SEL.AZ.ACCOUNT.CMD,SEL.AZ.ACCOUNT.LIST,'',NO.OF.REC,AZ.ERR)
*    CALL BATCH.BUILD.LIST('', SEL.AZ.ACCOUNT.LIST)
    EB.Service.BatchBuildList('', SEL.AZ.ACCOUNT.LIST) ;*R22 Manual Conversion

RETURN
END
