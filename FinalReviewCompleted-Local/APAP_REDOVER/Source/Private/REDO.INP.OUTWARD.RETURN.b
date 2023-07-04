* @ValidationCode : MjoxMDk2NzYwMTA6Q3AxMjUyOjE2ODI0MTIzMzE0NjE6SGFyaXNodmlrcmFtQzotMTotMTowOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:31
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
SUBROUTINE REDO.INP.OUTWARD.RETURN
*---------------------------------------------------------
*Description: This routine is to raise override in case if the cheque is already cleared
*              and return file has arrived
*---------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*06-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*06-04-2023       Samaran T              R22 Manual Code Conversion        No Changes
*----------------------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CLEARING.OUTWARD

    GOSUB PROCESS
RETURN
*---------------------------------------------------------
PROCESS:
*---------------------------------------------------------

    IF R.NEW(CLEAR.OUT.CHQ.STATUS) EQ 'CLEARED' AND R.NEW(CLEAR.OUT.TFS.REFERENCE) NE 'PAYMENT' THEN
        CURR.NO = 1
        TEXT = 'EB-REDO.CHQ.CLEARED'
        CALL STORE.OVERRIDE(CURR.NO)

    END
RETURN

END
