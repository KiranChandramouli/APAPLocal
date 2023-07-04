* @ValidationCode : MjotMTE2ODg5OTc3OTpDcDEyNTI6MTY4MjQxMjM0OTY1NTpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:49
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.INP.CLAIM.DATA.CONFIRMED
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
* DESCRIPTION : This Input routine is used to check if the CUSTOMER has
* any previous claims in the same PRODUCT & TYPE & TRANSACTIOn.AMOUNT. If the same claim exits
* then OVERRIDE is displayed
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : RENUGADEVI B
* PROGRAM NAME : REDO.V.INP.CLAIM.DATA.CONFIRMED
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE              WHO                REFERENCE         DESCRIPTION
* 25-AUG-2010       RENUGADEVI B       ODR-2009-12-0283  INITIAL CREATION
*05-05-2011         PRABHU             HD1100437         Line 48 modified to generate error in case data is not confirmed
* ----------------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*11-04-2023       Conversion Tool        R22 Auto Code conversion          = TO EQ
*11-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.ISSUE.CLAIMS
*
    GOSUB INIT
    GOSUB PROCESS
RETURN
*****
INIT:
*****
    FN.REDO.ISSUE.CLAIMS  = 'F.REDO.ISSUE.CLAIMS'
    F.REDO.ISSUE.CLAIMS   = ''
    CALL OPF(FN.REDO.ISSUE.CLAIMS,F.REDO.ISSUE.CLAIMS)
*
RETURN

********
PROCESS:
********
*
    IF R.NEW(ISS.CL.STATUS) EQ 'OPEN' THEN    ;*R22 AUTO CODE CONVERSION
        IF R.NEW(ISS.CL.DATA.CONFIRMED) NE 'YES' THEN
            AF    = ISS.CL.DATA.CONFIRMED
            ETEXT ='EB-REDO.CUSTOMER.DATA.CONFIRMED'
            CALL STORE.END.ERROR
        END
    END
RETURN
END
