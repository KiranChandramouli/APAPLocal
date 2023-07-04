* @ValidationCode : MjotMTAwNDU3MzQwODpDcDEyNTI6MTY4NDQ5MTAyNTYxNTpJVFNTOi0xOi0xOi0yOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -2
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE DR.REG.213IF01.UPDATE.CONCAT.FILTER(REC.ID)
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   :
* Program Name   : DR.REG.213IF01.UPDATE.CONCAT
* Date           : 2-May-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the transaction made over 10000 USD by individual Customer
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date       Author              Modification Description
* 21-Mar-2015   Ashokkumar.V.P     PACS00309079:- Added AA overpayment details.
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*24-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   T24.BP,LAPAP.BP is removed , $INCLUDE to $INSERT
*24-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE ;*R22 AUTO CODE CONVERSION
    $INSERT I_BATCH.FILES
    $INSERT I_F.STMT.ENTRY

    $INSERT I_DR.REG.213IF01.UPDATE.CONCAT.COMMON ;*R22 AUTO CODE CONVERSION

    LOCATE REC.ID IN YSUSP.ACCT.NO<1,1> SETTING POSN THEN
        RETURN
    END

    IF NOT(NUM(REC.ID)) THEN
        REC.ID = '' ;* Only customer accounts to be considered.
    END

RETURN

*-----------------------------------------------------------------------------
END
