* @ValidationCode : MjotNzgwNzY1Mjg5OkNwMTI1MjoxNzA0NDQ1NTQ0MTQ4OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Jan 2024 14:35:44
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
SUBROUTINE REDO.B.TRANSIT.CAP.SELECT

*****************************************************************************************
*----------------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : KAVITHA
* Program Name  : REDO.B.TRANSIT.CAP.SELECT
*-----------------------------------------------------------------------------------------
* Description:
* This routine is a multithreaded routine to select the records in the mentioned applns
*------------------------------------------------------------------------------------------
* Linked with:
* In parameter :
* out parameter : None
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE              REFERENCE            DESCRIPTION
* 02-04-2012       ODR-2010-09-0251     INITIAL CREATION
* Date                  who                   Reference
* 13-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 13-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*18/01/2024         Suresh                 R22 UTILITY AUTO CONVERSION   CALL routine Modified
*------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.TRANSIT.CAP.COMMON
    $USING EB.Service


    SEL.CMD = ''
    LIST.INTEREST = ''
    BATCH.LIST.IDS = ''
    LOC.ID.VARIABLE = ''

    SEL.CMD = "SELECT ":FN.REDO.TRANUTIL.INTAMT
    CALL EB.READLIST(SEL.CMD,LIST.INTEREST,'',NO.OF.REC,ERR)

*    CALL BATCH.BUILD.LIST('',LIST.INTEREST)
    EB.Service.BatchBuildList('',LIST.INTEREST);* R22 UTILITY AUTO CONVERSION
 
RETURN
*------------------------------------------------------------------------------------------
END
