* @ValidationCode : Mjo0MDY4OTU1MTY6Q3AxMjUyOjE2ODI0MTIzNTQ2MjE6SGFyaXNodmlrcmFtQzotMTotMTowOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:54
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
SUBROUTINE REDO.V.TEMP.GET.PAY.METHOD
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :Edwin Charles D
*Program   Name    :REDO.V.TEMP.GET.PAY.METHOD
*---------------------------------------------------------------------------------

*DESCRIPTION       :It is attached as authorization routine in all the version used
*                  in the development N.83.If Credit card status is Back log then it will
*                  show an override message
*LINKED WITH       :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who           Reference                         Description
* 06-JUN-2017    Edwin Charles D     R15 Upgrade                     Initial Creation
*13-04-2023       Conversion Tool    R22 Auto Code conversion          No Changes
*13-04-2023       Samaran T         R22 Manual Code Conversion         No Changes
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_F.TELLER
    $INSERT I_F.COMPANY
    $INSERT I_F.REDO.FT.TT.TRANSACTION
*
    $INSERT I_F.REDO.INTERFACE.PARAMETER
*
    Y.COMP.CODE = R.COMPANY(EB.COM.SUB.DIVISION.CODE)[2,3]
    LREF.POS    = ''

*
    IF APPLICATION EQ 'REDO.FT.TT.TRANSACTION' THEN
        Y.PAY.METHOD = R.NEW(FT.TN.L.FT.SN.PAYMTHD)
        R.NEW(FT.TN.L.FT.SN.PAYMTHD) = Y.PAY.METHOD[1,5]:Y.COMP.CODE:Y.PAY.METHOD[9,4]
    END
RETURN
END
