* @ValidationCode : MjotMjg3NTYyNzU3OkNwMTI1MjoxNjgyMDczMzgzMDY1OklUU1M6LTE6LTE6LTc6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Apr 2023 16:06:23
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
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CONV.OPEN.DAYS
*----------------------------------------------------------------------------------------------------
* DESCRIPTION : A Conversion routien to the date difference between OPENING.DATE and RESOLUTION.DATE
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : PRADEEP S
* PROGRAM NAME : REDO.E.CONV.OPEN.DAYS
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE              WHO                REFERENCE         DESCRIPTION
* 16-MAY-2011       PRADEEP SO         PACS00060849      INITIAL CREATION
*
* 17-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 17-APR-2023      Harishvikram C   Manual R22 conversion      No changes
* ----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.ISSUE.COMPLAINTS

    GOSUB PROCESS
RETURN

********
PROCESS:
********

    Y.OPEN.DATE = R.RECORD<ISS.COMP.OPENING.DATE>
    Y.RESOLVE.DATE = R.RECORD<ISS.COMP.DATE.RESOLUTION>

    IF Y.OPEN.DATE NE ''  AND Y.RESOLVE.DATE NE '' THEN
        NO.OF.DAYS = 'C'
        CALL CDD('',Y.OPEN.DATE,Y.RESOLVE.DATE,NO.OF.DAYS)
        O.DATA = ABS(NO.OF.DAYS)
    END

RETURN
