* @ValidationCode : MjotOTAxOTIxMDE0OkNwMTI1MjoxNjgxMzYyODY1MDUxOklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Apr 2023 10:44:25
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
    CALL BATCH.BUILD.LIST('',SEL.CUSTOMER.LIST)
RETURN
END
