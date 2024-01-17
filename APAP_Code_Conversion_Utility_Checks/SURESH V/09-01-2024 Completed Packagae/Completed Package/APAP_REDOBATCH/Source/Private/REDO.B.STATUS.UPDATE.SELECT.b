* @ValidationCode : MjotMTczODM0NDUwOkNwMTI1MjoxNzA0NDQwNjI4MDA4OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Jan 2024 13:13:48
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
SUBROUTINE REDO.B.STATUS.UPDATE.SELECT
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : PRABHU N
* Program Name : REDO.B.STATUS.UPDATE.SELECT
*--------------------------------------------------------------------------------
* Description: Subroutine to perform the selection of the batch job
*
* Linked with   : None
* In Parameter  : None
* Out Parameter : SEL.CUSTOMER.LIST
*--------------------------------------------------------------------------------
* Modification History:
*02/01/2010 - ODR-2009-10-0535
*Development for Subroutine to perform the selection of the batch job
* Revision History:
*------------------
*   Date               who           Reference            Description
* 21-SEP-2011       Pradeeep S      PACS00090815          Credit Card status considered
*                                                         only for NON Prospect customer
* 29-Jan-2012      Gangadhar.S.V.  Perfomance Tuning  SELECT changed
* Date                  who                   Reference
* 13-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 13-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*--------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.STATUS.UPDATE.COMMON
    $USING EB.Service
    GOSUB INIT
    GOSUB SEL.REC
RETURN
*----
INIT:
*----
* 29-Jan-2012 - S
*    SEL.CUSTOMER.CMD="SELECT ":FN.CUSTOMER:" WITH CUSTOMER.TYPE NE PROSPECT"         ;* PACS00090815 - S/E
    SEL.CUSTOMER.CMD="SELECT ":FN.CUSTOMER
* 29-Jan-2012 - E
    SEL.CUSTOMER.LIST=''
    NO.OF.REC=''
RETURN
*-------
SEL.REC:
*-------
    CALL EB.READLIST(SEL.CUSTOMER.CMD,SEL.CUSTOMER.LIST,'',NO.OF.REC,AZ.ERR)
*    CALL BATCH.BUILD.LIST('',SEL.CUSTOMER.LIST)
    EB.Service.BatchBuildList('',SEL.CUSTOMER.LIST);* R22 UTILITY AUTO CONVERSION
RETURN
END
