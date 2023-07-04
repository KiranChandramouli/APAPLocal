* @ValidationCode : MjotOTQ4NzA2OTM5OkNwMTI1MjoxNjg0ODM2MDM2MTkxOklUU1M6LTE6LTE6LTc6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:36
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -7
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.CONV.OVERRIDE

* Description: This routine is the nofile enquiry routine to fetch the details of
* account closure records in INAO status

*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 26-02-2011      H GANESH      PACS00034162    Initial Draft
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*12-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  SM to @SM
*12-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------
* ----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.TELLER.ID

    GOSUB PROCESS
RETURN

* ----------------------------------------------------------------------------
PROCESS:
* ----------------------------------------------------------------------------
    TEMP.REC = R.RECORD
    TEMP.OVERRIDE = R.RECORD<TT.TID.OVERRIDE>
    CHANGE @SM TO '*' IN TEMP.OVERRIDE
    R.RECORD<TT.TID.OVERRIDE> = TEMP.OVERRIDE
RETURN
END
