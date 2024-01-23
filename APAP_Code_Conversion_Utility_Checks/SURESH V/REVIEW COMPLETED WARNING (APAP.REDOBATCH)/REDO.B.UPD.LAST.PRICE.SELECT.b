* @ValidationCode : Mjo2ODgyMTg4OkNwMTI1MjoxNzA0NDQ2NjQyNjczOjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Jan 2024 14:54:02
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
SUBROUTINE REDO.B.UPD.LAST.PRICE.SELECT
*-----------------------------------------------------------------------------------------------
* Company Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed by    : Temenos Application Management
* Program Name    : REDO.B.UPD.LAST.PRICE.SELECT
* Program Type    : BATCH JOB (Multithreaded routine)
*-----------------------------------------------------------------------------------------------
* Description   : This is the Select routine in which we will select all the SECURITY.MASTER and
*                 pass it to the BATCH.BUILD.LIST
*
* In  Parameter : --na--
* Out Parameter : --na--
* ODR Number    : ODR-2010-07-0083
*--------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*
* 18.11.2010      Krishna Murthy T.S     SC006         INITIAL CREATION
* Date                  who                   Reference
* 13-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 13-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*
*18/01/2024         Suresh                 R22 UTILITY AUTO CONVERSION   CALL routine Modified
*-------------------------------------------------------------------------------------------------
    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_F.SECURITY.MASTER
    $INSERT I_F.DATES
    $INSERT I_REDO.B.UPD.LAST.PRICE.COMMON
    $USING EB.Service
 
    Y.TODAY = R.DATES(EB.DAT.NEXT.WORKING.DAY)
    SEL.CMD = "SELECT ":FN.SECURITY.MASTER:" WITH MATURITY.DATE LE ":Y.TODAY
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)

*    CALL BATCH.BUILD.LIST('',SEL.LIST)
    EB.Service.BatchBuildList('',SEL.LIST);* R22 UTILITY AUTO CONVERSION
RETURN
END
