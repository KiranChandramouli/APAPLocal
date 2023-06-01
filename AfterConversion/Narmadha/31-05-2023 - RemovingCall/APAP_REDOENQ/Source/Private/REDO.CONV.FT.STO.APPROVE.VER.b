* @ValidationCode : Mjo1Nzc0MjgzMTU6Q3AxMjUyOjE2ODIwNzg4NzEyOTA6SVRTUzotMTotMTo2ODU6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Apr 2023 17:37:51
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 685
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CONV.FT.STO.APPROVE.VER
*--------------------------------------------------------------------------
* DESCRIPTION: This routine is used to populate the reverse versions
*-----------------------------------------------------------------------------
* Modification History
* DATE         NAME          Reference        REASON
* 10-02-2012   SUDHARSANAN   PACS00178947     Initial creation
* 18-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 18-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_F.AI.REDO.PRINT.TXN.PARAM
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.STANDING.ORDER

    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN

***********
OPEN.FILES:
***********

    FN.AI.REDO.PRINT.TXN.PARAM = 'F.AI.REDO.PRINT.TXN.PARAM'
    F.AI.REDO.PRINT.TXN.PARAM = ''
    CALL OPF(FN.AI.REDO.PRINT.TXN.PARAM,F.AI.REDO.PRINT.TXN.PARAM)

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER$NAU'
    F.FUNDS.TRANSFER  = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.STANDING.ORDER = 'F.STANDING.ORDER$NAU'
    F.STANDING.ORDER  =  ''
    CALL OPF(FN.STANDING.ORDER,F.STANDING.ORDER)
RETURN
**********
PROCESS:
*********

    Y.TXN.ID = O.DATA
    IF Y.TXN.ID[1,2] EQ 'FT' THEN
        CALL F.READ(FN.FUNDS.TRANSFER,Y.TXN.ID,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,FUNDS.TRANSFER.ERR)
        Y.TXN.CODE  = R.FUNDS.TRANSFER<FT.TRANSACTION.TYPE>
        CALL F.READ(FN.AI.REDO.PRINT.TXN.PARAM,Y.TXN.CODE,R.AI.REDO.PRINT.TXN.PARAM,F.AI.REDO.PRINT.TXN.PARAM,PARAM.ERR)
        Y.FT.APP.COS = R.AI.REDO.PRINT.TXN.PARAM<AI.PRI.FT.APPROV.VERSION>
        O.DATA = 'COS ':Y.FT.APP.COS
    END ELSE
        CALL F.READ(FN.STANDING.ORDER,Y.TXN.ID,R.STANDING.ORDER,F.STANDING.ORDER,STANDING.ORDER.ERR)
        Y.TXN.CODE  = R.STANDING.ORDER<STO.PAY.METHOD>
        CALL F.READ(FN.AI.REDO.PRINT.TXN.PARAM,Y.TXN.CODE,R.AI.REDO.PRINT.TXN.PARAM,F.AI.REDO.PRINT.TXN.PARAM,PARAM.ERR)
        Y.STO.APP.COS = R.AI.REDO.PRINT.TXN.PARAM<AI.PRI.STO.APPROV.VERSION>
        O.DATA = 'COS ':Y.STO.APP.COS
    END

RETURN
*-------------------------------------------------------------------------------------------------------------------
END
