* @ValidationCode : MjotMTAzMDc4NjMzODpDcDEyNTI6MTY4MTEwNzY5MjI3OTpzYW1hcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Apr 2023 11:51:32
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
SUBROUTINE REDO.V.AUT.STOCK.DETAILS
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Prabhu N
* Program Name : REDO.V.AUT.STOCK.DETAILS
*-----------------------------------------------------------------------------
* Description :
* Linked with :
* In Parameter :
* Out Parameter : None
*
**DATE           ODR                   DEVELOPER               VERSION
*
*18/10/11      PACS001002015          Prabhu N                MODIFICAION
*-----------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*10-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*10-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*------------------------------------------------------------------------------------------
 

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BENEFICIARY
    $INSERT I_System
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_F.STOCK.ENTRY


    GOSUB OPEN.FILES
    GOSUB UPD.STK.FILE
RETURN
*----------*
OPEN.FILES:
*-----------*
    FN.STK.DETAILS = "F.REDO.SAVE.STOCK.DETAILS"
    F.STK.DETAILS = ''
    CALL OPF(FN.STK.DETAILS,F.STK.DETAILS)

RETURN
*------------*
UPD.STK.FILE:
*------------*

    ID.TO.UPDATE = R.NEW(STO.ENT.STOCK.ACCT.NO)
    STK.ID.UPDATE = ID.NEW

    FILE.NAME = FN.STK.DETAILS
    YCONCAT.ID = ID.TO.UPDATE
    V$FIELD = STK.ID.UPDATE
    V$INS = 'I'
    AR.OR.AL = 'AL'
    IF ID.TO.UPDATE THEN
        CALL CONCAT.FILE.UPDATE(FILE.NAME,YCONCAT.ID,V$FIELD,V$INS,AR.OR.AL)
    END

RETURN
END
