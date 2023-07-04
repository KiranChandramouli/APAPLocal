* @ValidationCode : MjotMTk3Njg5NTc4MjpDcDEyNTI6MTY4MjA3MzM4MjI4NjpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Apr 2023 16:06:22
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
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.BLD.FXSN.RTN(ENQ.DATA)
*----------------------------------------------------------------------------------------------------
* DESCRIPTION : This is a BUILD routine for the NOFILE ENQUIRY REDO.ENQ.FXSN.DETAILS, to select all sequence number IDs from REDO.FOREX.SEQ.NUM table
*               incase if not provided with a selection criteria
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* In Parameter    : ENQ.DATA
* Out Parameter   : ENQ.DATA
*-----------------------------------------------------------------------------------------------------
* Company Name : APAP
* Developed By : Chandra Prakash T
* Program Name : REDO.E.BLD.FXSN.RTN
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date             Who                   Reference         Description
* 11-Jun-2010      Chandra Prakash T     ODR-2010-01-0213  Initial Creation
*
* 13-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 17-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    ENQ.VALUES = ENQ.DATA<3>

    LOCATE "SEQUENCE.NUMBER" IN ENQ.DATA<2> SETTING SEQ.NUM.POS ELSE

        ENQ.DATA<2,-1> = "SEQUENCE.NUMBER"
        ENQ.DATA<3,-1> = 'NE'
        ENQ.DATA<4,-1> = ''
        D.RANGE.AND.VALUE<1> = ''
    END

RETURN

END
