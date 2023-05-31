* @ValidationCode : MjoxMjI1NDgxMjc5OkNwMTI1MjoxNjg0ODQ1NjIyOTcwOklUU1M6LTE6LTE6MTg0OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 18:10:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 184
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
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
