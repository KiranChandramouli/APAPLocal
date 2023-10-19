* @ValidationCode : MjotMzU2MDI4NzQ6Q3AxMjUyOjE2ODI0MTIzNjY1MjE6SGFyaXNodmlrcmFtQzotMTotMTowOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:16:06
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
SUBROUTINE REDO.V.WAIVE.COMMISION
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.V.WAIVE.COMMISION
*--------------------------------------------------------------------------------------------------------
*Description  : This routine is used to waive the commision in case account is own account
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference                      Description
*   ------         ------               -------------                     -------------
* 29 Oct 2010     SWAMINATHAN          ODR-2009-12-0290                Initial Creation
*17-04-2023       Conversion Tool      R22 Auto Code conversion          IF CONDITION ADDED
*17-04-2023       Samaran T            R22 Manual Code Conversion        No Changes
 
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.STANDING.ORDER
    $INSERT I_System

*--------------------------------------------------------------------------------------------------------
    GOSUB PROCESS
RETURN
*--------------------------------------------------------------------------------------------------------

PROCESS:
*********

    Y.OWN.ACCOUNT=System.getVariable("CURRENT.USER.CAT")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN    ;*R22 AUTO CODE CONVERSION.START
        Y.OWN.ACCOUNT = ""   ;*R22 AUTO CODE CONVERSION
    END    ;*R22 AUTO CODE CONVERSION.END
    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        IF Y.OWN.ACCOUNT EQ 'YES' THEN
            R.NEW(FT.COMMISSION.CODE) = 'WAIVE'
        END
    END
    IF APPLICATION EQ 'STANDING.ORDER' THEN
        IF Y.OWN.ACCOUNT EQ 'YES' THEN
            R.NEW(STO.COMMISSION.CODE) = 'WAIVE'
        END
    END
RETURN
*------------------------------------------------------------------------------------------------------------
END
