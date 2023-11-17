* @ValidationCode : MjoxMjI3NjA5NDU2OkNwMTI1MjoxNjgwNjkwNDYxNjM1OklUU1M6LTE6LTE6LTc6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Apr 2023 15:57:41
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
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.BALANCE.BUILD.LETTER.RTN(ENQ.DATA)
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.BUILD.LETTER.RTN
* ODR NO      : ODR-2009-10-0838
*----------------------------------------------------------------------

*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH: REDO.LETTER.ISSUE
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE         	          WHO           REFERENCE           DESCRIPTION
*18.03.2010 		 H GANESH      ODR-2009-10-0838       INITIAL CREATION
* 04-APR-2023       Conversion tool   R22 Auto conversion   VM to @VM
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ENQUIRY
    $INSERT I_F.REDO.LETTER.ISSUE


    GOSUB INIT
RETURN

*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------

    POS1= DCOUNT(ENQ.DATA<2,1>,@VM)
    Y.CUSTOMER.ID = R.NEW(REDO.LET.ISS.CUSTOMER.ID)
    ENQ.DATA<2,POS1+1>='@ID'
    ENQ.DATA<3,POS1+1>='EQ'
    ENQ.DATA<4,POS1+1>=Y.CUSTOMER.ID
RETURN

END
