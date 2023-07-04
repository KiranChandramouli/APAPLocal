* @ValidationCode : MjoxMjI1NDgxMjc5OkNwMTI1MjoxNjgxMjg3NDgxODg0OnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Apr 2023 13:48:01
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.INP.TELLER.ID
*---------------------------------------------------------------------------------------
*DESCRIPTION: This routine will default the teller id for the from teller attach to the
*version of TELLER,REDO.TILL.TRNS
*---------------------------------------------------------------------------------------
*IN  :  -NA-
*OUT :  -NA-
*****************************************************
*COMPANY NAME : APAP
*DEVELOPED BY : DHAMU S
*PROGRAM NAME : REDO.V.INP.TELLER.ID
*----------------------------------------------------------------------------------------------
*Modification History:
*------------------------
*DATE               WHO                     REFERENCE                    DESCRIPTION
*10-6-2011         RIYAS                 ODR-2009-10-0525             INITIAL CREATION
*12-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*12-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-----------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.TELLER.ID

    GOSUB INIT
    GOSUB PROCESS
RETURN
******
INIT:
******

    FN.TELLER = 'F.TELLER'
    F.TELLER  = ''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.TELLER.ID = 'F.TELLER.ID'
    F.TELLER.ID  = ''
    CALL OPF(FN.TELLER.ID,F.TELLER.ID)
RETURN
********
PROCESS:
********
    Y.LCCY=LCCY
    Y.CCY=R.NEW(TT.TE.CURRENCY.1)
    IF Y.CCY NE Y.LCCY THEN
        R.NEW(TT.TE.AMOUNT.LOCAL.1) = ''
    END
RETURN
***************************************************************
END
*-----------------End of program--------------------------------------------------
